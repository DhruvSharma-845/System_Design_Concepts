---
title: "Monolith Architecture"
type: architecture
domain: [distributed-systems]
tags: [monolith, three-tier, stateless-services, scale-up, scale-out, caching]
summary: "Three-tier monolith (client, application service, database): request flow, limitations, and how to scale it."
use_when:
  - "Early-stage or simple systems"
  - "Deciding when a monolith needs scaling or decomposition into microservices"
related:
  - "02BuildingBlocks/LoadBalancer.md"
  - "01Foundation/Scalability.md"
  - "01Foundation/Caching.md"
  - "01Foundation/Replication.md"
  - "01Foundation/Sharding.md"
  - "04Architectures/Microservices.md"
status: partial
---

# Three-tier
It comprises of a client tier, application service tier, and a database tier.

## Workflow
- Users submit requests to the application from their mobile app or web browser. 
- The magic of internet networking delivers these requests to the application service which is running on a machine hosted in some corporate or commercial cloud data center. Communications uses a standard application-level network protocol, typically HTTP.
- Upon receipt of a request, the service executes the code associated with the requested API. In the process, it may read from or write to a database or some other external system, depending on the semantics of the API.
- When the request is complete, the service sends the results to the client to display in their app or browser.

# Concurrent handling of requests
The application service code exploits a server execution environment that enables multiple requests from multiple users to be processed simultaneously.

# Issues with monolith
- Monoliths tend to grow in complexity as the application becomes more feature-rich.
- hard to modify and test rapidly
- the execution footprint can become extremely heavyweight
- if request loads keep growing, latencies will increase as the service has insufficient CPU/memory capacity for the concurrent request volume.

# How to scale
- Scale-up: Scaling up the hardware.
	- costs more money for hardware
	- might grow to a level which will swamp a single server node, no matter how many CPUs and how much memory you have.
	- if code is single threaded, running it on a node with more cores is not going to improve performance
- Scale out: Run multiple copies of the service on multiple server nodes. Requests from clients are distributed across the replicas
	- Two fundamental elements for scaling out:
		- Load Balancer: Described in [LoadBalancer](../02BuildingBlocks/LoadBalancer.md).
		- Stateless service
			- The load balancer must be free to send consecutive requests from the same client to different service instances for processing.
			- This means the API implementations in the services must retain no knowledge, or state, associated with an individual client’s session.
	- As you add new service instances, the request processing capacity grows, potentially infinitely. At some stage, however, the capability of your single database to provide low-latency query responses will diminish.

# Scaling of database 

## Caching
- Scaling up by increasing the number of CPUs, memory, and disks in a database server can go a long way.
- A highly effective approach is querying the database as infrequently as possible from your services. This can be achieved by employing [distributed caching](../01Foundation/Caching.md).
## Replication and Sharding
Described in [Replication](../01Foundation/Replication.md) and [Sharding](../01Foundation/Sharding.md).