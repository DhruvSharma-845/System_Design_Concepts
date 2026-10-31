---
title: "Monolith Architecture"
type: architecture
domain: [distributed-systems]
tags: [monolith, three-tier, application-server, tomcat, servlets, thread-pools, connection-pooling, stateless-services, scale-up, scale-out, caching]
summary: "Three-tier monolith: request flow, application servers (Tomcat, servlets, threads, and database connection pools), limitations, and scaling."
use_when:
  - "Early-stage or simple systems"
  - "Understanding application-server request handling and database connection pooling"
  - "Deciding when a monolith needs scaling or decomposition into microservices"
related:
  - "02BuildingBlocks/LoadBalancer.md"
  - "01Foundation/ParallelismAndConcurrency.md"
  - "03Patterns/StatelessService.md"
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

# Application Server
It accept requests from clients, apply application logic to the requests, and reply to the client with the request results.  

## Tomcat as an example
Tomcat implements a _servlet container_, which is an execution environment for application-defined servlets.   
Servlets are dynamically loaded into this container, which provides life cycle management and a multithreaded runtime environment.  
- Incoming requests are processed by one or more listener threads. These create a TCP/IP socket connection between the client and server.
- Once a connection is established, the TCP requests are marshalled by an _HTTP Connector_ which generates the HTTP request (`HttpServletRequest` object).
- The HTTP request is then dispatched to an application container thread to process. If there are no available threads to handle a request, the container maintains them in a queue of runnable tasks and dispatches these as soon as a thread becomes available.
- For each request, the method that corresponds with the HTTP request is invoked in a thread. The servlet method processes the HTTP request headers, executes the business logic, and constructs a response that is marshalled by the container back into a TCP/IP packet and sent over the network to the client.  
## Database Connection pool
In many databases, especially relational ones, connections are limited resources as they consume memory and system resources in both the client and database server. For this reason, a fixed-size database connection pool is typically utilized.  
When a servlet wishes to submit a query to the database, it requests a connection from the pool. If one is available, access to the connection is granted to the servlet until it indicates it has completed its work. At that stage the connection is returned to the pool and made available for another servlet to utilize.  
## Concurrent handling of requests
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
	- Two fundamental elements for horizontal scaling:
		- It is a technique of deploying multiple instances of [stateless](../03Patterns/StatelessService.md) server resources and using a [Load Balancer](../02BuildingBlocks/LoadBalancer.md) to distribute the requests across these instances.
		- Load Balancer: Described in [LoadBalancer](../02BuildingBlocks/LoadBalancer.md).
		- Stateless service
			- The load balancer must be free to send consecutive requests from the same client to different service instances for processing.
			- This means the API implementations in the services must retain no knowledge, or state, associated with an individual client’s session.
	- As you add new service instances, the request processing capacity grows, potentially infinitely. At some stage, however, the capability of your single database to provide low-latency query responses will diminish.

# Scaling of database 

## Caching
- Scaling up by increasing the number of CPUs, memory, and disks in a database server can go a long way.
- A highly effective approach is querying the database as infrequently as possible from your services. This can be achieved by employing [distributed caching](../01Foundation/Caching.md).
- By not having to reconstruct the cached results for every request, the capacity of the system is increased, and it can scale to handle greater workloads.
## Replication and Sharding
Described in [Replication](../01Foundation/Replication.md) and [Sharding](../01Foundation/Sharding.md).