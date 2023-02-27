---
title: "Terraform Basics"
date: 2023-02-26T21:22:47-08:00
draft: false
series:
- devops
categories:
- concepts
---

<!-- TOC -->
* [Hashicorp Configuration Language (HCL)](#hashicorp-configuration-language--hcl-)
* [Resources](#resources)
* [Workspaces](#workspaces)
* [Modules](#modules)
* [State](#state)
* [Providers](#providers)
* [References](#references)
<!-- TOC -->

# Hashicorp Configuration Language (HCL)
Hashicorp Configuration Language, or HCL, is a declarative programming language created by Hashicorp for configuring tools like Terraform and Nomad.
Read more about HCL here - https://github.com/hashicorp/hcl#hcl.

# Resources
Resources are the building blocks of Terraform. Each resource block in Terraform represents one or more infrastructure objects like compute instances, virtual networks, or high-level components like DNS records. [^1]

# Workspaces
A Terraform workspace is the core of Terraform Infrastructure as Code (IaC). A Terraform workspace is the version control repository that implements the code for provisioning the required infrastructure using Terraform.

# Modules
Modules are independent and reusable abstractions in Terraform that can be implemented in the Terraform workspaces to create infrastructure.
Terraform modules can be considered libraries that can be implemented within services like Terraform workspaces.

# State
State is the information about the infrastructure provisioned by Terraform. Terraform creates a state for your provisioned infrastructure which is stored in `terraform.tfstate` file by default. , AWS S3 buckets, or in Terraform Cloud. Terraform state can also be stored remotely in GCP buckets. Terraform state is immutable and is version controlled, i.e., whenever terraform resources are created/updated/destroyed, a new state version is created.
Use `terraform state` command through Terraform CLI.

# Providers
Providers are the plugins used to interact with cloud providers, SaaS providers, and other APIs. Most providers configure a very specific infrastructure platform (either cloud or self-hosted). Providers can also offer local utilities for tasks like generating random numbers for unique resource names. [^2]

# References
[^1]: https://developer.hashicorp.com/terraform/language/resources
[^2]: https://developer.hashicorp.com/terraform/language/providers

