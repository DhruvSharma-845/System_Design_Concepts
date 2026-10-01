---
type: concept
domain: distributed system
summary: Visibility and behavioral semantics in the presence of multiple copies of data.
---

# What it is
Consistency is a property of a system that ensures the data remains consistent among multiple copies. Also, the operations order on multiple nodes remains same i.e. linearlizable. 

# CAP Theorem
It says we cannot implement a system that guarantees both availability and consistency in the presence of network partition. 
With weakened guarantees or sometimes, violations, we can implement a system that works most of the time.

## Two types of systems
- CP(Consistent and Partition Tolerant)
  - Prefer failing the request to serving inconsistent data.
- AP(Available and Partition Tolerant)
  - Allow serving inconsistent data

## Use it carefully
Network partition does not mean node crash or failure. It means we can face consistency issues even when all nodes are up, but there are connectivity issues between them.

# Consistency Models
They helps in 
- reasoning about the ordering of operations on multiple copies of data executed by multiple processes in distributed system.
- describe what expectations clients might have in terms of possible returned values despite the existence of multiple copies of data and concurrent accesses to it.
## Types of consistency models
- Strict Consistency
	- Any write by any process is instantly available for subsequent reads by any process.
	- Just a theoretical model
- Linearizability
	- Defines total order of the events. Even though operations can overlap, their effects become visible in a way to make them sequential.
	- Write becomes visible to all readers at some point in time between its start and end(Linearization point). Results have to take effect before completion.
	- If one readers observe the new value, all subsequent read operation by any process will observe at least as recent as that one.
	- Implementation Solution: Using locks to guard critical section
- Sequential Consistency
	- Defines global order of the events.
	- Order of operations from multiple processes may be ordered arbitrarily but all processes would observe the same order.
	- Operations can overlap but the operations from each process are executed in the same order as they were executed by the original process.
	- Implementation Solution: Memory Barriers
- Causal Consistency
	- Defines causal order of the events
	- all processes have to see _causally related_ operations in the same order. 
	- Concurrent writes with no causal relationship can be observed in a different order by different processors
	- Even if the latter write propagates faster than the former one, it isn’t made visible until all of its dependencies arrive, and the event order is reconstructed from their logical timestamps.
	- Implementation solution: Logical Clock -> Vector Clock
		- Each operation has metadata, summarizing which operations logically precede the current one.
		- When the update is received from the server, it contains the latest version of the context. Any operation can be processed only if all operations preceding it have already been applied. Until then, it is buffered. This ensures the causal order.
		- Processes maintain vectors of _logical clocks_, with one clock per process. 
		- Every clock starts at the initial value and is incremented every time a new event arrives
		- When receiving clock vectors from other processes, a process updates its local vector to the highest clock values per process from the received vectors.
		- To use vector clocks for conflict resolution, whenever we make a write to the database, we first check if the value for the written key already exists locally. If the previous value already exists, we append a new version to the version vector and establish the causal relationship between the two writes. Otherwise, we start a new chain of events and initialize the value with a single version.
# Session Consistency Models
Focuses on how single client interacts with system. Client can connect to any available replica of the data for the write operation and it is possible that the write against one replica are not visible to other one yet.
## Types of models
- Read-own-writes
	- Every read operation following the write on the same or the other replica has to observe the updated value.
- Monotonic reads
	- if the `read(x)` has observed the value `V`, the following reads have to observe a value at least as recent as `V` or some later value.
- Monotonic writes
	- writes originating from the same client appear in the order this client has executed them.
- Write-follow-reads
	-  writes are ordered after writes that were observed by previous read operations.
# Eventual Consistency
- Updates propagate through the system asynchronously.
- Eventually all accesses return the latest written value
- In case of a conflict, the notion of _latest_ value might change, as the values from diverged replicas are reconciled using a conflict resolution strategy, such as last-write-wins or using vector clock.
## Tunable Consistency
### Quorum 
- Use majority to serve consistent data
- Replication Factor `N`: Number of nodes that will store a copy of data.
- Write Consistency `W`: Number of nodes that have to acknowledge a write for it to succeed.
- Read Consistency `R`: Number of nodes that have to respond to a read operation for it to succeed.
- Choosing consistency levels where (`R + W > N`), the system can guarantee returning the most recent written value
- Increasing read or write consistency levels increases latencies and raises requirements for node availability during requests.
- Having `n` copy and `m` witness replicas has same availability guarantees as `n + m` copies,
## Strong Eventual Consistency
 - Under this model, updates are allowed to propagate to servers late or out of order, but when all updates finally propagate to target nodes, conflicts between them can be resolved and they can be merged to produce the same valid state  
 - Implementation approach to reconcile after divergence: Conflict-Free Replicated Data Types.  
	 - CRDTs are specialized data structures that preclude the existence of conflict and allow operations on these data types to be applied in any order without changing the result.  
	 - Replicas can execute operations locally, without prior synchronization with other nodes, and operations eventually propagate to all other replicas, potentially out of order. CRDTs allow us to reconstruct the complete system state from local individual states or operation sequences.
