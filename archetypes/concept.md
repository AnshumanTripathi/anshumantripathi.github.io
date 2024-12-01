---
title: "{{ replace .Name "-" " " | title }}"
date: {{ .Date }}
draft: true
story: []
categories:
- concepts
tags: []
featuredImage: ""
featuredImageCaption: ""
pagefindWeight: "0.1"
slug: {{ replace (lower .Name) " " "-"}}
---
