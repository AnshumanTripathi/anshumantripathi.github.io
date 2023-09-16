---
title: "Understanding Kubernetes (Part 1)"
subtitle: "Demystifying Kubernetes and unveiling its secrets"
date: 2023-06-04T18:28:43-07:00
draft: false
series:
- samyak
categories:
- concepts
tags:
- kubernetes
---

<!-- TOC -->
* [Introduction](#introduction)
* [Understanding Kubernetes](#understanding-kubernetes)
  * [Control Plane](#control-plane)
    * [API Server](#api-server)
    * [etcd](#etcd)
    * [Scheduler](#scheduler)
    * [kube-proxy](#kube-proxy)
    * [kube-dns](#kube-dns)
    * [Controller Manager](#controller-manager)
    * [Cloud Controller Manager](#cloud-controller-manager)
    * [Kubelet](#kubelet)
    * [Nodes](#nodes)
  * [Worker Plane](#worker-plane)
    * [Controllers](#controllers)
      * [Deployment](#deployment)
        * [Replicasets](#replicasets)
      * [DaemonSets](#daemonsets)
      * [StatefulSets](#statefulsets)
      * [CronJobs](#cronjobs)
    * [Storage](#storage)
      * [Persistent Volumes](#persistent-volumes)
    * [Autoscaling components](#autoscaling-components)
      * [Cluster Autoscaler](#cluster-autoscaler)
      * [Horizontal Pod Autoscaler](#horizontal-pod-autoscaler)
      * [Vertical Pod Autoscaler](#vertical-pod-autoscaler)
* [References](#references)
<!-- TOC -->

# Introduction
Kubernetes is all in the rage in the Software Engineering industry. Everyone wants to use it and most times we successfully make it work but when it does not work the way we think it should, it suddenly becomes the occult. Let us take a moment to understand how it works and how we can use to deploy applications seamlessly.
So what is Kubernetes? As [official documentation mentions, it allows you to do "Production-Grade Container Orchestration",](https://kubernetes.io) but does this really mean? Well, lets take a step back. At this point I hope you understand what is a container (if not refer [my other post explaining containers](/blog/containers)), but in short, a container to run a process in isolation, allowing you as an application developer to create an image for your application and have _some confidence_ that it is going to run the same way on every environment as it runs on your machine. There are many tools that allow you to create an image for your application and spin a container from it such as podman, containerd, cri-o, docker, etc. (Anyone was has been working in the software development industry within the last 5 years should've atleast heard of Docker).
Now that you have a container for you application you can use this image to deploy to production, but, we still need a figure out 
1. Where is this container going to run? 
2. How is the underlying infrastructure setup? 
3. How is the network stack setup?
4. If there is a surge or drop in the traffic that my application takes, how can we efficiently scale up or down?
5. How do you manage configurations and secrets used by your application?

Creating containers is easy and to an extent reproducible, but there is still a lot to figure out on how to handle issues like the ones mentioned above. All of these issues falls into _orchestration_. Kubernetes can help you manage all of these problems in a scalable manner.

# Understanding Kubernetes
Lets take a look at different kinds of components available in Kubernetes.

{{< img src="images/kubernetes.png" caption="Elements in Kubernetes" loading="lazy" decoding="async" width="100%">}}

Pods are the smallest deployable units of computing that you can create and manage in Kubernetes [^1]. Pods can hold one or more containers, and they define the specifications of executing the containers. A Pod is similar to a set of containers with shared namespaces and shared filesystem volumes. [Read more Linux containers in my other blog post.](/blog/containers)

## Control Plane
A kubernetes control plane is a collection of services which manage all operations and elements on the worker plane in the Kubernetes cluster. It can be thought of as the brains of the Kubernetes cluster. To understand how Kubernetes works under the hood, it is vital to understand how the control plane functions. Services like GKE (Google Kubernetes Engine), EKS (Elastic Kubernetes Service), AKS (Azure Kubernetes Service), provide Kubernetes clusters where the control plane is managed by the cloud providers so the developers can focus on their application rather than managing the kubernetes infrastructure. The key elements of the control plane are as follows:

### API Server
The API server, exposes the Kubernetes API which is required to interact with the Kubernetes cluster. The main implementation of a Kubernetes API server is kube-apiserver. kube-apiserver is designed to scale horizontally—that is, it scales by deploying more instances. You can run several instances of kube-apiserver and balance traffic between those instances. [^2]
When using private clusters with cloud provided services like GKE, AKS and EKS, the access to the API cluster would require setting up VPC peering and opening the required firewall rules so because the control plane will be running the cloud provider's VPC. 

### etcd
[etcd is a distributed and reliable key value store](https://etcd.io). etcd in the control stores all the cluster data including the cluster state. If you

### Scheduler
The Kubernetes scheduler monitors newly created pods with no assigned nodes and selects the node the run the pods on by considering resource requirements, controller type of the pod, node affinity/anti-affinity, data locality, hardware/software policy constraints, inter-workload interface and deadlines.[^6]
kube-scheduler is the implementation of the Scheduler.

### kube-proxy
Kubernetes [pods](#pods) are ephemeral in nature, so IP addresses cannot be relied upon for sending request to a container inside a pod. kube-proxy solves this problem maintaining network rules on every kubernetes node which allow network communication to the pods from network sessions. kube-proxy uses the operating system packet filtering layer if there is one and it's available. Otherwise, kube-proxy forwards the traffic itself [^9]. 
As the size of the Kubernetes clusters increases and number of nodes increases, the size of IP tables managed by kube-proxy also increases exponentially because it needs to kube-proxy running on every node needs to manage the routing rules of pods running on all the other nodes. In such cases, using network policies like [Calico](https://docs.tigera.io) can help in scaling up a Kubernetes cluster. 

### kube-dns
kube-dns is an DNS server running on the kubernetes cluster. It is responsible for resolving DNS names for pods and services. kube-dns also provides caching for DNS queries to improve performance. Kublet configures pod's DNS so that containers can lookup Services by name rather than IP. [See Kubernetes documentation of more details on Kubernetes DNS addons.](https://kubernetes.io/docs/concepts/services-networking/dns-pod-service/) 

### Controller Manager
Controller manager is the component that runs all the controller processes. Logically, each controller is a separate process, but to reduce complexity, they are all compiled into a single binary and run in a single process.

There are many types of controllers. Some examples of them are:

Node controller: Responsible for noticing and responding when nodes go down.
Job controller: Watches for Job objects that represent one-off tasks, then creates Pods to run those tasks to completion.
EndpointSlice controller: Populates EndpointSlice objects (to provide a link between Services and Pods).
ServiceAccount controller: Create default ServiceAccounts for new namespaces.
The above is not an exhaustive list. [^7]

### Cloud Controller Manager
Cloud controller manager is an extension of the controller manager which every cloud provider implements based on their infrastructure setup to provide services like GKE, EKS and AKS. 

### Kubelet
The kubelet is the primary "node agent" that runs on each node. It can register the node with the api-server using one of: the hostname; a flag to override the hostname; or specific logic for a cloud provider [^4]. A kubelet is setup and managed by the Kubernetes administrator or the Cloud Provider of the managed Kubernetes service.

### Nodes
Nodes are instances which physically (or virtually) support the execution of instances. All nodes are managed by the control plane manage pod scheduling. Each node have a kubelet process running on it which connects to the control plane and registers itself. Nodes can be managed individually or through a node-pool. [^3]

## Worker Plane
### Controllers
#### Deployment
A kubernetes deployment defines the desired state of a stateless application [^5]. A deployment manages replicasets which in turn control pods. Deployments can allow you to:
1. Rollout updates to your pods.
2. Rollback changes to your pods.
3. Scale up or down to facilitate more loads.
4. Pause rollout of your deployments.
5. Cleanup old replicasets that are not needed anymore.

##### Replicasets
A ReplicaSet's purpose is to maintain a stable set of replica Pods running at any given time. As such, it is often used to guarantee the availability of a specified number of identical Pods. A ReplicaSet is defined with fields, including a selector that specifies how to identify Pods it can acquire, a number of replicas indicating how many Pods it should be maintaining, and a pod template specifying the data of new Pods it should create to meet the number of replicas criteria. A ReplicaSet then fulfills its purpose by creating and deleting Pods as needed to reach the desired number. When a ReplicaSet needs to create new Pods, it uses its Pod template [^3].
It is recommended to use deployments to manage pods through replicasets.

#### DaemonSets
Daemonsets are used to make sure a set of pods gets scheduled on all the available nodes. Daemonsets are generally used for monitoring applications which are responsible to run on all nodes and collect logs and metrics. Some examples are [Datadog agent](https://github.com/DataDog/helm-charts/blob/2fc2c758ca8d7947807174ee5db626148dfddf85/charts/datadog/templates/daemonset.yaml#L5) and [kube-proxy](https://cloud.google.com/kubernetes-engine/docs/concepts/network-overview#kube-proxy).

#### StatefulSets
StatefulSet manages the deployment and scaling of a set of [pods](#pods) and provides guarantees about the ordering nad uniqueness of these pods.
Like a Deployment, a StatefulSet manages Pods that are based on an identical container spec. Unlike a Deployment, a StatefulSet maintains a sticky identity for each of its Pods. These pods are created from the same spec, but are not interchangeable: each has a persistent identifier that it maintains across any rescheduling.
If you want to use storage volumes to provide persistence for your workload, you can use a StatefulSet as part of the solution. Although individual Pods in a StatefulSet are susceptible to failure, the persistent Pod identifiers make it easier to match existing volumes to the new Pods that replace any that have failed. [^10]

#### CronJobs
CronJobs are used to create jobs at regular intervals. CronJobs are helpful when creating jobs like scheduled backups, cleanups, report generation etc. One CronJob object is like one line of a crontab (cron table) file on a Unix system. It runs a job periodically on a given schedule, written in Cron format. CronJobs have limitations and idiosyncrasies. For example, in certain circumstances, a single CronJob can create multiple concurrent Jobs. [Before using a CronJob always be sure to check for CronJob limitations in the official Kubernetes documentation.](https://kubernetes.io/docs/concepts/workloads/controllers/cron-jobs/#cron-job-limitations)  

### Storage
#### Persistent Volumes
[Read more about Persistent Volumes on my other post](/blog/k8s-persistent-volumes)

### Fault Tolerance
#### PodDisruptionBudget
A pod disruption event happens when for some reason pods disappear or are unable to get scheduled on nodes. This be because of involuntary disruption (hardware failures, accidental deletion of VMs by cluster admins, a kernel panic, eviction of a pod because of node running out of resources, etc.) or voluntary disruptions (draining a node for repair or upgrades, updating pod's deployment pod template causing a restart, etc.).
PodDisruptionBudgets (PDBs) are used to handle these disruptive events by specifying the minimum of pods of to always be available during these events.  A PDB limits the number of Pods of a replicated application that are down simultaneously from voluntary disruptions. For example, a quorum-based application would like to ensure that the number of replicas running is never brought below the number needed for a quorum.

### Autoscaling components
#### Cluster Autoscaler
Kubernetes cluster autoscaler is a component in Kubernetes that adjusts the size of the Kubernetes cluster so that all the pods can be properly scheduled on the Kubernetes nodes.'

#### Horizontal Pod Autoscaler
Horizontal Pod Autoscaler (HPA) is used to scale up the number of pods based on cpu and memory metrics.

#### Vertical Pod Autoscaler
Vertical Pod Autoscaler (VPA) is the component which scales the available cpu and memory of kubernetes nodes based on consumption of cpu and memory of the existing pods.


# References
[^1]: https://kubernetes.io/docs/concepts/workloads/pods/
[^2]: https://kubernetes.io/docs/concepts/overview/components/#kube-apiserver
[^3]: https://kubernetes.io/docs/concepts/overview/components/#kube-controller-manager
[^4]: https://kubernetes.io/docs/concepts/architecture/nodes/
[^5]: https://kubernetes.io/docs/reference/command-line-tools-reference/kubelet/
[^6]: https://kubernetes.io/docs/concepts/workloads/controllers/deployment/
[^7]: https://kubernetes.io/docs/concepts/workloads/controllers/replicaset/
[^8]: https://kubernetes.io/docs/concepts/overview/components/#kube-scheduler
[^9]: https://kubernetes.io/docs/concepts/overview/components/#kube-proxy
[^10]: https://kubernetes.io/docs/concepts/workloads/controllers/statefulset/


