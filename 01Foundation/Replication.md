---
type: concept
domain: database, distributed system
summary: Introducing redundancy by maintaining multiple copies of data.
---

# What it is
It is a model to store multiple copies of data so that when one machine fails, the other ones can serve as failover.

# Why it is needed
- To ensure availability: Gracefully handling failures

# Where it is needed
- Multi datacenter deployments  
  - Serves two purposes: Reduced latency due to physically closer to client and Fault Tolerance due to redundancy

# How to perform replication
**Keeping several copies of data in sync**: When the data is updated, it should be updated on all replicas synchronously or asynchronously.

# Types of replicas
## Witness Replica
 Witness replicas merely store the record indicating the fact that the write operation occurred. They are useful in [Quorun Consistency Model](./Consistency.md#Quorum).
 In cases of write timeouts or copy replica failures, witness replicas can be _upgraded_ to temporarily store the record in place of failed or timed-out copy replicas.
