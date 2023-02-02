---
title: "How does DNS work?"
date: 2023-01-30T11:44:59+05:30
draft: false
categories:
    - networking
    - concepts
---

## What is DNS?

The internet is a vast interconnection of systems across the world. Each host connected to the internet is assigned an IP (Internet Protocol) address, uniquely identifying each connected host.
Imagine a world where you go to your browser and put in `207.241.224.2` to see the internet archives or `20.207.73.82` to code collaboratively. Soon everybody would require a phone book to use the internet.

Domain Name System or DNS is a lookup functionality for the internet. DNS translates human-readable internet addresses like `github.com` or `archive.org` to their respective IP address like `20.207.73.82` and `207.241.224.2`.

## How does DNS actually work?
The address resolution happens through the following steps:

1. Request: A client device, such as a computer or smartphone, sends a request to resolve a domain name to an IP address.
2. Caching: The local DNS cache receives the request. The local cache stores previous DNS lookups to speed up subsequent requests.
3. Recursive query: If the local cache doesn't have the IP address, the request is sent to a recursive DNS resolver, typically provided by the user's Internet Service Provider (ISP).
4. Root server: The recursive resolver queries the root DNS servers for the address of the top-level domain (e.g., .com, .org, .net).
5. Top-level domain server: The root server responds with the IP address of a top-level domain (TLD) server responsible for the desired TLD (e.g., .com).
6. Authority server: The TLD server responds with the IP address of the authoritative name server for the desired domain (e.g., example.com).
7. Record lookup: The authoritative name server returns the IP address associated with the domain name requested.
8. Response: The recursive resolver returns the IP address to the client device, which can then use to connect to the desired website or service.
9. Caching: The IP address is stored in the local DNS cache for a specified time, known as the Time-To-Live (TTL), to speed up subsequent requests for the same domain name.

This process happens quickly and transparently to the end user, allowing them to access websites and services using human-readable domain names.

```diagon
         ┌────────────────────┐                                
         │USER ENTERS THE HOST│                                
         │NAME IN THE BROWSER.│                                
         └──────────┬─────────┘                                
          __________▽__________         ┌─────────────────────┐
         ╱                     ╲        │RETURN THE IP ADDRESS│
        ╱ ADDRESS MAPPING FOUND ╲_______│TO THE CLIENT DEVICE.│
        ╲ IN LOCAL CACHE.       ╱yes    └─────────────────────┘
         ╲_____________________╱                               
                    │no                                        
      ┌─────────────▽────────────┐                             
      │TRY TO RECURSIVELY RESOLVE│                             
      │USING A DNS RESOLVER      │                             
      │PROVIDED BY THE ISP.      │                             
      └─────────────┬────────────┘                             
    ┌───────────────▽───────────────┐                          
    │QUERY THE ROOT DNS SERVERS FOR │                          
    │THE ADDRESS OF THE TOP LEVEL   │                          
    │DOMAIN (.com, .org, .net, etc).│                          
    └───────────────┬───────────────┘                          
    ┌───────────────▽───────────────┐                          
    │THE REQUEST IS FORWARDED TO THE│                          
    │TOP LEVEL DOMAIN (TLD) SERVER. │                          
    └───────────────┬───────────────┘                          
    ┌───────────────▽──────────────┐                           
    │THE TLD SERVER RESPONDS WITH  │                           
    │THE ADDRESS OF THE AUTHORITY  │                           
    │SERVER FOR THE DESIRED DOMAIN.│                           
    └───────────────┬──────────────┘                           
       ┌────────────▽───────────┐                              
       │THE REQUEST IS FORWARDED│                              
       │TO THE AUTHORITY SERVER │                              
       │FOR IP ADDRESS LOOOKUP. │                              
       └────────────┬───────────┘                              
   ┌────────────────▽────────────────┐                         
   │THE AUTHORITY SERVER RESPONDS    │                         
   │WITH THE IP ADDRESS OF THE DOMAIN│                         
   │FOR THE PROVIDED IP ADDRESS.     │                         
   └────────────────┬────────────────┘                         
┌───────────────────▽──────────────────┐                       
│THE IP ADDRESS IS SENT BACK TO        │                       
│RECURSIVE RESOLVER FOR THE ADDRESS TO │                       
│BE RETURNED BACK TO THE CLIENT DEVICE.│                       
└───────────────────┬──────────────────┘                       
    ┌───────────────▽───────────────┐                          
    │THE IP ADDRESS IS CACHED IN THE│                          
    │LOCAL CACHES FOR FUTURE LOOKUPS│                          
    └───────────────────────────────┘                          
```
Some important terms associated with DNS

#### CNAME
CNAME or a Canonical Name is used to set an alias to a different domain while keeping the same IP address allowing multiple domains to share the same IP address and web content while still having separate domain names.

For example, if you have a website with the domain name `example.com`, you can create a CNAME record for blog.example.com that points to example.com, allowing users to access the same website with two different domains, `example.com` and `blog.example.com`.

When a user uses an alias domain name, DNS will use the CNAME record associated with the alias domain to look up the correct canonical domain name. For example, when a user enters `blog.example.com` in their browser, DNS will check the CNAME record, which would point to `example.com` and then use the `example.com` domain name to find the IP address.

A Record
An A record or an Address record is a type of DNS record used to map a canonical domain name to an IP address. When a user types in a domain name, The browser uses the DNS system to look up the corresponding IP address for that domain name.

It is important to note that each domain name can have multiple A records, each with a different IP address to support highly available load-balanced systems having redundant servers to handle failovers.


#### AAAA Record
An AAAA (Quad A) record is similar to [A record](#a-record). An A record is used for IP v4 addresses, while a Quad A record is used for IP v6 addresses. If a domain has both A and AAAA records, then DNS will first try to resolve the domain using the AAAA record, and if that fails, it will fall back to using an A record.

SOA
SOA or Start of Authority is a record in the DNS system that specifies the authoritative information about a domain, including the domain's primary name server, the domain administrator's email address, and various other parameters that determine the behavior of the domain's DNS server.
The SOA record is the first record in a DNS zone file and is used by other DNS servers to determine the authoritative source of information for a particular domain. It also defines the refresh interval, which is the time a secondary [name server](#name-servers) waits before checking for updates from the primary name server, and the retry interval, which is the time a secondary server waits before trying to contact the primary server again if it fails to respond.

The information in the SOA record is crucial for the proper functioning of the DNS system and for ensuring that the correct information is for a given domain.

#### Name servers
Name servers in DNS are the servers that store information about a specific domain and respond to queries about the domain's DNS records. They act as a central repository for information about a domain, including its IP address, mail servers, and other information required to route and deliver requests to the correct destination.

There are two types of name servers in the DNS system: authoritative and recursive.

1. Authoritative name servers are responsible for storing the actual DNS records for a domain. They are the ultimate source of truth for information about the domain and respond to queries about the domain's records.
2. Recursive name servers are used by client devices to resolve domain names to IP addresses. They receive a request to resolve a domain name and forward the request to the appropriate authoritative name server, returning the response to the client device.

The domain owner can configure the name servers for a domain specified in the domain's SOA (Start of Authority) record. Other parts of the DNS system use the information provided by the name servers to route and deliver requests to the correct destination.

#### DNSSEC
DNSSEC (Domain Name System Security Extensions) records are a set of security extensions to the DNS (Domain Name System) that provide authentication and data integrity for DNS information.

DNSSEC uses public-key cryptography and digital signatures to secure the DNS information and prevent tamperings and malicious attacks, such as cache poisoning and DNS spoofing.

There are several types of DNSSEC records, including:

1. DS (Delegation Signer) record: Used to link a child domain to its parent domain and establish the chain of trust.
2. DNSKEY record: Contains the public key used to verify the digital signature of the RRSIG record.
3. RRSIG (DNSSEC Signature) record: Contains the digital signature for a specific DNS record.
4. NSEC (Next Secure) record: Provides proof of the non-existence of a DNS record.
   Together, these DNSSEC records ensure the authenticity and integrity of the DNS information and provide a secure chain of trust for DNS queries. By using DNSSEC, organizations, and users can be confident that the information returned by the DNS system is accurate and has not been tampered with.

#### NSEC
NSEC (Next Secure) is a type of DNS record used in Domain Name System Security Extensions (DNSSEC) to prove the non-existence of a DNS record.

DNSSEC is a security extension to the DNS that provides authentication and data integrity for DNS records. It uses public-key cryptography and digital signatures to provide a secure chain of trust from the domain name system's root down to individual records.

The NSEC record provides proof that a specific record does not exist in the domain name system, thus helping to prevent cache poisoning attacks, where an attacker tries to insert false information into the DNS cache to redirect users to a fake website. By providing proof of the non-existence of a record, DNSSEC can help to prevent these types of attacks and ensure that users receive accurate information from the DNS system.

NSEC records are used in conjunction with other DNSSEC records, such as the DS (Delegation Signer) record and the RRSIG (DNSSEC Signature) record, to provide a secure chain of trust for DNS information.

### Troubleshooting DNS with dig
`dig` is an extremely useful command (available in linux and unix systems) to troubleshoot DNS issues. Following is the description from dig's man page

> dig (domain information groper) is a flexible tool for interrogating DNS name servers. It performs DNS lookups and displays the answers that are returned from the name server(s) that were queried. Most DNS administrators use dig to troubleshoot DNS problems because of its flexibility, ease of use and clarity of output. Other lookup tools tend to have less functionality than dig.

Let's see an example

```shell
dig +trace github.com

; <<>> DiG 9.10.6 <<>> +trace github.com
;; global options: +cmd
.			86251	IN	NS	a.root-servers.net.
.			86251	IN	NS	b.root-servers.net.
.			86251	IN	NS	c.root-servers.net.
.			86251	IN	NS	d.root-servers.net.
.			86251	IN	NS	e.root-servers.net.
.			86251	IN	NS	f.root-servers.net.
.			86251	IN	NS	g.root-servers.net.
.			86251	IN	NS	h.root-servers.net.
.			86251	IN	NS	i.root-servers.net.
.			86251	IN	NS	j.root-servers.net.
.			86251	IN	NS	k.root-servers.net.
.			86251	IN	NS	l.root-servers.net.
.			86251	IN	NS	m.root-servers.net.
.			86251	IN	RRSIG	NS 8 0 518400 20230215060000 20230202050000 951 . shgCtuO0XufPswkzQkwltbwHBi4HlRtWdCGcMAS68gBzwmiEcpL2irkl ZpKY73M0vDj7Bm6Eagwp18u3FtHNDjcp2pQRXSz6dNeQAYYPsb38xrGU 3SmCSY6MYchSNX/Jc5+f49woVaErv1zhV5ZnHkjOMDY3LGjQ0V4dR2iT fk+SEydfBZDlsvkQIGv7R1Q2Gh4EtGoOu0awOKir1XD4cDHpfce6kBax OB2DQaom4J6UsHUfd+jQlQ6U/Ro7EkX9LYDHGvwq3qpTvSs0IQNg4jwu k13EtAq/F7pTecqBb/AzEbTxu3HgTUIUoWgBfQ1ICYPQAWwFzqrFvILd YXgiRQ==
;; Received 525 bytes from 8.8.8.8#53(8.8.8.8) in 20 ms

com.			172800	IN	NS	a.gtld-servers.net.
com.			172800	IN	NS	b.gtld-servers.net.
com.			172800	IN	NS	c.gtld-servers.net.
com.			172800	IN	NS	d.gtld-servers.net.
com.			172800	IN	NS	e.gtld-servers.net.
com.			172800	IN	NS	f.gtld-servers.net.
com.			172800	IN	NS	g.gtld-servers.net.
com.			172800	IN	NS	h.gtld-servers.net.
com.			172800	IN	NS	i.gtld-servers.net.
com.			172800	IN	NS	j.gtld-servers.net.
com.			172800	IN	NS	k.gtld-servers.net.
com.			172800	IN	NS	l.gtld-servers.net.
com.			172800	IN	NS	m.gtld-servers.net.
com.			86400	IN	DS	30909 8 2 E2D3C916F6DEEAC73294E8268FB5885044A833FC5459588F4A9184CF C41A5766
com.			86400	IN	RRSIG	DS 8 1 86400 20230215060000 20230202050000 951 . eeX+SIe/mrEDaX+91XtQusdd0RPqPcDZubR7ChRGkR4za67c1Ax5mhpo 07KpYnmMpg4pS/mmRMLl5dbi5j9kwvkoKYw0gx8xz6Y173/qYhXm5ihf bitvV8ueuq5bbnHmAwLdf8QLj4xY92X0mbhg6UNUKCRbIQNXQsLmXqHQ ax2SPfi98Dt8/cBCnFjfk16jrekERSXJlIliampc/KljHHYMsaZBwpnh 1mxAIYwQ7xDlvPVUzQfhBTZ8VC/ZBZ4VNldCYkhn/e9eBEOReUl8Zm/G QXYhlzQ2lV44rKEwlDH9EDwbc6jV6YLqzs6MJ9ZJfmcRSzlK235X3rkl mCAQUQ==
;; Received 1170 bytes from 2001:7fd::1#53(k.root-servers.net) in 129 ms

github.com.		172800	IN	NS	ns-520.awsdns-01.net.
github.com.		172800	IN	NS	ns-421.awsdns-52.com.
github.com.		172800	IN	NS	ns-1707.awsdns-21.co.uk.
github.com.		172800	IN	NS	ns-1283.awsdns-32.org.
github.com.		172800	IN	NS	dns1.p08.nsone.net.
github.com.		172800	IN	NS	dns2.p08.nsone.net.
github.com.		172800	IN	NS	dns3.p08.nsone.net.
github.com.		172800	IN	NS	dns4.p08.nsone.net.
CK0POJMG874LJREF7EFN8430QVIT8BSM.com. 86400 IN NSEC3 1 1 0 - CK0Q2D6NI4I7EQH8NA30NS61O48UL8G5  NS SOA RRSIG DNSKEY NSEC3PARAM
CK0POJMG874LJREF7EFN8430QVIT8BSM.com. 86400 IN RRSIG NSEC3 8 2 86400 20230207052257 20230131041257 36739 com. bIC3JRS3i5tgfH6Kn2lqyHxTgaWT5HPky5puq3ue83uT+ahEG6nNnuR8 ydUphSSrvIYJBJ1ny0zEG1AG/4NLRiaULJzu4TCW7i6Nh5uD/7x+n1Jp v87utrvOtBslzssHr4rBX/tyi/k8dzDl4DwWdeaVdY4aTiP++q/ePyOI sYiaflykYTR9YJVvL4AyoXClBFGMW9MUWLv6DtMNl2w8Lg==
4KB4DFS71LEP8G8P8VT4CCUSQNL4CNCS.com. 86400 IN NSEC3 1 1 0 - 4KB4PTQQ5CTA7POCTGM7RUFC8B1RKTEU  NS DS RRSIG
4KB4DFS71LEP8G8P8VT4CCUSQNL4CNCS.com. 86400 IN RRSIG NSEC3 8 2 86400 20230208055340 20230201044340 36739 com. JC1p1yrAzea9WEGnT1b3c9caxuwpz0ZXcanV+PQG8HDy98hRIG4+TNXM i0mnDjMAN61OtthOKWqbucchfRcHPHWwF/SXrtCBAlgsvp/QAHcHPInb F3MQu6rqXDkQJXkRqT6Zf3bigSzLg0E4ysPpK+vDaDZYOHrrB7u59HVb pKskzTowIKt+eTnvF4dDo3FPTvwfy4i0AN102b8OgirCaQ==
;; Received 827 bytes from 192.33.14.30#53(b.gtld-servers.net) in 41 ms

github.com.		60	IN	A	20.207.73.82
;; Received 55 bytes from 198.51.45.8#53(dns2.p08.nsone.net) in 44 ms
```

The above output shows DNS lookup information for `github.com` domain. The output shows [A record](#a-record), [SOA Record](#soa), [DNSEC](#dnssec), root servers used for lookup, and other relevant information associated with this domain.
