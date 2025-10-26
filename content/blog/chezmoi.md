---
title: "Managing dotfiles with Chezmoi"
subtitle: "Managing dotfiles made easier with Chezmoi"
date: 2024-12-01T15:37:07-08:00
draft: false
description: "Learn how to efficiently manage your dotfiles across multiple machines using Chezmoi. A practical guide covering templates, encryption, automation, and machine-specific configurations."
series:
- devops
- samyak
categories:
- concepts
tags:
- tools
featuredImage: "images/chezmoi.jpeg"
featuredImageCaption: "Image generated from Google Gemini."
pagefindWeight: "0.1"
slug: managing-dotfiles-with-chezmoi-guide
---

Dotfiles are the hidden configuration files that customize your system - from your shell preferences to your Git configuration. They're called dotfiles because they start with a dot (.) and are typically hidden from regular directory listings. Whether you're a developer, system administrator, or power user, these files are crucial to maintaining your productive workflow across different machines.

But managing dotfiles comes with its challenges. As our configurations grow more complex, we often need different settings for different machines - work versus personal, Linux versus macOS, or even specific configurations for different projects. Traditional methods like manual copying or basic symlinks quickly become cumbersome and error-prone.

## The Challenge of Dotfile Management

Think about these common scenarios:
- You get a new work laptop and need to set up your entire development environment
- You want to maintain slightly different configurations between your work and personal machines
- You need to securely manage sensitive information within your configurations
- You want to automate the installation of tools and packages alongside your configurations

While simple solutions like creating symlinks from a Git repository might work initially, they fall short when dealing with machine-specific configurations, sensitive data, or automated setup processes.

## Why Traditional Methods Fall Short

I have always managed dotfiles manually by creating them in my `dotfiles` github directory and then creating the respective symlink from where it can be sourced. Although this mostly works, it's not flexible enough for the following reasons:

1. Requires manual symlinks to all configs
2. It's not possible to template dotfiles for machine or profile specific configurations
3. No integration with password manager for secret injection
4. No encryption support for sensitive configurations
5. Requires overhead for automating pushing to git

Enter Chezmoi - a modern dotfile manager that addresses these challenges and more. Let's explore how this powerful tool can transform the way we manage our system configurations.

## Chezmoi to the rescue!

[Chezmoi](https://www.chezmoi.io/) is an open source tool that makes managing dotfiles across different machines very seamless. Not only does it make version control easy, it also provides some nifty features that make using this tool totally worth it.

Although Chezmoi has a great variety of features, the following features are the ones that I feel are the core of Chezmoi.

### Templates

Templates in Chezmoi handle machine-specific configurations elegantly. For example, use different Git email addresses for work and personal machines. Chezmoi supports creating Go templates for dotfiles and config files to manage changes based on different configurations. I particularly find this useful for managing different Git configurations between my work and personal machines.

### Full file encryption

Chezmoi supports encrypting sensitive files using `age`, `gpg` or `rage` encryption. This allows Chezmoi to manage sensitive configurations like ssh configurations.

### Running scripts

Chezmoi supports running executable scripts taking dotfile and configuration file management to the next level and allowing to actually setup a system, like installing packages through a package manager like `brew` making package installation on a system a declarative process.

### Integration with password manager

Chezmoi supports fetching secrets to dotfile and configuration file templates through different password managers. Find all the password manager integrations here - https://www.chezmoi.io/user-guide/password-managers/.

## Using Chezmoi

### Installation

[Chezmoi supports a wide array of installation methods](https://www.chezmoi.io/install/). Since I am using Chezmoi for my Macbook setup I use brew and install it as follows

```shell
brew install chezmoi
```

### Setup

[Chezmoi is very easy to setup](https://www.chezmoi.io/user-guide/setup/#use-a-hosted-repo-to-manage-your-dotfiles-across-multiple-machines). To add dotfiles to be managed by Chezmoi run `chezmoi add ~/.zshrc`. This creates a `dot_zshrc` file in the Chezmoi directory which can be seen with `ls "$(chezmoi source-path)"`. To stop a file being managed from Chezmoi run `chezmoi forget ~/.zshrc`.

> NOTE: I am using `~/.zshrc` as an example. Replace it with any file that needs to be managed by Chezmoi like `~/.vimrc`, etc.

To update a managed file run `chezmoi edit ~/.zshrc` and update the file. This updates the `dot_zshrc` file in Chezmoi source-path. (Updating the `dot_zshrc` in the source path will also achieve the same result). Now running a `chezmoi diff` shows the changes between `~/.vimrc` and `$(chezmoi source-path)/dot_zshrc` file. Running `chezmoi apply` will apply the changes to `~/.vimrc` file.
Now the changes can be committed to the repo with `chezmoi git -- <add/commit -m>` commands.

[Chezmoi can be used with a hosted github repository (Github, Bitbucket, etc.) to version control dotfiles](https://www.chezmoi.io/user-guide/setup/#use-a-hosted-repo-to-manage-your-dotfiles-across-multiple-machines). To do this create a `dotfiles` repo and add it to chezmoi as follows:

```bash
$ chezmoi cd
$ git remote add origin https://github.com/$GITHUB_USERNAME/dotfiles.git
$ git push -u origin main
$ exit
```

### Encryption

[Chezmoi supports encryption through `age`, `gpg` and `rage`](https://www.chezmoi.io/user-guide/encryption/). This allows Chezmoi to manage sensitive configurations like `~/.ssh/id_rsa`. I am using GPG for encrypting with Chezmoi, here's how I set up GPG encryption:

1. Create an encryption key with GPG. Copy the recepient of the GPG key.
2. Add the following config to Chezmoi
  ```toml
    [gpg]
       args = ["--quiet"]
       recipient = "32EAC9CCB3CA960E03893BA4647FB5AF905AA26D"
  ```

> NOTE: The GPG recipient is the receipeint of my GPG key. Please update this configuration with your GPG key.

### Automating machine setup using Chezmoi

Chezmoi supports running scripts by creating executable scripts with a specific prefix which can be used to run different operations. Chezmoi user guide provides great examples on how to do this, for example - [Installing Packages with Scripts](https://www.chezmoi.io/user-guide/use-scripts-to-perform-actions/#install-packages-with-scripts).

The `run_onchange_install-packages.sh` script looks at the `packages.yaml` file which includes all the packages that the script installs. To ensure that the script only runs when the list of packages is updated we need to ensure a change is detected only when the hash of the packages file changes. To do that we can convert the script to a template and add a hash to the file

```yaml
# packages.yaml hash: {{ .packages | toString | sha256sum }}
```

[Refer to my dotfiles to see how I have setup my package install script to run when the list of packages is updated](https://github.com/AnshumanTripathi/dotfiles/blob/main/.chezmoiscripts/run_onchange_install-packages.sh.tmpl).

[Read more about running a script on a file change here](https://www.chezmoi.io/user-guide/use-scripts-to-perform-actions/#run-a-script-when-the-contents-of-another-file-changes).


### Managing machine to machine differences

Not every machine would need the same configurations. For example, a work computer would need different configurations than a personal computer. To achieve this, convert the dotfile to a template with `chezmoi chattr +template ~/.zshrc`. Now we can use chezmoidata values which are as follows

```shell
❯ chezmoi data | jq '.chezmoi | keys[]'
"arch"
"args"
"cacheDir"
"command"
"commandDir"
"config"
"configFile"
"destDir"
"executable"
"fqdnHostname"
"gid"
"group"
"homeDir"
"hostname"
"kernel"
"os"
"osRelease"
"pathListSeparator"
"pathSeparator"
"sourceDir"
"uid"
"username"
"version"
"windowsVersion"
"workingTree"
```

The template can be created with `hostname`, for example:

```
 {{- if eq .chezmoi.hostname "Anshumans-M2-MacBook-Air" }}
```

[We can also use functions like `promptStringOnce`](https://www.chezmoi.io/reference/templates/init-functions/promptStringOnce/), that can be used to take an input from the user when `chezmoi init` is executed. For example:

```
{{- $email := promptStringOnce . "email" "Email address" -}}
```

Will prompt `Email Address` when `chezmoi init` is executed. Then we can use it as `{{ $email }}`. Chezmoi also provides a way to test templates.

```shell
❯ chezmoi execute-template '{{ .chezmoi.hostname }}'
Anshumans-M2-MacBook-Air%
```

### Chezmoi state management

Chezmoi is similar to tools like Terraform and ArgoCD, i.e., they all use a state to track changes to your dotfiles. The target state is kept from the working copy which is created by running `chezmoi apply`. This state is kept in a local [boltdb](https://github.com/etcd-io/bbolt) database and can be viewed with `chezmoi state dump`.

[Chezmoi state can be accessed using the `chezmoi state` command](https://www.chezmoi.io/reference/commands/state/).

Using state management, Chezmoi can efficiently provide features like `diff` and running scripts at stages like `run_onchange` or `run_once`, etc.

## Conclusion

Chezmoi is the modern way to manage dotfiles and even configure different computers as needed. Not only does it provide a way to manage dotfiles, but also running scripts, templating, encryption, etc. All these features allow Chezmoi to be the new home for your dotfiles. 

For detailed documentation and the latest features, always refer to the [official Chezmoi documentation](https://www.chezmoi.io/). The documentation is comprehensive and regularly updated, making it your best resource for exploring Chezmoi's capabilities beyond what I've covered here. See how I manage my dotfiles using Chezmoi here - https://github.com/AnshumanTripathi/dotfiles. You'll find examples of templates, automation scripts, and machine-specific configurations that I use daily.


