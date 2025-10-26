---
title: "Invisible Pods"
subtitle: ""
date: 2025-10-25T12:35:25-07:00
draft: false
story: []
categories:
- tutorial
tags:
- kubernetes
pagefindWeight: "0.1"
slug: invisible-pods
---

I am a huge fan of [Ivan Velichko](https://iximiuz.com/en/). His platform https://iximiuz.com/en/, provides great materials and practical lab exercises to learn more about concepts like Containers, Networking, Linux, Kubernetes, Dagger, etc. Ivan covers the core fundamentals behind all these concepts which makes all posted materials an exceptional resource for learning new things.

I recently attempted an exercise posted on this platform about [Invisible Pods](https://labs.iximiuz.com/challenges/kubernetes-invisible-pod-0bf2109b). Its based on [a talk from Rory Mcune](https://www.youtube.com/watch?v=GtrkIuq5T3M&t=923s) about container security where he breifly mentions how pods can be come invisible. This is a great exercise which touches on some Kubernetes concepts that are not very well known.

> Before moving forward I would recommend to attempt the exercise and try finding the solution.

## Concepts

Before we dig into solving the exercise lets touch on some important concepts in Kubernetes. At this point I assume the reader has a working understanding of Kubernetes. If needed I would recommend going through my previous post about [Kubernetes Concepts](/blog/understanding-kubernetes).

### Kubelet

The Kubelet in Kubernetes runs outside the jurisdiction of the Kubernetes cluster. It runs as a systemd service on a Kubernetes node. This is because an external service is needed to manage and orchestrate a containers which itself is a not a container.

This allows the Kubelet to bootstrap key control plane components on control plane nodes like the api-server, etcd, scheduler and controller-manager as [static pods](#static-pods). Once these critical components are up and running _the kubelet registers the static pods as [mirror pods](#mirror-pods) on the api-server_.


### Static Pods

Static pods are pods managed by the kubelet which are created from manifests added in path `/etc/kubernetes/manifests/` on the node. Any Pod manifest added here would be used by the kubelet to create a mirror pod.

### Mirror Pods

Mirror pods are entries of a static pod in the api-server. These are references to the actual static pods. 

