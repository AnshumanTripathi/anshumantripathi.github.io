---
title: "Containers 🚢"
date: 2023-02-16T00:35:51+05:30
draft: false
categories:
- concepts
- devops
featuredImage: "images/containers.jpeg"
---

Photo by <a href="https://unsplash.com/@guibolduc?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Guillaume Bolduc</a> on <a href="https://unsplash.com/photos/uBe2mknURG4?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Unsplash</a>

---

<!-- TOC -->
* [What are containers?](#what-are-containers)
* [Linux Namespaces](#linux-namespaces)
  * [Types of Namespaces](#types-of-namespaces)
    * [User ID namespace](#user-id-namespace)
    * [Control Group namespace](#control-group-namespace)
    * [Network namespaces](#network-namespaces)
    * [Mount namespaces](#mount-namespaces)
    * [Process ID (PID) namespace](#process-id--pid--namespace)
    * [Interprocess communication (IPC) namespaces](#interprocess-communication--ipc--namespaces)
    * [Unix Time Sharing (UTS) namespace](#unix-time-sharing--uts--namespace)
  * [Creating a Linux namespace](#creating-a-linux-namespace)
* [cgroups](#cgroups)
  * [Creating a cgroup](#creating-a-cgroup)
* [How do containers come into picture?](#how-do-containers-come-into-picture)
* [References](#references)
<!-- TOC -->

# What are containers?

Containers is a term used to define a process or a set of processes tha are isolated from the system in the Linux Kernel. From a point of view, containers can look like Virtual machines, but they have an important distinction. While Virtual Machines virtualize at an Operating System level, Linux containers are virtualizing at the process level which makes container much lighter than Virtual Machines.

Although there has been a quite the buzz about containers in the last decade, Linux containers have been around for quite a while; actually since 2008 [LXC (Linux Containers)](https://linuxcontainers.org) was introduced. At that time they were implemented using namespaces and cgroupzs.

# Linux Namespaces
Namespaces have been part of the Linux containers since 2002 and since then more tooling and namespaces have been added to the Linux operating system. Namespaces were actually created so that a process (or a set of processes) can only see a definite set of resources. In this way the resources where isolated to the process and other processes could not access the resources of a process running a different namespace.

## Types of Namespaces

There are 8 kinds of namespaces in Linux [1]

### User ID namespace
A user ID namespace has its own set of user IDs and group IDs for assignment to processes. These users can have root privileges to process running within the namespace while not having any elevated access in other namespaces.

### Control Group namespace
A control group in Linux controls the access of the user accounts and can isolate the resource usage CPU, memory, disk I/O, network, etc.) of a collection of processes [2]. A cgroup namespace hides the identity of the cgroups in the namespace. A cgroup in the namespace would only see relative path of the cgroup and the creation time and the true control group identity is hidden to the namespace.  

### Network namespaces
A network namespace isolates the network stack (IP tables, socket connections, firewalls, etc.) in the namespace 

### Mount namespaces
A mount namespace has its independent list of mount points that can be seen by process within the namespace. This means that you can mount and unmount filesystems in a mount namespace without affecting the host filesystem. [3]

### Process ID (PID) namespace
A PID namespace isolates the process IDs of the process running within this namespace. The PIDs in a PID namespace are independent from the process in the host or other namespaces. If a child process is created with its own PID namespace, it has PID 1 in that namespace as well as its PID in the parent process’ namespace.

### Interprocess communication (IPC) namespaces
A process can use different mechanisms to talk to other processes in the namespaces. These can range from
- Shared files
- Shared memory
- POSIX message queues
- Sockets
- Signals

An IPC namespace isolates processes in a such a way that their IPC mechanisms can see only the process mechanism that are present in their own IPC namespace.

### Unix Time Sharing (UTS) namespace
A UNIX Time‑Sharing (UTS) namespace allows a single system to appear to have different host and domain names to different processes [3].


## Creating a Linux namespace
```bash
anshuman.tripat@instance-2:~$ lsns
NS TYPE   NPROCS   PID USER            COMMAND
4026531834 time        3   583 anshuman.tripat /lib/systemd/systemd --user
4026531835 cgroup      3   583 anshuman.tripat /lib/systemd/systemd --user
4026531836 pid         3   583 anshuman.tripat /lib/systemd/systemd --user
4026531837 user        3   583 anshuman.tripat /lib/systemd/systemd --user
4026531838 uts         3   583 anshuman.tripat /lib/systemd/systemd --user
4026531839 ipc         3   583 anshuman.tripat /lib/systemd/systemd --user
4026531840 mnt         3   583 anshuman.tripat /lib/systemd/systemd --user
4026531992 net         3   583 anshuman.tripat /lib/systemd/systemd --user
```

# cgroups

## Creating a cgroup

# How do containers come into picture?



# References
[1] https://en.wikipedia.org/wiki/Linux_namespaces#Namespace_kinds
[2] https://en.wikipedia.org/wiki/Cgroups
[3] https://www.nginx.com/blog/what-are-namespaces-cgroups-how-do-they-work/

End with how docker revolutionized containers

