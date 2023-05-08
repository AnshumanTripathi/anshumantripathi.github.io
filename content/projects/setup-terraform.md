---
title: "Setting up a Terraform workspace for GCP with Terraform Cloud"
date: 2023-04-29T00:39:13-08:00
draft: false
series:
- devops
categories:
- tutorials
tags:
- tools
type: blog
disableDiffblog: true
---

<!-- TOC -->
* [Pre-requisites](#pre-requisites)
* [Terraform Cloud](#terraform-cloud)
* [Setting up a Terraform workspace for Google Cloud](#setting-up-a-terraform-workspace-for-google-cloud)
<!-- TOC -->

This tutorial walks you through the complete steps of setting up a Terraform workspace in Github for provisioning infrastructure in Google Cloud using Terraform cloud.

# Pre-requisites
1. [A Github account](https://github.com)
2. [A Google account with Google cloud console setup](https://console.cloud.google.com/)
3. Setup CLI tools
    1. [gcloud](https://cloud.google.com/sdk/docs/install)
    2. [Install terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli). Consider using a tool like [tfenv](https://github.com/tfutils/tfenv) so that you can have flexible terraform versions
4. [Terraform Cloud account](https://cloud.hashicorp.com/products/terraform)
5. Read about [Infrastructure as code](/blog/infrastructure-as-code)
6. Read about [Terraform Basics](/blog/terraform-basics)

# Terraform Cloud
Terraform needs to manage and persist the state of the infrastructure. With each change in the Terraform workspace, a new version of state is created. When working with cloud providers like AWS and GCP, the state can be stored in a S3 or a GCP bucket. This allows developers in an organization to freely collaborate by fetching the state from the buckets and then running plans and applies through a CI/CD pipeline. Although this is solution for state management works there are few caveats:
1. The state of the workspace and all the resources can be checked with only the state file. This might not be intuitive enough for people not expert in Terraform.
2. There is additional overhead of creating, managing and scaling a CI/CD pipeline to run Terraform plan on commits and Terraform plan and apply on merges.
3. For small individual projects using a S3 or GCP buckets can incur additional monetary costs with for state management.

Terraform Cloud solves all of these problems by providing a managed solution for state management which helps in collaboration. [Terraform cloud is free for upto an organization with 5 users with full API access](https://www.hashicorp.com/products/terraform/pricing) and unlimited organization which makes it perfect to use as a playground to learn Terraform without going into the complexity of setting up buckets for remote state management.

# Setting up a Terraform workspace for Google Cloud

* Set a unique project name
  ```shell
  export GCP_PROJECT="anshumantripathi-my-project"
  ```

* Create a GCP project.
    ```shell
   gcloud project create $GCP_PROJECT
    ```
* Create a service account for terraform with the name `terraform-former`
    ```shell
    gcloud iam service-accounts create terraform-former --description='Service account for Terraform' --display-name='terraform-former' --project $GCP_PROJECT
    ```
* Create a service account key
  ```shell
  gcloud iam service-accounts keys create key.json --iam-account=terraform-former@$GCP_PROJECT.iam.gserviceaccount.com
  ```
* Enable required services
  ```shell
  gcloud services enable cloudresourcemanager.googleapis.com --project $GCP_PROJECT
  gcloud services enable iam.googleapis.com --project $GCP_PROJECT
  ```
* Create a [new Github repository for your workspace](https://github.com/new)
* Clone the repository in your local environment and create the following files. [See this example for reference](https://github.com/AnshumanTripathi/gcp-terraform-workspace)
    1. `variables.tf`
    2. `versions.tf`
    3. `backend.tf`
    4. `project.tf`
* In the `versions.tf` add the following:
    ```terraform
    terraform {
      required_version = "1.3.9"
      required_providers {
        google = {
          source  = "hashicorp/google"
          version = "~> 4.54.0"
        }
        google-beta = {
          source  = "hashicorp/google-beta"
          version = "~> 4.54.0"
        }
      }
    }
    ```
  This sets up the Google and Google-beta providers. We add the Google beta provider to get access to beta level APIs. The `required_version` sets the Terraform version requirement to `1.3.9`.
* Push the changes to your repo
* Create a workspace in Terraform Cloud.
  1. Sign in to [Terraform Cloud](https://app.terraform.io/session)
  2. [Create a workspace](https://developer.hashicorp.com/terraform/cloud-docs/workspaces/creating#create-a-workspace). This should add the Terraform cloud Github app to your workspace Github repository.
  3. Login to terraform cloud from your local environment using `terraform login`
* [Setup Google cloud authentication](https://registry.terraform.io/providers/hashicorp/google/latest/docs/guides/provider_reference#using-terraform-cloud)
  1. Create an environment variable called `GOOGLE_CREDENTIALS` in your Terraform Cloud workspace. 
  2. Remove the newline characters from your JSON key file and then paste the credentials into the environment variable value field. You can use the `tr` command to strip newline characters. `cat key.json | tr -s '\n' ' '`
  3. Mark the variable as Sensitive and click Save variable.
* In the `backend.tf` file add the following to setup backend as Terraform cloud:
    ```terraform
  terraform {
      backend "remote" {
        organization = "anshumantripathi"
    
        workspaces {
          name = "gcp-terraform-workspace"
        }
      }
      required_version = ">= 1.3.9"
  }
  ```
* In the `variables.tf` file add the following local variables:
    ```terraform
    locals {
      # Replace with project name created in step 1
      google_project = "anshumantripathi-my-project"
      services = [
        "cloudresourcemanager.googleapis.com",
        "iam.googleapis.com",
      ]
      terraform_former_project_roles = [
        "roles/owner"
      ]
    }
    ```
  * Create a `project.tf` file and define your project and service account. [See this example for reference](https://github.com/AnshumanTripathi/gcp-terraform-workspace/blob/06626a5ec0b44c8a109b037d03643d290a13e169/project.tf#L9-L21)
      ```terraform
      # Create project
      resource "google_project" "my_project" {
          name            = local.google_project
          project_id      = local.google_project
      }
      # Create service account
      resource "google_service_account" "terraform_former" {
          account_id   = "terraform-former"
          project      = local.google_project
          display_name = "terraform-former"
          description  = "Service account for terraform"
      }
      resource "google_project_service" "my_project_services" {
          for_each = toset(local.services)
          project  = local.google_project
          service  = each.key
      }
      resource "google_project_iam_binding" "terraform_former_project_iam_binding" {
          for_each = toset(local.terraform_former_project_roles)
          project = local.google_project
          role = each.key
          members = ["serviceAccount:${google_service_account.terraform_former.email}"]
      }
      ```
* Setup workspace locally
  ```shell
  terraform init -upgrade
  terraform fmt -recursive # Format your code
  ```
* Import all your changes to terraform
  ```shell
  terraform import google_project.my_project my-project
  terraform import 'google_project_service.my_project_services["iam.googleapis.com"]' $GCP_PROJECT/iam.googleapis.com
  terraform import 'google_project_service.my_project_services["cloudresourcemanager.googleapis.com"]' $GCP_PROJECT/cloudresourcemanager.googleapis.com
  terraform import google_service_account.terraform_former "$(gcloud iam service-accounts describe terraform-former@$GCP_PROJECT.iam.gserviceaccount.com --project $GCP_PROJECT --format='value(name)')"
  terraform import 'google_project_iam_binding.terraform_former_project_iam_binding["roles/owner"]' "$GCP_PROJECT roles/owner $(gcloud iam service-accounts describe terraform-former@$GCP_PROJECT.iam.gserviceaccount.com --project $GCP_PROJECT --format='value(email)')"
  ```
* Commit and push your changes to your repository. The Terraform cloud Github app will submit a Terraform in your Terraform cloud workspace to provision the required resources.
