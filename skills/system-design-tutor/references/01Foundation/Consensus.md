---
title: "Consensus"
type: concept
domain: [distributed-systems]
tags: [consensus, leader-election, shared-log, atomic-broadcast, locks, leases, flp]
summary: "How multiple nodes agree on a value: shared logs, atomic broadcast, leader election, locks and leases."
use_when:
  - "Leader election or failover without split brain"
  - "Distributed locks, leases, or uniqueness constraints"
  - "Building a linearizable or replicated log"
related:
  - "01Foundation/Replication.md"
  - "01Foundation/Consistency.md"
  - "01Foundation/FaultTolerance.md"
  - "01Foundation/Transactions.md"
status: solid
---

# What it is
It allows multiple processes to reach an agreement on a value.
**FLP Impossibility** says that it is impossible to get consensus in an asynchronous system in bounded time.
**Role of failure detection**
Since failure detection is not always accurate, it is possible that the consensus algorithm is restarted because a process is incorrectly reported as faulty.

# Use-cases
- Implementing linearizability in single-leader replication with fault tolerance
	- A database can be linearizable if you have only a single leader and you make all reads and writes on that leader. But how do you fail over if that leader fails, while avoiding split brain?
- Linearizable ID generator with fault tolerance
	- On a single node, it is just a counter with an atomic fetch-and-add instruction—what if it crashes?
- putting events in particular order
- ensuring consistency among participants
# Single value consensus
One or more nodes may _propose_ values, and the consensus algorithm _decides_ on one of those values.
- CAS(Compare and set) as single value consensus: Initially set the object to a null value, then have each node that wants to propose a value perform a CAS, with the expected value being null and the new value being the value it wants to propose (assuming it is non-null). The decided value is then whatever value the object is set to.
- Shared log as single value consensus: Every node that wants to propose a value requests that it be added to the log, and whichever value is read back in the first log entry is the value that is decided. Since all nodes read log entries in the same order, they are guaranteed to agree on which value is delivered first.
- Fetch and add as single value consensus: If you have a CAS operation, implementing fetch-and-add is easy. First read the counter value, then perform a CAS where the expected value is the value you read, and the new value is that value plus 1. If the CAS fails, you retry the whole process until the CAS succeeds. Since you can implement CAS using consensus, you can also implement fetch-and-add using consensus.



# How to achieve consensus in practice

## Shared Logs
Most consensus systems provide shared logs.
Database Replication/State Machine Replication: Each entry in shared log is a write to database and every replica processes the same writes in the same order.  

We can use it to implement single-value consensus and CAS: simply decide the value that appears first in the log.
### How to implement
A shared log is easy if a single leader is the only node allowed to append log entries.
For consensus, we require that the algorithm can automatically choose a new leader in case of failures.
Here, we need consensus to elect a leader, and we need a leader in order to solve consensus.
-  When a node believes that the current leader is dead because it hasn’t heard from the leader for some timeout, it may start a vote to elect a new leader. This election is given a new epoch number that is greater than any previous epoch number. If a conflict arises between two leaders in two epochs (perhaps because the previous leader wasn’t dead after all), then the leader with the higher epoch number prevails.
- Before a leader is allowed to append the next entry to the shared log, it must first check that there isn’t another leader with a higher epoch number that might append a different entry. It can do this by collecting votes from a quorum of nodes
- Two operations: a vote by a quorum of nodes elects a leader, and then another quorum vote is required for every entry that the leader wants to append to the log
- Every new log entry is synchronously replicated to a quorum of nodes before it is confirmed to the client that requested the write.

## Broadcast
It is used to disseminate information among a set of processes.

## Atomic Broadcast
If we need to deliver messages in order, we have to use the atomic broadcast.
- Virtual Synchrony delivers totally ordered messages to a _dynamic_ group of peers.


# Real-world application

## Implementing locks and leases
Single value consensus

## Electing leader
It is a consensus problem. To elect a leader, we need to reach a consensus about its identity.
Constructing an append-only log in distributed setting.
One or more nodes may _propose_ values, and the consensus algorithm _decides_ on one of those values.

### Why leader is needed
- The leader can help reaching a decision with reduced synchronisation overhead
- The leader is responsible for coordinating steps of distributed algorithms
- The leader can help achieve total order of messages in a broadcast

### When leader election is triggered
- System is started and leader is selected for the first time
- Existing leader crashes or fails to communicate  
  - The system must have failure detection mechanisms to detect if the existing leader is alive.

### Leader election algorithms

#### Bully Algorithm
- Each process gets a unique rank.
- The process which has highest rank becomes a leader.
- If a process notices that there is no leader or existing leader has stopped responding,  
  - it sends election messages to higher-ranked processes
  - If no other process responds to its message, it assumes leadership and notifies all lower-ranked processes.
  - If some other processes responds, it sends acknowledgement to highest-rank process among them and then, that process assumes leadership and notifies all lower-ranked processes about the election result. 
  - Issues with algorithm  
    - In case of network partitions, the system can reach state of split brain: each partition will have its leader.
    - An unstable high rank process can be stuck into reelection and failure cycle.

#### Next In-line failover
- It is a variation of bully algorithm
- Each elected leader provides a list of failover nodes.
- When a process needs to start the leader election, it sends message directly to highest-rank process in the failover list of the failing leader. If it does not respond, it tries the next one and so on.
- When the process itself is the candidate, it assumes leadership and notifies all other processes.
- The advantage is that less number of steps are required if next in-line process is alive.

#### Candidate/Ordinary
- Processes are split into two categories: Candidate and Ordinary.
- The ordinary process starts the algorithm by sending messages to all candidates.
- The candidates respond to the ordinary process. It selects the highest rank candidate as the new leader and notifies all other processes about the election result.

#### Invitation Algorithm
- It allows processes to invite other processes to join their groups.
- Each process starts as a leader of its own group.
- It contacts other peer process, inviting it to join.
- If the peer process is leader, the two groups are joined. Otherwise, it sends back the id of its group leader, allowing group leaders to merge.

#### Ring Algorithm
- All nodes form a ring.
- The election message is forwarded across the ring: each node contacting its successor.
- When the message comes back to node that initiated the election, the highest-rank node collected in the message becomes the leader.

### Single leader issues
- The leader can become bottleneck.  
  - Possible Solution: Partion the system and have each partition a separate leader

