---
title: "{{ replace .Name "-" " " | title }}"
subtitle: ""
date: {{ .Date }}
draft: true
story: []
categories:
- tutorial
tags: []
pagefindWeight: "0.1"
slug: {{ replace (lower .Name) " " "-"}}
---
