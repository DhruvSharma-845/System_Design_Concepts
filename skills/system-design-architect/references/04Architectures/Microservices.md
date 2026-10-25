---
title: "Microservices"
type: architecture
domain: [distributed-systems]
tags: [services, service-boundaries, independent-deployment, api, load-balancing, caching]
summary: "Decomposing a system into cohesive, independently deployed services that communicate remotely (e.g., HTTP)."
use_when:
  - "Large systems with independent teams or deployment needs"
related:
  - "01Foundation/NetworkCommunication.md"
  - "02BuildingBlocks/LoadBalancer.md"
  - "01Foundation/Caching.md"
  - "04Architectures/MonolithArchitecture.md"
  - "04Architectures/EventDrivenArchitecture.md"
  - "04Architectures/SecurityArchitectures.md"
status: partial
---

# What it is
It consists of cohesive services that are independently deployed processes and communicate using remote communications mechanisms such as HTTP.
# How it works
 A service can call one or more dependent services, which in turn are replicated and load-balanced and employs caching to provide high performance and availability.

# Advantages
- By breaking the application into multiple independent services, you can scale each based on the service demand
- can be separately built, tested, deployed.