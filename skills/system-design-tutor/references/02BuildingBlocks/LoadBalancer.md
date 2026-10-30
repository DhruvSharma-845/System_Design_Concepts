---
title: "Load Balancer"
type: building_block
domain: [distributed-systems, networking]
tags: [load-balancing, scale-out, replicas, stateless-services, health-checks, layer-4, layer-7, routing, session-affinity]
summary: "Distributing requests across service replicas: health checks, network- and application-level routing, load distribution policies, and session affinity."
use_when:
  - "Scaling out a service to multiple replicas"
  - "Removing a single server as a bottleneck or point of failure"
  - "Choosing routing policies or evaluating sticky-session trade-offs"
related:
  - "01Foundation/Scalability.md"
  - "01Foundation/NetworkCommunication.md"
  - "03Patterns/StatelessService.md"
  - "04Architectures/MonolithArchitecture.md"
  - "04Architectures/Microservices.md"
status: partial
---

# What it is
To keep each resource equally busy, a load balancer distributes the client requests among the service replicas. It also relays the responses from the service back to the client.  
It aims to effectively utilize the capacity of a collection of services to optimize the response time for each request

# When it is needed

# How it does
- Clients send requests to the IP address of the load balancer, which redirects requests to target services, and relays the results back to the client.
- Health Checks: A load balancer will periodically send pings and attempt connections to test the health of each service in the load balancing pool. These tests are called health checks

# Types of Load Balancer
- Type 4: works at network level
	- Network-level load balancers distribute requests at the network connection level, operating on individual TCP or UDP packets. 
	- Routing decisions are made on the basis of client IP addresses. 
	- Once a target service is chosen, the load balancer uses a technique called network address translation (NAT). This changes the destination IP address in the client request packet from that of the load balancer to that of the chosen target. 
	- When a response is received from the target, the load balancer changes the source address recorded in the packet header from the target’s IP address to its own.
- Type 7: works at application level
	-  application-level load balancers reassemble the complete HTTP request and base their routing decisions on the values of the HTTP headers and on the actual contents of the message
# Load Distribution
It dictates how the load balancer chooses a target service to process a request
- Round robin: The load balancer distributes requests to available servers in a round-robin fashion.
- Least connections: The load balancer distributes new requests to the server with the least open connections.
- HTTP header field: The load balancer directs requests based on the contents of a specific HTTP header field. For example, all requests with the header field `X-Client-Location:US,Seattle`could be routed to a specific set of servers.
- HTTP operation: The load balancer directs requests based on the HTTP verb in the request.

# Session affinity
With sticky sessions, the load balancer sends all requests from the same client to the same service instance. This enables the service to maintain in-memory state about each specific client session.

**AWS Elastic Load Balancing (ELB)** generates an HTTP cookie that identifies the service replica a client’s session is associated with. This cookie is returned to the client, which must send it in subsequent requests to ensure session affinity is maintained.

## Issues
- They lead to a load imbalance problem, in which, over time, clients are not evenly distributed across services. To help alleviate load imbalance, load balancers usually provide policies such as sending new sessions to instances with the least connections or fastest response times. 
- When a service inevitably fails, how do the clients connected to that server recover the state that was being managed?