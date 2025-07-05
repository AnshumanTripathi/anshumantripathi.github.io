---
title: "Moving to VSCode from IntelliJ"
date: 2024-05-14T14:24:07-08:00
draft: false
subtitle: "My expereince and guide for moving to VSCode from IntelliJ"
categories:
- tutorials
tags:
- tools
featuredImage: "images/intellij_vscode.jpeg"
featuredImageCaption: Moving to VSCode from IntelliJ
---

I have been using IntelliJ (or an Jetbrains editor) for around a decade now and I started to realize that I'm getting used to the some of the issues that I have always had IntelliJ like its execessive resource usage, plugin issues, random crashes its expensive cost for license, etc.

One day a couple of months ago, I was on a call with a colleague and saw he was using VSCode. I had heard that VSCode has gotten much better recently and thought to give it a shot. I setup VSCode and now I have uninstalled IntelliJ entirely. VSCode is not perfect and honestly it can potentially have all the above problems (maybe even more), but that's the beauty of it. VSCode is so configurable that you tune it to your hearts desire.

# Difference between IntelliJ and VSCode

When I was using IntelliJ anytime I would hear the mention of VSCode I would dismiss it because VSCode was a code editor while IntelliJ was an Integrated Development Environment (IDE). To the uninitiated they might seem the same thing, but there is a significant difference. By definition, an IDE has capabilities like programmiing language based auto complete, support for compiling, running and debugging programs. A code editor is an enhanced WYSWYG (What You See is What You Get) editor which supports reading and writing code. 

# Similarities between IntelliJ and VSCode

VSCode started as a code editor while IntelliJ started as an IDE. Now they are both mature tools and can act as both code editors and IDEs. 

- IntelliJ and VSCode have an extensive plugin ecosystem which allows users to extend their capabilities and configure the editors to their needs. 
- IntelliJ and VSCode have command line intergration tools which allows both tools to be used as for quick command line editing.
- IntelliJ and VSCode support compiling, running and debugging code.

# Why choose VSCode over IntelliJ

VSCode has a few features because of which I personally give to VSCode over IntelliJ:

## Profiles

VSCode supports profiles in which you can setup plugins, editor settings and configurations. This helps if you you are work on multiple tech stacks and have a lot of plugins. Creating multiple profiles with only a few combination of plugins enabled with each profile. For example, I have the [Gitlens plugin](https://marketplace.visualstudio.com/items?itemName=eamodio.gitlens) enabled on all profiles and I created a Terraform profile with the [Terraform plugin](https://marketplace.visualstudio.com/items?itemName=hashicorp.terraform) (not one of the better plugins on VSCode) and I created a Kubernetes profile with the [Kubernetes](https://marketplace.visualstudio.com/items?itemName=ms-kubernetes-tools.vscode-kubernetes-tools) and [Helm](https://marketplace.visualstudio.com/items?itemName=Tim-Koehler.helm-intellisense) plugin. When the Terraform plugin is enabled, the Kubernetes and Helm plugin remain disabled. This keeps VSCode running light while not being encumbered by other plugins that might not be used during your current work.

## Customizability

This might be a subjective factor but in my opinion a big one. VSCode is so customizable that its possible that one setup can be drastically different than the other one. You can configure keybindings, themes, panes, scrolls, etc. The basic settings are good but having an option of this customizability increases productivity.

## Open Source

VSCode was initally created by Microsoft and then it was open sourced. It is managed in [Github](https://github.com/microsoft/vscode) which means using VSCode requires no additional cost of licenses and is available on a lot of different platforms.

## Extensions

VSCode has a [tremendous extension marketplace](https://marketplace.visualstudio.com/). There is an extension for almost everything.


# Migrating from IntelliJ to VSCode

Migrating to VSCode from IntelliJ after using IntelliJ for years can be daunting but its not a bad experience.

> This migration guide is subject to how I work. YMMV

## Getting used to the new interface

The command palette (⌘+p) is your friend. All settings, default and extension's, are accessible through the command palette.

## Extensions

Some extensions that I use for my VSCode setup are as follows.

### Gitlens

[Supercharge Git with Gitlens](https://marketplace.visualstudio.com/items?itemName=eamodio.gitlens).
Gitlens provides features like git blame within the editor, interactive Git history, commit graph, etc. It has a lot of features available in the free tier.

### UI/UX improvement extensions

#### Material Icon Theme

[Material Icon theme](https://marketplace.visualstudio.com/items?itemName=PKief.material-icon-theme) updates all the file icons based on material icons. They make the files explorer look cleaner.

#### One Dark Pro

[One Dark Pro](https://marketplace.visualstudio.com/items?itemName=zhuangtongfa.Material-theme) sets an Atom style dark theme.

### Development

Apart from language SDKs, I use the following plugins for development

#### Kubernetes

Since I work closely with Kubernetes, the [Kubernetes extension](https://marketplace.visualstudio.com/items?itemName=ms-kubernetes-tools.vscode-kubernetes-tools) is a must have for me. It provides rich support for Kuberentes manifests and clusters. The Helm support is works smoothly when working with helm charts.

#### GCP Cloud Code plugin

When working with GCP, the [GCP Cloud Code plugin](https://cloud.google.com/code/docs/vscode/install) can be invaluable. It provides access to services like Cloud Run and GKE. It also supports development with Gemini.
The Cloud Code plugin also has Skaffold support which can support deploying and debugging an application to the GKE cluster directly from the IDE.


