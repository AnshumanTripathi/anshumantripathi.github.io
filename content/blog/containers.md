---
title: "Linux Containers 🚢"
date: 2023-02-16T00:35:51+05:30
draft: false
categories:
- concepts
featuredImage: "images/containers.jpeg"
series:
- samyak
- devops
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
    * [Listing all Linux Namespaces](#listing-all-linux-namespaces)
  * [Creating a Linux namespace](#creating-a-linux-namespace)
* [Linux Cgroup](#linux-cgroup)
* [CGroups in action](#cgroups-in-action)
* [References](#references)
<!-- TOC -->

# What are containers?

Containers is a term used to define a process or a set of processes isolated from the system in the Linux Kernel. From this point of view, containers can look like Virtual machines, but they have an important distinction. While Virtual Machines virtualize at an Operating System level, Linux containers virtualize at the process level, making containers much lighter than Virtual Machines.

Although there has been quite the buzz about containers in the last decade, Linux containers have been around for quite a while; actually, since 2008 [LXC (Linux Containers)](https://linuxcontainers.org) was introduced. At that time, they were implemented using namespaces and cgroups.

# Linux Namespaces
Namespaces have been part of the Linux operating system since 2002. Namespaces were created so that a process (or a set of processes) can only see a definite set of resources. In this way, the resources were isolated to the process, and other processes could not access the resources of a process running a different namespace.

## Types of Namespaces

There are 8 kinds of namespaces in Linux [1]

### User ID namespace
A user ID namespace has its own set of user IDs and group IDs for assignment to processes. These users can have root privileges to process running within the namespace while not having any elevated access in other namespaces.

### Control Group namespace
A control group in Linux controls the access of the user accounts and can isolate the resource usage CPU, memory, disk I/O, network, etc.) of a collection of processes [2]. A cgroup namespace hides the identity of the cgroups in the namespace. A cgroup in the namespace would only see the relative path of the cgroup and the creation time, and the actual control group identity is hidden.

### Network namespaces
A network namespace isolates the network stack (IP tables, socket connections, firewalls, etc.) in the namespace

### Mount namespaces
A mount namespace has an independent list of mount points that can be seen by a process within the namespace. This means you can mount and unmount filesystems in a mount namespace without affecting the host filesystem. [3]

### Process ID (PID) namespace
A PID namespace isolates the process IDs of the process running within this namespace. The PIDs in a PID namespace are independent of the process in the host or other namespaces. If a child process is created with its own PID namespace, it has PID 1 and its PID in the parent process' namespace.

### Interprocess communication (IPC) namespaces
A process can use different mechanisms to talk to other processes in the namespaces. These can range from
- Shared files
- Shared memory
- POSIX message queues
- Sockets
- Signals

An IPC namespace isolates processes in such a way that their IPC mechanisms can only see the process mechanism in their own IPC namespace.

### Unix Time Sharing (UTS) namespace
A UNIX Time‑Sharing (UTS) namespace allows a single system to appear to have different host and domain names for other processes [3].

### Listing all Linux Namespaces

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

## Creating a Linux namespace
Let's try creating some namespaces in the following sections

Create three users `ns-user`, `app-user`, and `db-user`.
```shell
useradd --create-home ns-user
useradd --create-home app-user
useradd --create-home db-user
```

Once these users are created in the host namespace by the user, they are assigned user IDs and group IDs from 1000

```shell
root@instance-2:~# id -a ns-user
uid=1001(ns-user) gid=1002(ns-user) groups=1002(ns-user)
root@instance-2:~# id -a app-user
uid=1002(app-user) gid=1003(app-user) groups=1003(app-user)
root@instance-2:~# id -a db-user
uid=1003(db-user) gid=1004(db-user) groups=1004(db-user)
```

We can create a namespace in Linux using the [unshare command](https://man7.org/linux/man-pages/man1/unshare.1.html). Let's create a user namespace.

```shell
root@instance-2:~# unshare -U
nobody@instance-2:~$ whoami
nobody
nobody@instance-2:~$ id -a
uid=65534(nobody) gid=65534(nogroup) groups=65534(nogroup)
```

In a [user namespace](#user-id-namespace), the user `nobody` in the namespace is isolated and not in conjunction with the users created before.

Now let's create a namespace with its users, mount, and pid.

```shell
unshare --user --pid --mount-proc --fork bash
```

The `--fork bash` means to run the child process `bash` in a child process in the newly created namespace. Once the namespace is created, let's see the processes running in it using `ps -ef`.

```shell
nobody@instance-2:~$ ps -ef
UID          PID    PPID  C STIME TTY          TIME CMD
nobody         1       0  0 08:01 pts/0    00:00:00 bash
nobody         2       1  0 08:02 pts/0    00:00:00 ps -ef
```

As it can be seen here the users running the `bash` and `ps -ef` processes are `nobody`,  i.e., the user in the newly created namespace.
This way, any processes running within the new namespace will be isolated from the host or other namespaces created in the system.

# Linux Cgroup
Linux control groups or groups are mechanisms used to provide resource quotas so that the processes' resources, like CPU, memory, etc., can be controlled.

# CGroups in action
Let's create a cgroup. 

```shell
mkdir -p /sys/fs/cgroup/memory/myapp
```

On checking the directory of the cgroup with `ls /sys/fs/cgroup/memory/myapp` we can see the following

```shell
root@instance-2:~# ls /sys/fs/cgroup/memory/myapp
cgroup.controllers  cgroup.freeze     cgroup.max.descendants  cgroup.stat	      cgroup.threads  cpu.pressure  io.pressure
cgroup.events	    cgroup.max.depth  cgroup.procs	      cgroup.subtree_control  cgroup.type     cpu.stat	    memory.pressure
```

The files in the cgroup directory have information on the process used in the cgroup.
The following script prints `Testing cgroups` and sleeps for 50000 seconds.

```shell
#! /bin/bash

while :
do
	echo "CGroup testing tool" > /dev/tty
	sleep 50000
done
```

Let's add this process to the newly created cgroup
```shell
echo $(pidof -x test.sh) > /sys/fs/cgroup/memory/myapp/cgroup.procs
```

Once the PID of the script is registered to the cgroup we can check the execution as follows:

```shell
root@instance-2:/sys/fs/cgroup/memory/myapp# ps -o cgroup | grep myapp
0::/memory/myapp
```

Now if we see the contents some files in the cgroup

```shell
root@instance-2:/sys/fs/cgroup/memory/myapp# cat cgroup.events
populated 1
frozen 0

root@instance-2:/sys/fs/cgroup/memory/myapp# cat cpu.pressure
some avg10=0.00 avg60=0.00 avg300=0.00 total=0

root@instance-2:/sys/fs/cgroup/memory/myapp# cat io.pressure
some avg10=0.00 avg60=0.00 avg300=0.00 total=0
full avg10=0.00 avg60=0.00 avg300=0.00 total=0

root@instance-2:/sys/fs/cgroup/memory/myapp# cat memory.pressure
some avg10=0.00 avg60=0.00 avg300=0.00 total=0
full avg10=0.00 avg60=0.00 avg300=0.00 total=0
```

We can see the resource quotas in the parent memory cgroup

```shell
root@instance-2:/sys/fs/cgroup/memory# ls /sys/fs/cgroup/memory
cgroup.controllers  cgroup.max.descendants  cgroup.threads  io.pressure		 memory.high  memory.numa_stat	memory.swap.current  myapp
cgroup.events	    cgroup.procs	    cgroup.type     memory.current	 memory.low   memory.oom.group	memory.swap.events   pids.current
cgroup.freeze	    cgroup.stat		    cpu.pressure    memory.events	 memory.max   memory.pressure	memory.swap.high     pids.events
cgroup.max.depth    cgroup.subtree_control  cpu.stat	    memory.events.local  memory.min   memory.stat	memory.swap.max      pids.max
```
These can be used to set the quotas of the cgroup.


[//]: # (TODO: Need to look into an actual implementation of this.)

# References
[1] https://en.wikipedia.org/wiki/Linux_namespaces#Namespace_kinds 
[2] https://en.wikipedia.org/wiki/Cgroups
[3] https://www.nginx.com/blog/what-are-namespaces-cgroups-how-do-they-work/
