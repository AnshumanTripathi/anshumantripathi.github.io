---
title: "Persistent Volumes in Kubernetes"
subtitle: "Understanding the basics of persistent volumes in Kubernetes"
date: 2023-03-19T23:05:41-07:00
draft: false
series:
- devops
tags:
- kubernetes
---

<!-- TOC -->
* [Persistent Volumes (PV)](#persistent-volumes--pv-)
* [Persistent Volume Claims (PVCs)](#persistent-volume-claims-pvcs)
* [Access Modes](#access-modes)
  * [ReadWriteOnce](#readwriteonce)
  * [ReadWriteOncePod](#readwriteoncepod)
  * [ReadOnlyMany](#readonlymany)
  * [ReadWriteMany](#readwritemany)
* [PV provisioning](#pv-provisioning)
  * [Static](#static)
  * [Dynamic](#dynamic)
* [Storage Classes](#storage-classes)
  * [Volume Binding Mode](#volume-binding-mode)
    * [Immediate (default)](#immediate-default)
    * [Wait For First Consumer (Recommended)](#wait-for-first-consumer-recommended)
  * [ReclaimPolicy](#reclaimpolicy)
    * [Retain](#retain)
    * [Delete (Default)](#delete-default)
  * [Provisioners](#provisioners)
    * [Internal provisioners](#internal-provisioners)
    * [External Provisoiners](#external-provisoiners)
  * [Parameters](#parameters)
  * [Mount options](#mount-options)
* [References](#references)
<!-- TOC -->

> [It is highly recommended to read about volumes before learning about persistent volumes](https://kubernetes.io/docs/concepts/storage/volumes/)

Kubernetes provides ephemeral and persistent storage options for an application. Ephemeral storage like an emptyDir lives and dies with the pod, i.e., if the pod is deleted, all the data in the emptyDir is deleted. On the other hand, persistent storage is not coupled with the pod's lifecycle. It requires understanding what kind of storage is needed and how to provision it (dynamically or statically).

Before we delve into what kind of storage is supported and how it is provisioned, let's look into how Kubernetes abstracts the storage of your application using persistent volumes and persistent volume claims.

# Persistent Volumes (PV)
A persistent volume is an object that represents a valid singular external storage. The kind of storage supported by the PV is defined by the administrator using a [storage class](#storage-classes) and can be NFS or cloud provider-supported persistent disks like AWS EBS, GCP PD, Azure Disk, etc.

# Persistent Volume Claims (PVCs)
A persistent volume claim is a request made by a pod for PV. A pod can request a PV through a PVC for specific sizes and access modes like ReadWriteOnce, ReadWriteOncePod, ReadOnlyMany, or ReadWriteMany.

1. A PV represents a single external storage, i.e., a PV and an external storage have a 1:1 relationship. A 100G external storage can only be divided across two PV objects for 50G each if the administrator divides the external storage into different volumes, in which case a PV points to a specific volume in the external storage.
2. A pod and a PVC have a 1:1 relationship. A pod requires a PVC to get the necessary external storage. Once a PVC is granted, the allocated persistent storage can be mounted to the pod as a volume.
3. A PV and a PVC can have a one-to-many relationship, i.e., multiple PVCs, and claim a specific PV as long as the total PVC size does not exceed the size of the PV. [^1]

# Access Modes

## ReadWriteOnce
- A PV can be mounted as a volume on pods on the same nodes.
- In this case, a single PV can be bound by multiple PVCs, given the pods raising a PVC are on the same node.

## ReadWriteOncePod
- A PV can be mounted as a volume on a single pod.
- In this case, a single PV can only be bound by a single PVC. This access mode was introduced in Kubernetes version 1.22+.
- Read more about it here - https://kubernetes.io/blog/2021/09/13/read-write-once-pod-access-mode-alpha/.

## ReadOnlyMany
- A PV can be mounted as volume as read-only for multiple nodes.
- In this case, a single PV can be bound by multiple PVCs

## ReadWriteMany
- A PV can be mounted as volume for reading and writing for multiple nodes.
- In this case, a single PV can be bound by multiple PVCs.
- This mode is only supported by NFS external storage.

# PV provisioning

## Static
- In this case, an external storage volume is manually pre-created by the administrator, and the PV points to the pre-created storage object.
- PVs are explicitly declared to point to the existing pre-created storage objects.

## Dynamic
- The external storage object is dynamically created with the PV.
- This provisioning is based on [storage classes](#storage-classes). A PVC must mention the required storage class defined by the administrator.
- PVCs with `"` as storage classes have dynamic provisioning disabled.

# Storage Classes
A storage class is a way for Kubernetes administrators to define the types of storage which can be dynamically provisioned. A storage class can have the following properties:

## Volume Binding Mode
The `volumeBindingMode` defines what kind of volume binding the PV supports. There are two types of supported volume binding modes:

### Immediate (default)
- Immediate volume binding mode indicates volume binding, and dynamic provisioning of the PV happens when the PVC is created.
- For storage backends that are topology-constrained and not globally accessible from all Nodes in the cluster, PersistentVolumes will be bound or provisioned without knowledge of the pod's scheduling requirements, resulting in unschedulable Pods. [^2]

### Wait For First Consumer (Recommended)
- `WaitForFirstConsumer` will delay the volume binding and the dynamic provisioning until a pod using the PVC is created.
- PersistentVolumes will be selected or provisioned conforming to the topology specified by the pod's scheduling constraints. These include, but are not limited to, resource requirements, node selectors, pod affinity and anti-affinity, and taints and tolerations. [^2]

## ReclaimPolicy
Once the user is done with the PV, the PVC can be deleted so that the cluster can reclaim the PV. How the reclaim is done is defined by a `ReclaimPolicy` in the storage class.

### Retain
The Retain reclaim policy allows the administrator to reclaim the PV manually. When a PVC with the "retain" reclaim policy is deleted, the PV is not deleted by the cluster. PV is marked as "released" but is not yet available for another claim because it contains all the data from the last PVC. To clean up this PV, the administrator must:
1. Delete the PV object from the cluster. **Note:** This does not delete the external storage infrastructure (AWS EBS, GCP PD, Azure Disk) that the PV pointed to, which still contains all the data.
2. Manually clean up the data on the storage infrastructure.
3. Delete the storage infrastructure.

If you want to reuse the same storage asset, create a new PersistentVolume with the same storage asset definition.

### Delete (Default)
Delete is the default reclaim policy of the PV. In this case, once the PVC is deleted, its associated external storage is also cleaned up.


## Provisioners
Provisioners define what volume plugin can be used to create the PV. They are of two categories:

### Internal provisioners
- An internal provisioner is prefixed with `kubernetes.io`.
- Internal provisioners are also referred to as `in-tree` provisioners because these [provisioners are defined in the Kubernetes Github repo](https://github.com/kubernetes/kubernetes/tree/fe91bc257b505eb6057eb50b9c550a7c63e9fb91/pkg/volume).
- [Common internal provisioners can be found in the Kubernetes documentation.](https://kubernetes.io/docs/concepts/storage/storage-classes/#provisioner)
- Example: NFS does not provide an internal provisioner, but an external provisioner can be used.

### External Provisoiners
- External provisioners are third-party volume plugins.
- These plugins are often implemented using the [Container Storage Interface (CSI)](https://kubernetes.io/blog/2019/01/15/container-storage-interface-ga/).

## Parameters
Each provisioner requires a set of parameters to set up the cluster's storage.

## Mount options
Mount options for the volume can be added if the provisioner plugin supports them.

# References
[^1]: https://www.digihunch.com/2021/06/kubernetes-storage-explained/
[^2]: https://kubernetes.io/docs/concepts/storage/storage-classes/#volume-binding-mode
