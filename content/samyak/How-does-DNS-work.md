---
title: "How does DNS work?"
date: 2023-01-30T11:44:59+05:30
draft: false
category: ["networking"]
---

## What is DNS?

Internet is a huge interconnection of systems across the world. Each host connect to the internet is assigned an IP (Internet Protocol) address which uniquely identifies each host.
Imagine a world where you go to your browser and put in `207.241.224.2` to see the internet archives or `20.207.73.82` to code collaboratively. Soon everybody would require a phone book to just use the internet.

This work of the phone book is delegated to a Domain Name System (DNS). DNS translates human readable internet addresses like `github.com` or `archive.org` to the respective IP address `20.207.73.82` and `207.241.224.2` which can be used to connect to systems on the internet.

## How does DNS actually work?
The address resolution happens in at multiple levels

1. Request: A client device, such as a computer or smartphone, sends a request to resolve a domain name to an IP address. 
2. Caching: The request is first sent to a local DNS cache, which stores previous DNS lookups to speed up subsequent requests. 
3. Recursive query: If the local cache doesn't have the IP address, the request is sent to a recursive DNS resolver, typically provided by the user's Internet Service Provider (ISP). 
4. Root server: The recursive resolver queries the root DNS servers for the address of the top-level domain (e.g. .com, .org, .net). 
5. Top-level domain server: The root server responds with the IP address of a top-level domain (TLD) server responsible for the desired TLD (e.g. .com). 
6. Authority server: The TLD server responds with the IP address of the authoritative name server for the desired domain (e.g. example.com). 
7. Record lookup: The authoritative name server returns the IP address associated with the domain name requested. 
8. Response: The recursive resolver returns the IP address to the client device, which can then use it to connect to the desired website or service. 
9. Caching: The IP address is stored in the local DNS cache for a specified period of time, known as the Time-To-Live (TTL), to speed up subsequent requests for the same domain name.

10. This process happens quickly and transparently to the end user, allowing them to access websites and services using human-readable domain names.
