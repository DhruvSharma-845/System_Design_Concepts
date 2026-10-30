---
title: "Stateless Service"
type: pattern
domain: [distributed-systems]
tags: [stateless-services, stateful-services, session-state, self-contained-requests, scale-out]
summary: "Stateful versus stateless services: session-state benefits and costs, and self-contained requests without retained client session state."
use_when:
  - "Choosing whether a service should retain client session state"
  - "Scaling service replicas behind a load balancer"
related:
  - "01Foundation/Scalability.md"
  - "02BuildingBlocks/LoadBalancer.md"
  - "04Architectures/MonolithArchitecture.md"
  - "04Architectures/Microservices.md"
status: partial
---

# Stateful Service
Conversation state represents any information that is retained between requests such that the request can assume that the service has retained knowledge about previous interactions.  
  
This can be implemented using session object that uniquely represents client connection.

## Advantages
- Simplifies the request signature
- Reduces the data to be fetched from database.

## Disadvantages
- Session state consumes service memory
- If the connection is not closed properly, the session object will keep on consuming memory. A timeout has to be added.



# Stateless Service

API implementations in the services must retain no knowledge, or state, associated with an individual client’s session.  
Each request is handled independently, without any knowledge of the requests that were executed before it.  
Each request must be self-contained, providing all the necessary information that the service requires.