---
title: Configuration Management
date: 2023-02-04T23:20:02+05:30
draft: true
categories:
- concepts
---

An application uses a set configurations for different cases like database connection, caches, messaging queues, address to other application and services, etc.
During the development process an application would be deployed to different environments like development, staging, UAT, load testing and then finally to production.
In each environment there might a set of configurations that will change for the application. Managing these changes on scale, i.e., for a large number of applications deployed on a large number of environments is called configuration management.

## Problem
1. The problem of configuration management is not one of implementation but of scale. For a single service it can be considered simpler to just add multiple configuration files for each environment. But as the number of applications in an organization grows, configuration management for so many applications also becomes onerous and error-prone.
2. Update a property that is used across all environments in multiple services also becomes a problem. For example if an organization has 10 services with each service being deployed to 5 environments and if a common configuration shared across all services need to change then the change needs to happen in atleast 50 places in 50 different services. So much manual change is very error prone.
3. Configurations that are evaluated based on deployed environment at the time of application setup i.e., dynamic configurations are not possible.


## How I approached it
### Tools

The core of this problem is the ability to have multiple configurations which are overridable at different levels. Creating a hierarchy of configurations makes sense which is why tools like [Puppet](https://www.puppet.com) use [Hiera](https://www.puppet.com/docs/puppet/7/hiera_intro.html#hiera_intro) which is a hierarchical key value store.

[Hiera was open source](https://github.com/puppetlabs/hiera) but later it became proprietary to Puppet which is why it does not have all the features of Puppet 5. However, it is still a perfect candidate for setting up a hierarchical key value pair. Although Hiera is implemented in **Ruby**, it should be noted that there are multiple implementations of Hiera in different languages like Golang and Python.

Hiera natively supports JSON and YAML formats which also a benefit as these formats are most used with configurations. My personal preference is **YAML over JSON** because of YAML’s conciseness with the lack of angular braces `{}` and commas `,`.

### Strategy



See [Alfred implementation](/samyak/alfred) for implementation details
