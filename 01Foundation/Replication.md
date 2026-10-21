---
type: concept
domain: database, distributed system
summary: Introducing redundancy by maintaining multiple copies of data.
---

# What it is
It is a model to store multiple copies of data on more than one machines so that when one machine fails, the other ones can serve as failover.  
**Note**: If the data fits on single machine, replication is enough. Otherwise, [Sharding](./Sharding.md) must be employed

# Why it is needed
- To ensure availability: Gracefully handling failures when one machine fails
- Low latency: To keep the data geographically close to users
- Increased throughput: To handle the increased rate of queries

# Where it is needed
- Multi datacenter deployments  
  - Serves two purposes: Reduced latency due to physically closer to client and Fault Tolerance due to redundancy

# How to perform replication
**Keeping several copies of data in sync**: When the data in one of the copies is updated, it should be updated on all replicas synchronously or asynchronously.

## Single leader
- One of the replicas is leader.
- All the write requests go to the leader that writes the data to its local storage.
- The other replicas are followers. The leader sends the change stream to followers. Each follower updates its local copy by applying the change stream.
- Reading can be done from any replica.

### Synchronous vs Asynchronous Replication

- Synchronous
  - The leader waits until all other replicas confirm that they have received the writes
  - All other replicas are guaranteed to be up-to-date, so in case of failure, any follower can become leader.
  - If follower fails to respond to write request, the leader cannot continue.

- Asynchronous 
  - The leader just informs the followers and does not wait for any reponse from followers.
  - The writes that are not replicated to followers, will be lost in case of leader failure.

In practice, majority of followers can be synchronous and the rest can be Asynchronous.

### Setting up new followers
- How to make the new follower in-sync with leader?
  - Take a snapshot of database(Snapshots can be stored on object storage)
  - Copy the snapshot to new follower
  - The follower requests the remaining changes(since the snapshot) 

### Handling Follower failure
Each failure keeps a log of local changes.
In case of failure, it can recover from its logs. And then, it can requests the remaining changes(since its failure) from the leader.

### Leader failure: Failover
- Determing the leader has failed
  - Failure detection mechanisms are discussed in [Failure Detection](./FaultTolerance.md)
- One of the follower must become leader
  - The leader election algorithm is discussed in [Consensus Applications](./Consensus.md).
  - The new leader might not have all the data if the replication is asynchronous
  - Split brain: It can happen that the two nodes would assume leadership. Fencing is a technique where one of the leader would be shut down.
- The clients have to be configured to send writes to new leader.
- The other followers need to start consuming data changes from new leader

### Replication logs
- Statement-based
  - Leader logs every write request as SQL statement and sends statements to followers 
  - Can create issues in case of non-deterministic statements(now)
- Write-ahead log shipping
  - The logs(kept for durability on local node-WAL) can be sent to followers
  - Contains low level details so tightly coupled to storage engine.
- Logical(row-based)
  - A separate log that contains row-level change details

### Replication Lag
A client might see outdated information from a follower that has fallen behind.
The problems that can occur due to replication lag are mentioned in [Consistency](./Consistency.md).

### Multi-region setup
Each write would go to the region containing the leader, thus, increasing latency.  
In case the region containing the leader goes down, follower of some other region can be promoted to become leader.

## Multi-leader
In Single leader replication, the leader becomes single point of failure.  
More than one nodes can become leader. The write on one leader must be propagated to all other nodes.

### Synchronous vs Asynchronous Replication
Synchronous replication is similar to synchronous single-leader replication.  
Asynchronous multi-leader replication is more often used in multi-region setup(geo-distributed setup). Each region will have a leader. Within each region, regular leader-follower replication is used. Between regions, each region's leader would replicate its changes to the leaders of other region.  
The multi-leader setup provides weaker consistency guarantees than single-leader because leaders can accept conflicting writes.

### Replication Topologies
- All to all
- Circular
  - Each node is given an identifier
  - The replication log contains the identifiers of all nodes that it has passed through.
- Star

### Sync engines and local first software
An example of offline-first would be a client app continue to work even when the internet is disconnected. Here, the different client apps acts as a leader and there is a multi-leader replication happening between different clients and server.  
Real-time collaboration: The client perform the local changes and then, share the changes with other clients and servers. The other clients merges these changes with their local copy.  
If multiple users have updated the same data concurrently, conflict resolution mechanisms have to be employed.  
**Local first application** is a combination of offline-first and real-time collaborative. A sync engine in the client app with reactive programming to act on the update notifications from other clients, is a good way to implement it.

### Conflict Resolution
Please refer to its section below.

## Leaderless

Allowing any replica to directly accept writes from clients. 
Clients either directly sends its writes to several replicas, or a coordinator node does this on behalf of the client. Read requests are also sent to several nodes in parallel. For the client to determine which responses are up-to-date and which are outdated, every value that is written needs to be tagged with a version number or timestamp.

### How outdated data can be updated

#### Entropy
Entropy represents a degree of state divergence between the nodes. Since this property is undesired and its amount should be kept to a minimum, there are many techniques that help to deal with entropy.
#### Anti Entropy
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

### Quorum Read and Write
If there are _n_ replicas, every write must be confirmed by _w_ nodes to be considered successful, and we must query at least _r_ nodes for each read. As long as _w_ + _r_ > _n_, we expect to get an up-to-date value when reading

### Multi-region leaderless replication
A client that wants to perform a multi-region write first chooses a node in its local region, called the _coordinator node_, and sends its write to that node. The coordinator node forwards the write to all replicas in its own region and to one replica in every other region, which then forwards it to the other replicas in that region.

## Conflict Resolution
Concurrent writes to multiple leaders can lead to conflicts that must be resolved. 

 If nodes simply overwrote the value for a key whenever it received a write request from a client, the nodes would become permanently inconsistent.
 To become eventually consistent, the replicas should converge toward the same value.
### Detection
An operation A _happens before_ another operation B if B knows about A, or depends on A, or builds upon A in some way.
Two operations are concurrent if neither happens before the other.
we need an algorithm to tell us whether two operations are concurrent. If the operations are concurrent, we have a conflict that needs to be resolved.
For defining concurrency, exact time doesn’t matter. We simply call two operations concurrent if they are both unaware of each other, regardless of the physical time at which they occurred.

**Logical Clock**:
- Helps in determining the order of events or tell whether they are concurrent.
- Consistent with causality: if operation A happened before operation B, then A’s timestamp is less than B’s timestamp
- Lamport Clock
	- They provide total ordering but not linearizable.
	- When multiple timestamps are generated concurrently, these algorithms order them ***arbitrarily***. This means that when you look at two timestamps, you generally can’t tell whether they were generated concurrently or one happened before the other
- Vector Clock
	- If you want to be able to determine when records were created concurrently, you need a different algorithm, such as a _vector clock_.


### Resolution
- Avoidance:
  - All writes for a record go to the same leader
  - Approach breaks down if we allow the leader to be changed.
- Last write wins
  - Attach a timestamp to each write and always use the write with most recent timestamp.
  - Depends on clock synchronisation 
- Manual Conflict Resolution
  - Store all the concurrent writes for a record
  - On next request, return all the values and let user resolve them.
- Automatic Conflict Resolution
  - Use an algorithm that automatically merges the concurrent writes
  - It leads to **Strong Eventual Consistency**
- Conflict-free replicated datatypes(CRDT)
  - It plays with unique ids for the operations.
- Operational Transformation
  - It uses the index where the insertion/deletion/update is happening in the string and updates the indices based on the other operations.

## Gossip Dissemination
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
