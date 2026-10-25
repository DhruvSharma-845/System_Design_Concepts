---
title: "Caching"
type: concept
domain: [distributed-systems, databases]
tags: [cache, database-caching, distributed-cache, cache-aside, cache-invalidation, latency, read-scaling]
summary: "Reducing database load and latency with database caching and distributed key-value caches (cache-aside, invalidation)."
use_when:
  - "Read-heavy workloads or hot keys"
  - "Reducing latency or database load"
related:
  - "01Foundation/Scalability.md"
  - "01Foundation/Consistency.md"
  - "01Foundation/Replication.md"
  - "04Architectures/MonolithArchitecture.md"
status: partial
---

# Database Caching
Caching stores recently retrieved and commonly accessed database results in memory so they can be quickly retrieved without placing a burden on the database.  

## How it works
Introducing a caching layer also requires your processing logic to be modified to check for cached data. If what you want is not in the cache, your code must still query the database and load the results into the cache as well as return it to the caller.

## Cache Invalidation
Need to decide when to remove, or invalidate, cached results.

# Distributed Caching 
For data that is frequently read and changes rarely, your processing logic can be modified to first check a distributed cache.
It is an essentially distributed key-value stores with very simple APIs.
Accessing the cache requires a remote call from your service but it is less expensive than querying the database.
