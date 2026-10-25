# Architecture Review Checklist

Check each dimension against the notes listed. Skip dimensions that don't apply, but say that you skipped them.

| # | Dimension | Questions | Notes |
|---|---|---|---|
| 1 | Requirements fit | Does every component trace back to a requirement? Is anything missing or over-engineered? | — |
| 2 | Scalability | Can it scale out? Are services stateless? Where is the first bottleneck? | `01Foundation/Scalability.md`, `02BuildingBlocks/LoadBalancer.md`, `04Architectures/MonolithArchitecture.md` |
| 3 | Data partitioning | Is the shard key sound? What about hot keys or skew, rebalancing, and secondary indexes? | `01Foundation/Sharding.md` |
| 4 | Replication & availability | Which replication mode? What failover plan? What about replication lag and split brain? | `01Foundation/Replication.md`, `01Foundation/Consensus.md` |
| 5 | Consistency | Is the guarantee each operation needs stated? Read-your-writes? Is the CAP behavior during partitions clear? | `01Foundation/Consistency.md` |
| 6 | Transactions & correctness | Are multi-entity or cross-service updates atomic? What isolation level? Are operations idempotent and exactly-once? | `01Foundation/Transactions.md`, `03Patterns/WorkflowEngines.md` |
| 7 | Caching | What strategy? How is invalidation handled? Is staleness acceptable? What happens on cache failure or stampede? | `01Foundation/Caching.md` |
| 8 | Storage choice | Does the data model fit the access patterns? What engine (OLTP vs analytics)? | `01Foundation/DataModels.md`, `01Foundation/StorageEngines.md` |
| 9 | Communication | Sync vs async? Are API and schema changes backward and forward compatible? Are timeouts and retries set? | `01Foundation/NetworkCommunication.md`, `02BuildingBlocks/StreamProcessing.md` |
| 10 | Async & events | Queue vs log broker? Ordering, replay, CDC, event sourcing? | `02BuildingBlocks/StreamProcessing.md`, `03Patterns/EventSourcingAndCQRS.md`, `04Architectures/EventDrivenArchitecture.md` |
| 11 | Fault tolerance | Single points of failure? Failure detection, clock assumptions, partial failures? | `01Foundation/FaultTolerance.md` |
| 12 | IDs | Are IDs unique across nodes? Are ordering requirements met? | `02BuildingBlocks/IDGenerator.md` |
| 13 | Security | Authn/authz flow, token handling, TLS/mTLS, service-to-service auth | `01Foundation/Security.md`, `02BuildingBlocks/Authentication&Authorization.md`, `04Architectures/SecurityArchitectures.md` |
| 14 | Tenancy | Tenant isolation for data, compute, and noisy neighbors | `04Architectures/Tenancy.md` |
| 15 | Service boundaries | Are microservices justified? Are boundaries cohesive? Any chatty calls? | `04Architectures/Microservices.md` |
| 16 | Operability | Observability, deployment and rollback, cost | (general knowledge) |

All note paths are relative to `references/`.
