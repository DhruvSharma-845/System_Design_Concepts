---
title: "Fault Tolerance"
type: concept
domain: [distributed-systems]
tags: [reliability, failure-detection, clocks, partial-failure, byzantine-faults, retries, idempotency, idempotency-keys]
summary: "Faults in distributed systems (unreliable networks and clocks, pauses), failure detection, and safe retries using idempotency keys."
use_when:
  - "Designing for high availability and reliability"
  - "Handling timeouts, failure detection, or clock skew"
  - "Retrying state-changing requests without duplicating their effects"
related:
  - "01Foundation/Replication.md"
  - "01Foundation/Consistency.md"
  - "01Foundation/Consensus.md"
  - "01Foundation/Transactions.md"
status: solid
---

# What it is
Reliability of the system: It is the property of a system to continue operating correctly in the presence of the failure of its components.

# Types of failures and faults in distributed systems
Distributed systems have no shared memory, only message passing via an unreliable network with variable delays. 
The systems may suffer from partial failures, unreliable clocks, and processing pauses.

## Unreliable network
Machines in distributed system communicate over the network.  
Between sending a request and getting a response, many things can go wrong. It is indistinguishable whether the request message did not reach the recipient or the response message has not reached the source. The failures do not provide any insight into the reason why a response has not been received.  

**Idempotency**
The typical solution that clients adopt to handle crash faults is to resend the request after a configured timeout period. But this can cause problems in case the operation is not idempotent.  Idempotent operations can be applied multiple times without changing the result beyond the initial application.
- Clients include a unique _idempotency key_ in all requests that mutate state. The key identifies a single operation from the specific client or event source.
- When the server receives a request, it checks to see if it has previously seen the idempotency key value by reading from a database that is uniquely designed for implementing idempotence. If the key is not in the database, this is a new request. The server therefore performs the business logic to update the application state. 
- It also stores the idempotency key in a database(or fast lookup key-value DB) to indicate that the operation has been successfully applied.
- If the idempotency key is in the database, this indicates that this request is a retry from the client and hence should not be processed.
- Once a client receives an acknowledgment of a success for an individual operation, the idempotency key can be discarded.

### Failure Detection
To tolerate faults, the first step is to _detect_ them.  
A _failure detector_ is a local subsystem responsible for identifying failed or unreachable processes to exclude them from the algorithm. Excluding failed processes helps to avoid unnecessary work and prevents error propagation and cascading failure.  
There is a trade-off between efficiency and accuracy of detecting faulty processes.  

### Failure detection algorithms
- Timeouts
	- Too short a timeout causes alive nodes to be incorrectly suspected to be dead, and too long a timeout causes unnecessary delays waiting for dead nodes.
	- Prematurely declaring a node dead will shift its responsibilities to other node and places additional load on the network.
	- Asynchronous networks have _unbounded delays_ (they try to deliver packets as quickly as possible, but there is no upper limit on the time it may take for a packet to arrive)
	- The variability of packet delays on computer networks is most often due to queueing
	- In such environments, you can choose timeouts only experimentally: measure the distribution of network round-trip times over an extended period, and over many machines, to determine the expected variability of delays
	- Systems can continually measure response times and their variability (_jitter_) and automatically adjust timeouts according to the observed response time distribution
- Heartbeats and Pings
	- Heartbeat: The process is actively notifying its peers that it’s still running by sending messages to them. It is timeout free. Each process maintains a _heartbeat counter vector_ for all other processes in the system. Each message contains a path that the heartbeat has traveled so far. Based on the received message, the process can increment counter for all participants present in the message. The process then can forward this heartbeat message, appending itself to it.
	- Ping: The process sends messages to peers, checking if they are still alive by expecting a response within a specified time period.  If a process fails to respond to a ping message for a longer time, it is marked as suspected. Precision relies on the careful selection of ping frequency and timeout
	- Phi Accrual: It works by maintaining a sliding window, collecting arrival times of the most recent heartbeats from the peer processes. This information is used to approximate arrival time of the _next_ heartbeat, compare this approximation with the actual arrival time, and compute the _suspicion level_ `φ`: how certain the failure detector is about the failure
- Gossip
	- Each member maintains a list of other members, their _heartbeat counters_, and timestamps, specifying when the heartbeat counter was incremented for the last time. 
	- Periodically, each member increments its heartbeat counter and distributes its list to a random neighbors. Upon the message receipt, the neighboring node merges the list with its own, updating heartbeat counters for the other neighbors.
	- If any node did not update its counter for long enough, it is considered failed

## Unreliable clock

Each machine has its own clock and therefore, has its own notion of time.  
It is possible to synchronise the clocks but to some degree using NTP   

If all the clocks on every machine were perfectly synchronized, we could always simply compare the timestamps on events across nodes to determine the precise order they occurred in.

Type of clocks
- Time of day clock
  - Is synchronised with NTP and can be jumped backward to a previous point in time.
- Monotonic clock
  - Will always move forward
  - NTP can speed up or slow down the clock

Carefully monitor the clock offsets between all nodes in the cluster and the faulty clocks that have drifted very far from NTP, should be declared dead. 
To guarantee a correct ordering, you would need the clock error to be significantly lower than the network delay, which is not possible.
Logical clocks are safer alternative for ordering events.

### Ordering of events
 Ordering of events across multiple nodes cannot be reliably done using clocks because the writer nodes clocks might have drifted apart.

### Distributed Snapshot Isolation
- MVCC requires a monotonically increasing transaction ID. If a write happened later than the snapshot (i.e., the write has a greater transaction ID than the snapshot), that write is invisible to the snapshot transaction.
- When a database is distributed across many machines, potentially in multiple datacenters, a global, monotonically increasing transaction ID (across all shards) should be generated.
- We can use clock time with confidence interval as transaction ID.
- If you have two confidence intervals, each consisting of an earliest and latest possible timestamp (_A_ = [_Aearliest_, _Alatest_] and _B_ = [_Bearliest_, _Blatest_]), and those two intervals do not overlap (i.e., _Aearliest_ < _Alatest_ < _Bearliest_ < _Blatest_), then B definitely happened after A.



# Reducing the effects of failures
- Distributed systems should not rely on single node, instead, it should rely on quorum. 
	- Decisions require a minimum number of votes from several nodes. That includes decisions about declaring nodes dead.
- Distributed Locks and Leases
	- A lease is a kind of lock that times out and can be assigned to a new owner if the old owner stops responding.
	- A _zombie_ is sometimes used to describe a former leaseholder that has not yet found out that it lost the lease(perhaps, it was paused in between and timeout happened) and is still acting as if it were the current leaseholder. 
	- Since we cannot rule out zombies entirely, we have to instead ensure that they can’t do any damage in the form of split brain. This is called _fencing off_ the zombie.
	- Every time the lock service grants a lock or lease, it also returns a _fencing token_, which is a number that increases every time a lock is granted (e.g., incremented by the lock service). 
	- We can then require that every time a client sends a write request to the storage service, it must include its current fencing token.
	- The target service can block a writer that has older fencing token.
- Remove single point of failure  
  - By introducing redundancy: [Replication](./Replication.md)
  - But with replication comes read inconsistencies due to replication lag and data conflicts due to concurrent writes. Levels of consistency are discussed in [Consistency](./Consistency.md).

# Byzantine Faults
In distributed systems, there is a risk that nodes may “lie” (send arbitrary faulty or corrupted responses)—for example, a node might cast multiple contradictory votes in the same election. Such behavior is known as a _Byzantine fault_.  
A system is _Byzantine fault-tolerant_ if it continues to operate correctly even if some of the nodes are malfunctioning and not obeying the protocol, or if malicious attackers are interfering with the network.
