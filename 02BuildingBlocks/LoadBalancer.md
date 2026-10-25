---
title: "Load Balancer"
type: building_block
domain: [distributed-systems, networking]
tags: [load-balancing, scale-out, replicas, stateless-services]
summary: "Distributing client requests across service replicas to keep each equally busy, and relaying responses back."
use_when:
  - "Scaling out a service to multiple replicas"
  - "Removing a single server as a bottleneck or point of failure"
related:
  - "01Foundation/Scalability.md"
  - "04Architectures/MonolithArchitecture.md"
  - "04Architectures/Microservices.md"
status: stub
---

# What it is
To keep each resource equally busy, a load balancer distributes the client requests among the service replicas. It also relays the responses from the service back to the client.

# When it is needed