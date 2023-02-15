---
title: "Containers 🚢"
date: 2023-02-16T00:35:51+05:30
draft: false
featuredImage: "images/containers.jpeg"
categories:
- concepts
- devops
---

Photo by <a href="https://unsplash.com/@guibolduc?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Guillaume Bolduc</a> on <a href="https://unsplash.com/photos/uBe2mknURG4?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Unsplash</a>

---

<!-- TOC -->
* [What are containers?](#what-are-containers)
* [Linux Namespaces](#linux-namespaces)
  * [Types of Namespaces](#types-of-namespaces)
  * [Creating a Linux namespace](#creating-a-linux-namespace)
* [cgroups](#cgroups)
  * [Creating a cgroup](#creating-a-cgroup)
* [How do containers come into picture?](#how-do-containers-come-into-picture)
<!-- TOC -->

# What are containers?

Containers is a term used to define a process or a set of processes tha are isolated from the system in the Linux Kernel. From a point of view, containers can look like Virtual machines, but they have an important distinction. While Virtual Machines virtualize at an Operating System level, Linux containers are virtualizing at the process level which makes container much lighter than Virtual Machines.

Although there has been a quite the buzz about containers in the last decade, Linux containers have been around for quite a while; actually since 2008 [LXC (Linux Containers)](https://linuxcontainers.org) was introduced. At that time they were implemented using namespaces and cgroups.

# Linux Namespaces
Namespaces have been part of the Linux containers since 2002 and since then more tooling and namespaces have been added to the Linux operating system. Namespaces were actually created so that a process (or a set of processes) can only see a definite set of resources. In this way the resources where isolated to the process and other processes could not access the resources of a process running a different namespace.

## Types of Namespaces

## Creating a Linux namespace

# cgroups

## Creating a cgroup

# How do containers come into picture?

End with how docker revolutionized containers

