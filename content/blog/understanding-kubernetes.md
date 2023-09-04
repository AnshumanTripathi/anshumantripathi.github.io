---
title: "Understanding Kubernetes"
subtitle: "Demystifying Kubernetes and unveil its secrets"
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
* [Glossary](#glossary)
  * [Pods](#pods)
  * [Control Plane](#control-plane)
  * [Nodes](#nodes)
  * [Kubelet](#kubelet)
  * [Deployment](#deployment)
  * [Replicasets](#replicasets)
  * [Persistent Volumes](#persistent-volumes)
* [Understanding Kubernetes](#understanding-kubernetes)
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

# Glossary
Before we delve any further let me describe some terminologies used by Kubernetes. This is not an all-encompassing glossary, and it's okay if this does not make sense right away. I will explain everything as I go.

## Pods
Pods are the smallest deployable units of computing that you can create and manage in Kubernetes [^1]. Pods can hold one or more containers, and they define the specifications of executing the containers

## Control Plane
A kubernetes control plane is a collection of services like an api-server and etcd which store and manage the state of elements running the Kubernetes cluster. Cloud providers have services like GKE (Google Kubernetes Engine), EKS (Elastic Kubernetes Service), AKS (Azure Kubernetes Service), provide Kubernetes clusters where the control plane is managed by the cloud providers while the users can manage the nodes.

## Nodes
Nodes are instances which physically (or virtually) support the execution of instances. All nodes are managed by the control plane manage pod scheduling. Each node have a kubelet process running on it which connects to the control plane and registers itself. Nodes can be managed individually or through a node-pool. [^2]

## Kubelet
The kubelet is the primary "node agent" that runs on each node. It can register the node with the api-server using one of: the hostname; a flag to override the hostname; or specific logic for a cloud provider [^3]. A kubelet is setup and managed by the Kubernetes administrator or the Cloud Provider of the managed Kubernetes service.

## Deployment
A kubernetes deployment defines the desired state of a stateless application [^4]. A deployment manages replicasets which in turn control pods. Deployments can allow you to:
1. Rollout updates to your pods.
2. Rollback changes to your pods.
3. Scale up or down to facilitate more loads.
4. Pause rollout of your deployments.
5. Cleanup old replicasets that are not needed anymore.

## Replicasets
A ReplicaSet's purpose is to maintain a stable set of replica Pods running at any given time. As such, it is often used to guarantee the availability of a specified number of identical Pods. A ReplicaSet is defined with fields, including a selector that specifies how to identify Pods it can acquire, a number of replicas indicating how many Pods it should be maintaining, and a pod template specifying the data of new Pods it should create to meet the number of replicas criteria. A ReplicaSet then fulfills its purpose by creating and deleting Pods as needed to reach the desired number. When a ReplicaSet needs to create new Pods, it uses its Pod template [^5].
It is recommended to use deployments to manage pods through replicasets.

## Persistent Volumes
[Read more about Persistent Volumes on my other post](/blog/k8s-persistent-volumes)

# Understanding Kubernetes

{{<figure src="static/images/kubernetes.png" title="Elements in Kubernetes">}}

The above figure shows the different functional components of Kubernetes. This might make Kubernetes look complicated but, it's actually not because not all components are used all at once. The main idea is that 

# References
[^1]: https://kubernetes.io/docs/concepts/workloads/pods/
[^2]: https://kubernetes.io/docs/concepts/architecture/nodes/
[^3]: https://kubernetes.io/docs/reference/command-line-tools-reference/kubelet/
[^4]: https://kubernetes.io/docs/concepts/workloads/controllers/deployment/
[^5]: https://kubernetes.io/docs/concepts/workloads/controllers/replicaset/

