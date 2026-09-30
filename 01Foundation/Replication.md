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
