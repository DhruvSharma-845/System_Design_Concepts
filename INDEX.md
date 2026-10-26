# Index

Flat map of every note. Read this first, then open only the notes relevant to the task (see [AGENTS.md](AGENTS.md)).

Status: `solid` = covers the main topic well, `partial` = has gaps, `stub` = empty or placeholder.

## Foundation (concepts)

| Note | Summary | Use when | Status |
|---|---|---|---|
| [Caching](01Foundation/Caching.md) | Reducing database load and latency with database caching and distributed key-value caches (cache-aside, invalidation). | Read-heavy workloads or hot keys; Reducing latency or database load | partial |
| [Consensus](01Foundation/Consensus.md) | How multiple nodes agree on a value: FLP limitations, practical timeout assumptions, shared logs, atomic broadcast, leader election, locks and leases. | Leader election or failover without split brain; Distributed locks, leases, or uniqueness constraints; Building a linearizable or replicated log | solid |
| [Consistency](01Foundation/Consistency.md) | Consistency models (linearizable, sequential, causal, session, eventual), CAP, and tunable quorum consistency. | Choosing consistency guarantees for replicated data; Reasoning about CAP trade-offs; Read-your-writes or monotonic-read requirements | solid |
| [Data Models](01Foundation/DataModels.md) | Relational, document, and graph data models, their relationships, query languages, and GraphQL. | Choosing a database type for a domain; Designing schemas and relationships | solid |
| [Fault Tolerance](01Foundation/FaultTolerance.md) | Faults in distributed systems (unreliable networks and clocks, pauses), failure detection, and safe retries using idempotency keys. | Designing for high availability and reliability; Handling timeouts, failure detection, or clock skew; Retrying state-changing requests without duplicating their effects | solid |
| [Network Communication](01Foundation/NetworkCommunication.md) | Data encoding and schema evolution, REST and RPC/RMI, and network layers including TCP, UDP, sockets, IP, and DNS. | Designing service APIs; Choosing serialization formats; Planning backward and forward compatible schema changes; Choosing transport protocols or understanding service name resolution | partial |
| [Replication](01Foundation/Replication.md) | Keeping copies of data on multiple nodes: single-leader, multi-leader, and leaderless replication, plus conflict resolution. | High availability or failover; Read scaling or geo-distributed low latency; Multi-region or offline-first data | solid |
| [Scalability](01Foundation/Scalability.md) | How systems accommodate growth by adding resources: scaling up or out, replication, optimization, and caching. | Planning for growth in traffic or data; Choosing between vertical and horizontal scaling | partial |
| [Security](01Foundation/Security.md) | Cryptographic foundations: public-key crypto, signatures, TLS and mTLS, certificates, and JWT security tokens. | Securing transport between clients and services; Choosing token formats such as JWT | partial |
| [Sharding](01Foundation/Sharding.md) | Partitioning data across nodes: sharding strategies, rebalancing, skew, request routing, and secondary indexes. | Data or write throughput exceeds a single node; Isolating tenants at the data layer | solid |
| [Storage Engines](01Foundation/StorageEngines.md) | How databases persist data on disk: B-trees, log-structured storage and SSTables, indexes, and columnar formats. | Choosing a database for read-heavy vs write-heavy workloads; OLTP vs analytics storage decisions | solid |
| [Transactions](01Foundation/Transactions.md) | ACID transactions on single nodes and distributed systems: isolation levels, concurrency control, 2PC/3PC, exactly-once, and idempotent message processing. | Correctness under concurrent writes; Atomic updates across shards or services; Choosing isolation levels | solid |

## Building Blocks

| Note | Summary | Use when | Status |
|---|---|---|---|
| [Authentication & Authorization](02BuildingBlocks/Authentication%26Authorization.md) | Authentication (IdP, OIDC, SSO, SAML) and authorization (RBAC, OAuth 2.0 grants, tokens) for clients and services. | User login or SSO; API or service-to-service authorization; Choosing an OAuth 2.0 grant type | solid |
| [Batch Processing](02BuildingBlocks/BatchProcessing.md) | Offline processing of bounded, immutable input into derived data, as in MapReduce or Spark, and workflow scheduling. | Periodic large-scale data processing; Building derived datasets, ETL, or analytics | partial |
| [DNS](02BuildingBlocks/DNS.md) | Resolving domain names to IP addresses through a distributed hierarchy of local, root, top-level domain, and authoritative DNS servers. | Resolving service domain names to IP addresses; Understanding hierarchical DNS lookups | partial |
| [ID Generator](02BuildingBlocks/IDGenerator.md) | Generating unique, optionally ordered IDs in single-node and distributed systems, such as UUIDs and timestamp-based IDs. | Unique IDs across shards or regions; Time-ordered IDs such as URL shorteners or feeds | partial |
| [Load Balancer](02BuildingBlocks/LoadBalancer.md) | Distributing client requests across service replicas to keep each equally busy, and relaying responses back. | Scaling out a service to multiple replicas; Removing a single server as a bottleneck or point of failure | stub |
| [Stream Processing](02BuildingBlocks/StreamProcessing.md) | Continuous processing of unbounded event streams: message brokers (queue and log based), stream joins, and fault tolerance. | Real-time or near-real-time processing; Async communication between services; Choosing a queue vs a log-based broker | solid |

## Patterns

| Note | Summary | Use when | Status |
|---|---|---|---|
| [Event Sourcing and CQRS](03Patterns/EventSourcingAndCQRS.md) | Using an immutable event log as the source of truth, separate read models (CQRS), and change data capture. | Audit trails or replayable state; Read and write workloads that need different models; Syncing derived systems from a database | partial |
| [Identity and Access Management](03Patterns/IdentityAndAccessManagement.md) | IAM as a gatekeeper: combining authentication, authorization, and user management for applications and APIs. | Designing identity for a product or platform; Centralizing access control | partial |
| [Workflow Engines](03Patterns/WorkflowEngines.md) | Executing graphs of tasks with an orchestrator and executors: scheduling, retries, parallelism, and exactly-once. | Multi-step or long-running business processes; Orchestrating batch jobs or sagas | partial |

## Architectures

| Note | Summary | Use when | Status |
|---|---|---|---|
| [Event-Driven Architecture](04Architectures/EventDrivenArchitecture.md) | Architectures built on asynchronous events and messages, including the actor model. | Loosely coupled services reacting to events; Highly concurrent, distributed message processing | partial |
| [Microservices](04Architectures/Microservices.md) | Decomposing a system into cohesive, independently deployed services that communicate remotely (e.g., HTTP). | Large systems with independent teams or deployment needs | partial |
| [Monolith Architecture](04Architectures/MonolithArchitecture.md) | Three-tier monolith (client, application service, database): request flow, limitations, and how to scale it. | Early-stage or simple systems; Deciding when a monolith needs scaling or decomposition into microservices | partial |
| [Security Architectures](04Architectures/SecurityArchitectures.md) | Recommended auth flows per architecture: first-party apps, managed IdP, BFF, microservices, and third-party API access. | Choosing an auth flow for a given client type; Securing service-to-service calls | partial |
| [Tenancy](04Architectures/Tenancy.md) | Multitenant architecture: isolating each customer's data and users, including shard-per-tenant strategies. | Designing SaaS products serving many customers; Tenant data isolation requirements | partial |
