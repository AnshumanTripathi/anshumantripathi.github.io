---
title: "{{ replace .Name "-" " " | title }}"
date: {{ .Date }}
draft: true
categories:
- My story
tags: []
featuredImage: ""
featuredImageCaption: ""
pagefindWeight: "0.1"
slug: {{ replace (lower .Name) " " "-"}}
---
