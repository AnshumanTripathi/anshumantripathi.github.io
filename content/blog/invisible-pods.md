---
title: "Pods can go invisible in Kubernetes. Let's find them"
subtitle: "Kubernetes pods can become invisible to kubectl, creating security risks. A hands-on tutorial explaining how this can happen and its consequences"
date: 2025-10-25T12:35:25-07:00
draft: false
categories:
- tutorial
tags:
- kubernetes
- kubernetes-security
- container-security
pagefindWeight: "0.1"
slug: invisible-pods
---

In Kubernetes, pods can become completely invisible to `kubectl get pods -A` while still running containers on the nodes. This behavior allows attackers to use it for persistence on exploited Kubernetes clusters.

I discovered this scenario through [an exercise on Ivan Velichko's platform](https://labs.iximiuz.com/challenges/kubernetes-invisible-pod-0bf2109b) by [Mark Sagi-Kazar](https://sagikazarmark.com/) which is based on [a talk by Rory McCune](https://www.youtube.com/watch?v=GtrkIuq5T3M) about Kubernetes security. Both are excellent resources for learning about concepts that are not widely known. Ivan's platform https://iximiuz.com/en/ provides great hands-on labs covering fundamentals of Containers, Networking, Linux, Kubernetes and more.

> Before moving forward I would recommend attempting the exercise and trying to find the solution.

## Concepts

Before we dig into solving the exercise let's touch on some important concepts in Kubernetes. At this point I assume the reader has a working understanding of Kubernetes. If needed I would recommend going through my previous post about [Kubernetes Concepts](/blog/understanding-kubernetes).

### Kubelet

The Kubelet in Kubernetes runs outside the jurisdiction of the Kubernetes cluster. It runs as a systemd service on a Kubernetes node. This is because an external service is needed to manage and orchestrate containers which themselves are not containers.

This allows the Kubelet to bootstrap key control plane components on control plane nodes like the api-server, etcd, scheduler and controller-manager as [static pods](#static-pods). Once these critical components are up and running _the kubelet registers the static pods as [mirror pods](#mirror-pods) on the api-server_.


### Static Pods

Static pods are pods managed by the kubelet which are created from manifests added in path `/etc/kubernetes/manifests/` on the node. Any Pod manifest added here will be used by the kubelet to create a mirror pod.

### Mirror Pods

Mirror pods are entries of a static pod in the api-server. These are only references to the actual static pods. 
This means doing kubectl operations like edit, delete, etc. would not affect the pod because the Kubelet treats the manifest present on the node as the source of truth. 
The kubectl commands on the other hand send requests to the api-server and try to update the mirror pod. After the saved update, the kubelet detects changes, applies the changes from its manifest and sends the updated information to the api-server.

{{< img src="diagrams/static-pods.excalidraw.png" caption="static pods and mirror pods" loading="lazy" decoding="async" width="100%">}}

## Invisible Pods

Now that we understand about static pods and mirror pods, let's see how we can make a pod invisible. You can find all following examples in this git repo - https://github.com/AnshumanTripathi/invisible-pods.


Let's create a [KinD](https://kind.sigs.k8s.io/) cluster for our exercise

```yaml
kind: Cluster
name: test-cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
  - role: control-plane
  - role: worker
    extraMounts:
      - hostPath: ./static-pod.yaml
        containerPath: /etc/kubernetes/manifests/static-pod.yaml
        readOnly: false
  - role: worker
```

This sets up a Kubernetes cluster with a control plane node and a worker node running a static pod. Here is the manifest of the static pod

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: podinfo
  labels:
    app: podinfo
spec:
  containers:
  - name: podinfo
    image: stefanprodan/podinfo:latest
    ports:
    - containerPort: 9898
      protocol: TCP
    resources:
      requests:
        memory: "64Mi"
        cpu: "100m"
      limits:
        memory: "128Mi"
        cpu: "200m"
```

This sets up a pod in the _default_ namespace running a [podinfo container](https://github.com/stefanprodan/podinfo).
We can see the pod is a static pod since it is managed by the Node (Kubelet).

```
❯ kubectl get pod podinfo-test-cluster-worker -o jsonpath="{.metadata.ownerReferences[0].kind}"
Node%
```

Now let's change the namespace of the static pod. To update the static pod, either change the static-pod.yaml, delete the kind cluster with `kind delete cluster --name test-cluster` and recreate the cluster.
The other way to do it is to use `kubectl debug` as follows:

```
❯ kubectl debug node/test-cluster-worker -it --image ubuntu --profile sysadmin -- chroot /host bash
Creating debugging pod node-debugger-test-cluster-worker-4brfr with container debugger on node test-cluster-worker.
All commands and output from this session will be recorded in container logs, including credentials and sensitive information passed through the command prompt.
If you don't see a command prompt, try pressing enter.
root@test-cluster-worker:/# whoami
root
```

Now edit and save the manifest at `/etc/kubernetes/manifests/static-pod.yaml` and add `metadata.namespace: podinfo`.
Once we add the namespace and try to get pods `kubectl get pods` we do not see the pod anymore! What does this mean?
The pod is still running on the node, but since the `podinfo` namespace does not exist, the kubelet cannot create a mirror pod in the api-server.
This causes the pod to be invisible to `kubectl get pods` (which queries the api-server), even though the container is still running on the node.

Now let's create the namespace

```
❯ kubectl create ns podinfo
namespace/podinfo created
```

And now we check for pod in the namespace

```
❯ kubectl -n podinfo get pods
NAME                          READY   STATUS    RESTARTS   AGE
podinfo-test-cluster-worker   1/1     Running   0          58s
```

It becomes visible again because the mirror pod was successfully created.

## Conclusion

Static pods are a core concept in Kubernetes clusters but they have the potential to create security risks. They can cause pods to become invisible to `kubectl` by referencing non-existent namespaces allowing attackers to remain hidden in the compromised Kubernetes cluster.

To detect this and other anomalies, always have auditing enabled on the Kubernetes cluster so that the administrators can track Kubelet and API Server activities. Additionally, regularly inspect Kubernetes node processes using `kubectl debug node` to catch unknown processes running on a node.

For more on attacker persistence strategies, see [Rory McCune's presentation](https://youtu.be/GtrkIuq5T3M). To dive deeper into Kubernetes fundamentals, check out my [Kubernetes Concepts guide](/blog/understanding-kubernetes).
