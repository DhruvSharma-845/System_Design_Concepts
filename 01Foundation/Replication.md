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

## Primary Syncing Mechanisms

## Secondary Syncing Mechanisms
Eventually consistent systems allow replica state divergence.
### Entropy
Entropy represents a degree of state divergence between the nodes. Since this property is undesired and its amount should be kept to a minimum, there are many techniques that help to deal with entropy.
### Anti Entropy
Replica divergence can be resolved using anti-entropy mechanisms. It is used to bring the nodes back up-to-date in case the primary delivery mechanism has failed. 
It lowers the convergence time bounds in eventually consistent systems.  
A background(Merkel trees) or foreground(Read Repair, Hinted Handoff) process is triggered that compares and reconciles conflicting records.

- Read Repair
	- Scope: Actively read data
	- During the read, request the data from each replica and fix(sends the updates to) the stale replicas if their responses do not match and inconsistencies are observed.
	- The same can be applied on quorum reads as well.
	- Detection of which records are stale: Specialised iterators with merge listeners.
- Digest Read
	- Instead of full read request to each replica, the coordinator sends full read request to one replica and digest request to others.
	- In case of digest request, the replica returns the hash of the data.
	- The coordinator compares this hash with the hash calculated from full read request to detect divergence.
	- In case digests do not match, the coordinator does not know which replicas are ahead, and which ones are behind. The coordinator issues full reads to any replicas that responded with different digests, compare their responses, reconcile the data, and send updates to the lagging replicas.
- Hinted Handoff
	- Scope: Actively written data
	- If a write fails on any replica, the coordinator or one of the replicas store a special record, which is replayed to the target replica as soon as it is ready.
- Merkle Trees
	- Scope: Entire dataset
	- Merkle trees compose a compact hashed representation of the local data, building a tree of hashes. 
	- The lowest level of this hash tree is built by scanning an entire table holding data records, and computing hashes of record ranges. 
	- Higher tree levels contain hashes of the lower-level hashes, building a hierarchical representation.
	- To determine whether or not there’s an inconsistency between the two replicas, we only need to compare the root-level hashes from their Merkle trees. By comparing hashes pairwise from top to bottom, it is possible to locate ranges holding differences between the nodes, and repair data records contained in them.
- Bitmap Version vectors
	- each node keeps a per-peer log of operations that have occurred locally or were replicated. 
	- During anti-entropy, logs are compared, and missing data is replicated to the target node.
### Gossip Dissemination
Use cooperative propagation to disseminate information from one process to the rest of the cluster.
- Gossip Mechanics:
	- Processes periodically select `f` peers at random (where `f` is a configurable parameter, called _fanout_) and exchange currently “hot” information with them.
- Overlay networks:
	- construct a _temporary_ fixed topology in a gossip system. This can be achieved by creating an overlay network of peers.
	- Nodes can sample their peers and select the best contact points based on proximity.
	- Fixed topology at the time of stable system and epidemic like gossip for failover.
- Hybrid Gossip
	- Reduce the number of exchanged messages
	- Push/lazy-push multicast trees: create a spanning tree overlay of nodes to _actively_ distribute messages with the smallest overhead.
	- Each node sends the full message to the small subset of nodes, and for the rest of the nodes, it _lazily_ forwards only the message ID. 
	- If the node receives the identifier of a message it has never seen, it can query its peers to get it.

# Types of replicas
## Witness Replica
 Witness replicas merely store the record indicating the fact that the write operation occurred. They are useful in [Quorum Consistency Model](./Consistency.md#Quorum).
 In cases of write timeouts or copy replica failures, witness replicas can be _upgraded_ to temporarily store the record in place of failed or timed-out copy replicas.
