---
title: "Infrastructure as Code (IaC)"
date: 2023-02-26T09:46:59-08:00
draft: false
series:
- devops
- samyak
categories:
- concepts
featuredImage: "images/iac.png"
featuredImageCaption: "Picture credit <a href='https://bluelight.co/blog/best-infrastructure-as-code-tools'>Bluelight</a>"
---

# Infrastructure as Code

Infrastructure as Code is setting up software infrastructure entirely through version controller code. Infrastructure as Code (IaC) enables developers to create a consistent and repeatable infrastructure where each change can be reviewed and versioned through version control systems. (Github, Gitlab, etc.)
Multiple offerings provide Infrastructure as Code (IaC):

## Terraform
- [Terraform](https://www.terraform.io) is the leading choice for setting up Infrastructure as Code (IaC).
- [Terraform is open source software (OSS) which Hashicorp maintains](https://github.com/hashicorp/terraform).
- Terraform uses HCL (Hashicorp Configuration Language), a declarative language for setting up infrastructure. It is also used for configuring other tools like [Hashicorp's Packer](https://developer.hashicorp.com/packer/docs/templates/hcl_templates), which is used to create VM images and [Hashicorp's Nomad](https://developer.hashicorp.com/nomad/docs/configuration) which is used for container orchestration.
- Terraform has providers for all major cloud offerings (AWS, GCP, Azure). Terraform also has providers for tools like Helm, Kubernetes, etc.
- Terraform allows developers to write their providers in Golang for provisioning infrastructure.

## Pulumi
- [Pulumi](https://www.pulumi.com) is another offering for setting up Infrastructure as Code (IaC).
- [Pulumi is open source software (OSS)](https://github.com/pulumi/pulumi) maintained by the Pulumi team.
- Pulumi allows you to write IaC in the programming language of your choice (Typescript, Golang, Python, Java, C#, YAML).
- Since Pulumi is programmatic, it allows more flexibility for setting infrastructure provisioning automation and testability.

Other tools, like Ansible, Chef, Puppet, etc., can also be used to provision infrastructure, but they are not strictly IaC. These tools are better with platform orchestration and configuration management.

# Best practices

## Everything IaC or nothing IaC
Once you migrate to using IaC, ensure all your infrastructure is provisioned and managed through IaC. There should be **no manual infrastructure provisioning**. Manual infrastructure provisioning and changes can lead to the following problems:
1. The state of your IaC providing can get messed up. You would have to manually update the state by importing the changes, and errors start to pile up every time changes in infrastructure are planned and applied.
2. Manual changes defeat the purpose of IaC. IaC is intended to ensure all changes are version-controlled and peer-reviewed before they are applied. Manual changes are the complete opposite of the IaC ideology.

## Do not take it too far
IaC offerings like Terraform and Pulumi are mature enough to go beyond just provisioning and managing your infrastructure. IaC offerings can manage your platform, like setting up your Kubernetes platform, and can even install and manage your Helm charts. It must be remembered that platforms and applications are much more prone to changes than your infrastructure, i.e., the state of your workspaces can be different based on environments or regions.
Managing platforms and applications through IaC removes the consistency and repeatability of IaC, i.e., it makes it difficult to spin up the same infrastructure using the same IaC configuration.

## Modularized
Abstracting your IaC configurations in modules helps spin up new infrastructure on demand. Modules also help to roll out recent changes to all infrastructure workspaces in a controlled manner.

## Documentation is key
Inline documentation for references to the providers' documentation and explanations for why the resources are configured the way they are, improves readability exponentially. Furthermore, having documentation of the scope of the created workspaces and modules can also help developers understand on a high level how the overall infrastructure is set up.

## CI/CD
A good IaC setup is always accompanied by a CI pipeline validating and testing. It ensures the Code is well formatted and a CD pipeline that applies the changes to the workspace's main branch after each merge.  
