---
title: "Configuration Management"
date: 2023-02-04T23:20:02+05:30
draft: false
categories:
- concepts
---

An application uses a set configurations for different cases like database connection, caches, messaging queues, address to other application and services, etc.
During the development process an application would be deployed to different environments like development, staging, UAT, load testing and then finally to production.
In each environment there might a set of configurations that will change for the application. Managing these changes on scale, i.e., for a large number of applications deployed on a large number of environments is called configuration management.

## Problem
The problem of configuration management is not one of implementation but of scale. For a single service it can be considered simpler to just add multiple configuration files for each environment.
But as the number of applications in an organization grows, configuration management for so many applications also becomes onerous and error-prone.  


## How I approached it

