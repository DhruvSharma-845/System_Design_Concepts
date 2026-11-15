---
title: "API Gateway"
type: building_block
domain: [distributed-systems, networking, security]
tags: [api-gateway, microservices, proxy, authentication, authorization, caching]
summary: "A single entry point for client requests that proxies to microservices and can provide authentication, authorization, and caching."
use_when:
  - "Routing client requests to backend microservices"
  - "Centralizing client-facing authentication, authorization, or caching"
related:
  - "04Architectures/Microservices.md"
  - "02BuildingBlocks/Authentication&Authorization.md"
  - "01Foundation/Caching.md"
status: partial
---

# What it is
It is a single entry point for all client requests in microservices architecture.

# Advantages
- It insulates clients from the underlying architecture
-  clients are oblivious to internal changes

# Capabilities
- Proxy incoming client API requests to backend microservices that implement the API
- Provide authentication and authorization
- Support a cache for API results
