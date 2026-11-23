---
title: "Microservices"
type: architecture
domain: [distributed-systems]
tags: [services, service-boundaries, loose-coupling, independent-deployment, independent-scaling, api, load-balancing, caching, resilience]
summary: "Decomposing a system into loosely coupled, independently deployed services, with independent scaling and resilience."
use_when:
  - "Large systems with independent teams or deployment needs"
  - "Scaling services independently based on demand"
  - "Managing failures and resilience across service boundaries"
related:
  - "01Foundation/NetworkCommunication.md"
  - "01Foundation/Scalability.md"
  - "02BuildingBlocks/LoadBalancer.md"
  - "02BuildingBlocks/APIGateway.md"
  - "02BuildingBlocks/ServiceDiscovery.md"
  - "01Foundation/Caching.md"
  - "04Architectures/MonolithArchitecture.md"
  - "04Architectures/EventDrivenArchitecture.md"
  - "04Architectures/SecurityArchitectures.md"
status: partial
---

# What it is
It consists of fine-grained, cohesive and loosely coupled services that are independently deployed processes and communicate using remote communications mechanisms such as HTTP API.

It solves the problem of increasing development and application complexity.

## Characteristics
- It uses service as a fundamental unit of modularity
- A microservice is scoped around a business capability.
- Each service can follow hexagonal architecture for itself.
- Each service has its own datastore whose schema is not exposed outside service
- Small agile teams can iterate and evolve features quickly.
- Each microservice is self-contained, encapsulating its own data storage and offers APIs for system operations, leading to loose coupling
    - Database schema can change without coordinating with the consumers of the service.
- Lesser code complexity due to narrower scope of service.
- Individual services can be independently scaled out

# Principles
- Modeled around a business domain
- Monitoring of each service is essential to ensure they are behaving as expected
- Hide implementation details: Microservices are black boxes. Their API is a contract which they are guaranteed to support
- The failure of one microservice should not propagate to others and bring down the application.
- Every microservice should be independently deployable
- Culture of automation

# How it works
A service can call one or more dependent services, which in turn are replicated and load-balanced and employs caching to provide high performance and availability.

# Advantages
- By breaking the application into multiple independent services, you can scale each based on the service demand
- can be separately built, tested, deployed.
- Enables continuous delivery
- better fault isolation

# Drawbacks
- Finding right size of services is challenging 
- Deploying features that span multiple services require coordination
- Observability is complex because a request can bound around multiple services


# How to model service
Each service should be modeled around business concern. 

## Important factors to be considered
- Communication cost
	- A particular decomposition would be impractical due to too many round-trips between services.
	- Synchronous communication between services reduces availability.
- Maintain data consistency across services.
- Monitoring complexity

## Identify Services
Functional decomposition needs to be done identify microservices from a monolith application.  

### Domain-driven design
It maps each microservice to the bounded context. It organize services around domain-driven design subdomains.


# Microservices Deployment

- Continuous Deployment
- Hiding the different microservices from client using [API Gateway](../02BuildingBlocks/APIGateway.md)

# Resilience
To ensure your systems don’t fail suddenly as loads increase, there are a number of necessary precautions that must be taken.
- Cascading failure
	- If a downstream service has slow response time, the caller service gets impacted too.
	- Immediate retries simply maintain the load on the overwhelmed microservice.
	- Retry with exponential backoff.
	- Fail-fast: 
		- When a request takes longer than some predefined time limit, instead of waiting for it to complete, the client returns an error to its caller.
		- If the request load exceeds some threshold, immediately fail the request with an HTTP 503 error.
		- Some default response can be sent that masks the fact that the request was not correctly processed.
	- Circuit Breaker
		- Rather than failing fast, which still incurs a timeout delay, it is better to back off immediately from sending further requests and allow some time for the error situation to resolve.
		- The circuit breaker is configured to monitor some condition, such as error response rates from an endpoint, or the number of requests sent per second. 
		- If the configured threshold is reached—for example, 25% of requests are throwing errors—the circuit breaker is triggered. This moves the circuit breaker into an `OPEN` state, in which all calls return with an error immediately, and no attempt is made to call the unstable or unavailable endpoint
		- The circuit breaker then rejects all calls until some suitably configured timeout period expires. At that stage, the circuit breaker moves to the `HALF_OPEN` state. Now, the circuit breaker allows client calls to be issued to the protected endpoint. If the requests still fail, the timeout period is reset and the circuit breaker stays open. However, if the request succeeds, the circuit breaker transitions to the `CLOSED` state and requests start to flow to the target endpoint.
		- Requests can often return default or cached results when the circuit breaker is open.
	- Bulk-head pattern
		- Avoid starvation of requests for threads on the service
		-  It can be used to ensure requests to one API in a microservice don’t utilize all available resources during a request burst.
		- we could specify that the new order request has a maximum of 150 threads of the shared thread pool available for its exclusive use. This ensures that when a new order request burst occurs, we can still handle status requests with acceptable response times because there is additional capacity in the thread pool.








