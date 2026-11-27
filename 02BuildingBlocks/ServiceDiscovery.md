---
title: "Service Discovery"
type: building_block
domain: [distributed-systems, networking]
tags: [service-discovery, dns, name-resolution, load-balancing]
summary: "Finding service processes and their addresses, including DNS-based discovery and its caching and load-balancing limitations."
use_when:
  - "Locating service instances whose addresses can change"
  - "Evaluating DNS-based service discovery and stale records"
related:
  - "02BuildingBlocks/DNS.md"
  - "02BuildingBlocks/LoadBalancer.md"
  - "02BuildingBlocks/DeploymentOrchestrator.md"
status: partial
---

# What it is
Service-discovery tools help solve the problem of finding which processes are listening at which addresses for which services.
In order to make a request to a service, the code needs to know the network location (IP address and port) of a service instance.  
Since IP addresses do not remain static, an application must use a dynamic service discovery mechanism.  

# Characteristics
- Its key component is a service registry, which is a database of the network locations of an application’s service instances.
- The service discovery mechanism updates the service registry when service instances start and stop.
- When a client invokes a service, the service discovery mechanism queries the service registry to obtain a list of available service instances and routes the request to one of them.
- A client might cache the service instances. The service client then uses a load-balancing algorithm, such as a round-robin or random, to select a service instance

# Self-Registration
 A service instance invokes the service registry’s registration API to register its network location. It may also supply a health check URL.

# Platform-provided service discovery
The deployment platform gives each service a DNS name, a virtual IP (VIP) address, and a DNS name that resolves to the VIP address.  
A service client makes a request to the DNS name/VIP, and the deployment platform automatically routes the request to one of the available service instances.  
One drawback of platform-provided service discovery is that it only supports the discovery of services that have been deployed using the platform.  

## How DNS acts as service discovery
DNS is designed for relatively stable name resolution with wide and efficient caching

## Issues with DNS
- It uses TTL to clean stale entries but there is a natural delay between when a name resolution changes and when the client notices.
- The way that clients handle multiple IPs in a DNS record is usually to take the first IP address and rely on the DNS server to randomize or round-robin the order of records. This is no substitute for more purpose-built load balancing.