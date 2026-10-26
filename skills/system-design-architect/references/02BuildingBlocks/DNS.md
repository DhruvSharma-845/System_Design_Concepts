---
title: "DNS"
type: building_block
domain: [networking, distributed-systems]
tags: [dns, name-resolution, domain-names, ip-addresses, hierarchical-database, root-servers, authoritative-servers]
summary: "Resolving domain names to IP addresses through a distributed hierarchy of local, root, top-level domain, and authoritative DNS servers."
use_when:
  - "Resolving service domain names to IP addresses"
  - "Understanding hierarchical DNS lookups"
related:
  - "01Foundation/NetworkCommunication.md"
status: partial
---

# What it is
DNS helps in resolving domain name of the server to the IP address.  
DNS is a widely distributed, hierarchical database that acts as the address book of the internet.

# How it works
- A small number of root DNS servers, which are highly replicated, are the starting point for resolving an IP address
- When an internet browser tries to find a website, a network host known as the local DNS server (managed by your employer or ISP) will contact a root DNS server with the requested hostname. 
- The root server replies with a referral to a so-called _authoritative_ DNS server that manages name resolution for, in our banking example, _.com_ addresses. There is an authoritative name server for each top-level internet domain.
- the local DNS server will query the _.com_ DNS server, which will reply with the address of the DNS server that knows about all the IP addresses managed by the next level server.
- This DNS is queried, and it returns the actual IP address we need to communicate with the application.