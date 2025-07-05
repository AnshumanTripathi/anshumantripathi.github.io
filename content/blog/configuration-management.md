---
title: Configuration Management from scratch
date: 2023-02-04T23:20:02+05:30
draft: false
description: An article explaining how to handle configuration management for applications from scratch
categories:
- concepts
aliases:
- config-management
featuredImage: "images/config-management.jpeg"
series:
- samyak
- devops
tags:
- infrastructure-as-code
---

An application uses a set configuration for different use cases like database connection, caches, messaging queues, addresses to other applications and services, etc. During the development process, applications are also deployed to different environments like development, staging, UAT, load testing, and production.
In each environment, a set of configurations might change for the application. Managing these changes in a scalable manner, i.e., for a large number of applications deployed on a large number of environments, is called configuration management.

# Issues with static configuration files

1. The configuration management problem is not one of implementation but of scale. It is more straightforward for a single service to add multiple configuration files for each environment. But, as the number of applications in an organization grows, configuration management for many applications becomes onerous and error-prone.
2. Updating a property used across all environments in multiple services also becomes a problem. For example, if an organization has ten applications, and each application is deployed to five environments. Suppose a standard configuration is shared across all services and needs to change. In that case, the change needs to happen in at least 50 places in 50 different services. So many manual changes are error-prone.
3. Configurations evaluated based on the deployed environment at the time of application setup, i.e., dynamic configurations, are not possible.


# How I approached it

## Tools

The core of this problem is the ability to have multiple overridable configurations at different levels. Creating a hierarchy of configurations makes sense which is why tools like [Puppet](https://www.puppet.com) use [Hiera](https://www.puppet.com/docs/puppet/7/hiera_intro.html#hiera_intro), which is a hierarchical key-value store.
[Hiera was open source](https://github.com/puppetlabs/hiera), but later it became proprietary to Puppet, which is why it does not have all the features of Puppet 5. However, it is still a perfect candidate for setting up a hierarchical key-value pair. Although Hiera is implemented in **Ruby**, it should be noted that there are multiple implementations of Hiera in different languages like Golang and Python.
Hiera natively supports JSON and YAML formats which is also a benefit as these formats are most used with configurations. My preference is **YAML over JSON** because of YAML's conciseness with the lack of angular braces `{}` and commas `,`.

## Strategy

1. The idea is to create a centralized repository for configurations. The repository should have modules for applications and override configurations at different levels.
    * module level configuration
    * node/deployment level configuration
    * environment level configuration
    * common or default configurations
2. Hierarchy should be created from the most specific to the least specific configuration.
3. Configurations can further be broken into components. For example, configurations to connect to the database, caching, etc., can be broken into pluggable components for different services at different environments/nodes/deployments.
4. Each module should have a configuration in YAML format, a manifest file that defines how the configurations are used, and a template file to create the final configuration file consumed by the application.
5. Application configurations should be generated with application builds so that each deployment gets a fresh copy of the configuration.

This design solves the configuration management problems because configurations are in a centralized repository and can be broken up into components, reducing duplication and making the configurations less error-prone. Furthermore, each module's manifest file can perform transformations on a property level before applying them to the templates, allowing dynamic configurations to be used.

# Alfred

* [Alfred](https://github.com/clover/alfred) is a tool to help with application configuration management.
* It is created based on the [above defined strategy](#strategy) and works on a [defined directory structure](https://github.com/clover/alfred#directory-structure).
* Alfred is written in Ruby since Hiera is natively written in Ruby.
* The script `generate_properties.rb` can be executed during the service build and deployment so that the service can receive a fresh copy of the configuration with each deployment.
