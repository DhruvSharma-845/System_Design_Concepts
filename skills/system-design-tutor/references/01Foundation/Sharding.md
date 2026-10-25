---
title: "Sharding"
type: concept
domain: [databases, distributed-systems]
tags: [partitioning, rebalancing, hot-spots, request-routing, secondary-indexes, multitenancy]
summary: "Partitioning data across nodes: sharding strategies, rebalancing, skew, request routing, and secondary indexes."
use_when:
  - "Data or write throughput exceeds a single node"
  - "Isolating tenants at the data layer"
related:
  - "01Foundation/Replication.md"
  - "04Architectures/Tenancy.md"
  - "01Foundation/Scalability.md"
status: solid
---

# What it is
It is a logical division of data into smaller manageable segments(partitions). Each segment is a database of its own.  
Sharding is usually combined with replication, so that copies of each shard are stored on multiple nodes. Each shard’s leader is assigned to one node, and its followers are assigned to other nodes.

# Why it is needed
- Volume of the data that a single node cannot store
- High write throughput that a single machine cannot handle

# Sharding for multitenancy
- Either each tenant is given a separate shard, or multiple small tenants may be grouped together into a larger shard
- Provides resource isolation, schema migrations can be rolled out gradually, one tenant at a time. 

# Types of sharding
 You typically have to decide which records to put in which shard by choosing a _partition key_; all records with the same partition key are placed in the same shard.  
 The goal with sharding is to spread the data and the query load evenly across nodes.  
 
- Range partitioning
	- splitting the data into ranges and assign ranges to shards. Each shard will handle a range.
	- clients have to route requests based on the _routing key_ to the correct shard.
	- The ranges of keys are not necessarily evenly spaced, because your data may not be evenly distributed.
	- Within each shard, keys are stored in sorted order
- Sharding by hash key
	- hash the partition key before mapping it to a shard
	- A good hash function takes skewed data and makes it uniformly distributed.
	- To choose the shard, take the hash value _modulo_ the number of nodes in the system.
	- Issue: if the number of nodes N changes, most of the keys have to be moved from one node to another(Repartitioning is expensive)
- Sharding by hash range
	- combine key-range sharding with a hash function so that each shard contains a range of _hash values_ rather than a range of _keys_.
	- range queries are not efficient.
- Consistent Hashing
	- In order to reduce the movement of data on addition/deletion of nodes, consistent hashing can be utilized.
	- **Algorithm**
		- Routing keys are hashed. Values returned by the hash function are mapped to a _ring_, so that after the largest possible value, it wraps around to its smallest value. 
		- Each node gets its own position on the ring and becomes responsible for the _range_ of values, between its predecessor’s and its own positions.
	- A change in the ring affects only the _immediate neighbors_ of the leaving or joining node, and not an entire cluster.

# Repartitioning(Rebalancing)
When nodes are added to or removed from the cluster, the database has to re-partition the data to maintain the balanced load( to ensure the processing and storage capacity of each node is equally utilized). 
Automated vs manual rebalancing
Key-range sharding:  
- Shards are typically rebalanced by splitting the range into two subranges when a shard gets too big.
Hash-based sharding:
- Create more logical shards than there are physical nodes. Assign more than one logical shard to each physical node.
- if a node is added to the cluster, the system can reassign some of the shards from existing nodes to the new node until they are fairly distributed

# Skewed Workload
- A system that defines shards based on ranges of keys (or ranges of hashes) makes it possible to put an individual hot key in a shard by itself, perhaps even assigning it a dedicated machine
- if one key is known to be very hot, a simple technique is to add a random number to the beginning or end of the key. Adding just two random digits would split the writes to the key evenly across 100 keys.

# Request Routing
With sharded databases, a request for a key can be handled only by a node that is a owner for the shard containing that key. Request routing has to be aware of the assignment from keys to shards and from shards to nodes.
**Approaches**
- Allow clients to contact any node (e.g., via a round-robin load balancer). If that node coincidentally owns the shard to which the request applies, the node can handle the request directly; otherwise, it forwards the request to the appropriate node, receives the reply, and passes the reply along to the client.
- Send all requests from clients to a routing tier first, which determines the node that should handle each request and forwards it accordingly.
- Require that clients be aware of the sharding and the assignment of shards to nodes. In this case, a client can connect directly to the appropriate node

**Who keeps track of shard assignments**
A single coordinator(like Zookeeper):  Each node registers itself in ZooKeeper, and ZooKeeper maintains the authoritative mapping of shards to nodes.
 Whenever a shard changes ownership, or a node is added or removed, ZooKeeper notifies the routing tier so that it can keep its routing information up-to-date.

# Sharding and secondary indexes
 We can use the partition key to determine the shard and thus route reads and writes to the node that is responsible for that key.
 The problem with secondary indexes is that they don’t map neatly to shards, unlike primary keys(partition keys).
 - Local secondary index: each shard independently maintains its own secondary indexes, covering only the records in that shard.
	 -  if you want all the results, you will need to send the query to all shards and combine the results you get back.
- Global secondary index: A global index covers data in all shards. It must also be sharded.
	- writes are more complicated than with local indexes, because writing a single record might affect multiple shards of the index

