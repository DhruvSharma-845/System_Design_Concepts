---
title: Caching
type: concept
domain:
  - distributed-systems
  - databases
tags:
  - cache
  - database-caching
  - distributed-cache
  - cache-aside
  - cache-invalidation
  - latency
  - read-scaling
summary: Reducing database load and latency with database caching and distributed key-value caches (cache-aside, invalidation). Web Caching
use_when:
  - Read-heavy workloads or hot keys
  - Reducing latency or database load
related:
  - 01Foundation/Scalability.md
  - 01Foundation/Consistency.md
  - 01Foundation/Replication.md
  - 04Architectures/MonolithArchitecture.md
status: partial
---

# Database Caching
Caching stores recently retrieved and commonly accessed database results in main memory so they can be quickly retrieved without placing a burden on the database.  

## Advantages
- caching relieves databases of heavy read traffic, as many queries can be served directly from the cache
- It also reduces computation costs for objects that are expensive to construct

## How it works
Introducing a caching layer also requires your processing logic to be modified to check for cached data. 
- The service first checks the cache to see if the data it requires is available. If so, it returns the cached contents as the results—this is known as a _cache hit_.
- If what you want is not in the cache - cache miss, the service must still query the database and load the results into the cache as well as return it to the caller.

## Implementation Patterns
- Cache Aside: the application code effectively bypasses the data storage systems if the required results are available in the cache.
	- resilient to cache failure. In circumstances when the cache is unavailable, all requests are essentially handled as a cache miss.
- Read through: The application satisfies all requests by accessing the cache. If the data required is not available in the cache, a loader is invoked to access the data systems and load the results in the cache for the application to utilize.
- Write through: The application always writes updates to the cache. When the cache is updated, a writer is invoked to write the new cache values to the database. When the database is updated, the application can complete the request.
- Write Behind: Like write-through, except the application does not wait for the value to be written to the database from the cache.
## Cache Invalidation
Need to decide when to remove, or invalidate, cached results.  
**TTL**: It tells the cache that after TTL seconds this key-value pair should be evicted from the cache as the value is no longer current.
**LRU**: a cache will adopt a policy such as _least recently used_ or _least accessed_ to choose cache entries to evict and create space for more current, timely results.

## Distributed Caching 
It is an essentially distributed in-memory key-value stores with very simple APIs.  The two predominant technologies in this area are [memcached](https://memcached.org/) and [Redis](https://redis.io/)  
Although they are distributed cache engines, they appear as single store to application services.

Accessing the cache requires a remote call from your service but it is less expensive than querying the database.

# Web Caching
Web caches store a copy of a given resource—for example, a web page or an image, for a defined time period.   
The caches intercept client requests and if they have a requested resource cached locally, they return the copy rather than forwarding the request to the target service. Hence, many requests can be satisfied without placing a burden on the service.   
Also, as the caches are physically closer to the client, the requests will have lower latencies.  

Web caching is most effective when deployed for static data

## Levels of cache
- Client's web browser cache
- ISP's web proxy cache
- Edge(CDN) cache
	- live at various strategic geographical locations globally, so that they cache data close to clients
- Reverse Proxy cache at service layer
If no cached content is found, the request is served by the service endpoint, which is also called the origin server

## HTTP caching directives
- Cache Control
	- specify how the caching should be utilized for the resources
	- no-store, no-cache, private, public
	- max-age: Defines the length of time in seconds a cached copy of a resource should be retained. After expiration, a cache must refresh the resource by sending a request to the origin server.
- Expires and Last Modified
	- interact with the `max-age`directive to control how long cached data is retained
	- Freshness is calculated using a combination of header values. 
	- The `"``Cache-Control: max-age=N``"` header is the primary directive, and this value specifies the freshness period in seconds.
	- If `max-age` is not specified, the `Expires` header is checked next. If this header exists, then it is used to calculate the freshness period. The `Expires` header specifies an explicit date and time after which the resource should be considered stale.
	- A cache server can use `Last-Modified` to determine the freshness lifetime of a resource based on a heuristic calculation that the cache supports.
- Etag
	- control cache item freshness
	-  represents the version that was last returned.
	- When the resource becomes stale and a request arrives for a stale resource, the cache forwards it to the origin server with a `If-None-Match` directive along with the `Etag` to inquire if the resource is still valid. This is known as _revalidation_.
	- If the `Etag` in the request matches the value associated with the resource in the service, the cached value is still valid. The origin server can therefore return a `304 (Not Modified)` response.
	- The origin server may ignore the revalidation request and respond with a `200 OK` response code, a response body and `Etag` representing the latest version
