---
type: concept
domain: database, distributed system
summary: logical division of data into smaller manageable segments on multiple nodes
---
# What it is
It is a logical division of data into smaller manageable segments.

# Types of sharding
- Range partitioning
	- splitting the data into ranges and allowing _replica sets_ to manage only specific ranges
	- clients (or query coordinators) have to route requests based on the _routing key_ to the correct replica set

# Repartitioning
When nodes are added to or removed from the cluster, the database has to re-partition the data to maintain the balance. 
## Consistent Hashing
In order to reduce the movement of data on addition/deletion of nodes, consistent hashing can be utilized.
**Algorithm**
-  Routing keys are hashed. Values returned by the hash function are mapped to a _ring_, so that after the largest possible value, it wraps around to its smallest value. 
- Each node gets its own position on the ring and becomes responsible for the _range_ of values, between its predecessor’s and its own positions.
A change in the ring affects only the _immediate neighbors_ of the leaving or joining node, and not an entire cluster.