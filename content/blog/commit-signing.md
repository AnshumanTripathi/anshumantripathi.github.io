---
title: "Commit Signing"
date: 2023-05-05T22:35:45-07:00
draft: false
categories:
- concepts
series:
- samyak
tags:
- git
---

<!-- TOC -->
* [What is commit signing](#what-is-commit-signing)
* [Why you should sign a git commit](#why-you-should-sign-a-git-commit)
  * [Avoid impersonations](#avoid-impersonations)
  * [Secure repository against malicious changes](#secure-repository-against-malicious-changes)
  * [Safety against supply chain attacks](#safety-against-supply-chain-attacks)
  * [The verification badge](#the-verification-badge)
* [How to sign commits with Github](#how-to-sign-commits-with-github)
  * [Setup your GPG key](#setup-your-gpg-key)
  * [Setup Git CLI to sign commits by default](#setup-git-cli-to-sign-commits-by-default)
  * [Add GPG key to your Github account [^2]](#add-gpg-key-to-your-github-account-2)
  * [Enforce signed commits](#enforce-signed-commits)
* [References](#references)
<!-- TOC -->

# What is commit signing
Signing a commit means adding a cryptographic hash which can be only generated through the author's private key (called "signature"), thus verifying the identity of the author of the commit. To sign a commit, a developer uses a [GPG (GNU Privacy Guard) key](https://gnupg.org). GPG allows you to encrypt and sign your data and communications; it features a versatile key management system and access modules for all kinds of public key directories [^1].
When an author creates a GPG signature, it is generated as a combination of a private key and a public key, the private key is saved on the author's computer, and the public key is shared with the version control system, which uses the public key to verify the commits which contain a hash generated using the private key.

# Why you should sign a git commit
## Avoid impersonations
If an author does not sign their commits, it becomes simple to impersonate them. Anyone who has access to contribute to a repository can update `git config user.email` and `git config user.name` to the details of the author who does not sign their commits impersonating the author.
You can avoid impersonations when you sign commits; as a commit can only be signed by the author's private key (or someone with the author's private key), a signed commit becomes proof that the author made the commit from the commit details. Programs like GPG provide a way to generate and manage keys (signatures) and sign commits only after entering a signing password, making using a compromised private key difficult. When you habitually sign all your commits, an unsigned commit can be flagged as an impersonation for further investigation.

## Secure repository against malicious changes
Suppose an attacker tries to impersonate a repository collaborator who has been making regular stable updates. In that case, the attacker can create a pull request (or a merge request) impersonating an author, increasing the odds of getting approval on the code changes.

## Safety against supply chain attacks
A supply chain attack is a cyber-attack where an attacker targets a company or organization's supply chain, including all the vendors, suppliers, and contractors the organization relies on to conduct its operations.
In a supply chain attack, a malicious user can insert code and backdoor vulnerabilities in open-source libraries and packages used in applications in different companies. When the companies update their code to use the updated libraries, the attacker exploits the vulnerabilities and attacks the applications.
In other instances, a disgruntled employee who knows internal libraries and packages used by an application creates a replica in open source with the same name with a newer version. When a company uses a mix of internal libraries and open-source code, the package managers pull in code from open-source instead of the internal repositories, which inject applications with malicious code.

When a repository enforces signing commits, it provides authenticity that all the code in the repository comes from accepted collaborators. Having commit signing enforced in the repository, which provides critical features, ensures the repository is compromised with a supply chain attack.

## The verification badge
A signed commit shows up with the `Verified` badge in the source control system.
![alt text](/images/verified-commit.jpg)

# How to sign commits with Github
## Setup your GPG key
1. Install the latest version of GPG tools from https://www.gnupg.org/download/.
2. Generate a GPG key pair
    ```shell
    gpg --full-generate-key
    ```
3. View the generated key
    ```shell
    gpg --list-keys
    ```
## Setup Git CLI to sign commits by default

```shell
git config --global commit.gpgsign true
git config --global user.signingkey <signingkey_key_id>
```

## Add GPG key to your Github account [^2]
1. In the upper-right corner of any page, click your profile photo, then click Settings.
2. In the "Access" section of the sidebar, click SSH and GPG keys.
3. Next to the "GPG keys" header, click New GPG key.
4. In the "Title" field, type a name for your GPG key.
5. In the "Key" field, paste the GPG key you copied when you generated your GPG key.
6. Click Add GPG key.
7. To confirm the action, authenticate to your GitHub account.

## Enforce signed commits
When working with critical repositories, enforcing signed commits on your GitHub repositories can protect your libraries from impersonation and supply chain attacks.
1. Go to your Github repo and click `Settings`.
2. Click `Branches`.
3. Click `Edit` on your main branch.
4. Under `Protect matching branches`, check `Require signed commits`.
5. Click `Save Changes`.


# References
[^1]: https://gnupg.org
[^2]: https://docs.github.com/en/authentication/managing-commit-signature-verification/adding-a-gpg-key-to-your-github-account#adding-a-gpg-key

