---
type: building_block
domain: distributed system
summary:
---
# What it is
In single-node databases, it is common to use an autoincrementing integer as unique ID, which has the advantage that it can be stored in only 64 bit.
**How to implement**: Use the atomic increment instruction provided by your CPU, which allows multiple threads to safely increment the same counter

# Single-node ID generator
**Issues** :
- A single-node ID generator is not fault-tolerant because that node is a single point of failure.
- High latency if the ID generator is in another region.
- Can become a bottleneck

# Multi-node ID generator
- Sharded ID assignment
	- You could have multiple nodes that assign IDs—for example, one that generates only even numbers and one that generates only odd numbers. 
	- Ordering is lost.
- Preallocated blocks of IDs
	- each node can independently hand out IDs from its block range
	- Ordering is lost.
- Random UUIDs
	- You can use _universally unique identifiers_ (UUIDs), also known as _globally unique identifiers_ (GUIDs).
	- Ordering is lost
- Timestamp + Uniqueness
	- you can generate IDs by putting a timestamp from this clock in the most significant bits and filling the remaining bits with extra information that ensures the ID is unique even if the timestamp is not: for example, a shard number and a per-shard incrementing sequence number, or a long random value.
- Logical Clock can help in generating IDs that are unique and correctly ordered
	- [Conflict Resolution](../01Foundation/Replication.md)
	- linearizability requires that if request A completed before request B began, then B must have the higher ID, even if A and B never communicated with each other. 
	- On the other hand, Lamport clocks can ensure only that a node generates timestamps that are greater than any other timestamp that node has seen; no such guarantees can be made about timestamps that it hasn’t seen.