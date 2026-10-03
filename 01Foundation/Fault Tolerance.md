---
type: concept
domain: single-node system, distributed system
summary: Ability of a system to continue operating correctly in the presence of the failure of its components
---

# What it is
It is the property of a system to continue operating correctly in the presence of the failure of its components

# Types of failures
- Link failures: messages between processes are lost or delivered slowly
- Process failures: the process crashes or is running slowly

# How it can be achieved
## Failure Detection
A _failure detector_ is a local subsystem responsible for identifying failed or unreachable processes to exclude them from the algorithm. Excluding failed processes helps to avoid unnecessary work and prevents error propagation and cascading failure.  
There is a trade-off between efficiency and accuracy of detecting faulty processes.  

### Failure detection algorithms
- Heartbeats and Pings
	- Heartbeat: The process is actively notifying its peers that it’s still running by sending messages to them. It is timeout free. Each process maintains a _heartbeat counter vector_ for all other processes in the system. Each message contains a path that the heartbeat has traveled so far. Based on the received message, the process can increment counter for all participants present in the message. The process then can forward this heartbeat message, appending itself to it.
	- Ping: The process sends messages to peers, checking if they are still alive by expecting a response within a specified time period.  If a process fails to respond to a ping message for a longer time, it is marked as suspected. Precision relies on the careful selection of ping frequency and timeout
	- Phi Accrual: It works by maintaining a sliding window, collecting arrival times of the most recent heartbeats from the peer processes. This information is used to approximate arrival time of the _next_ heartbeat, compare this approximation with the actual arrival time, and compute the _suspicion level_ `φ`: how certain the failure detector is about the failure
- Gossip
	- Each member maintains a list of other members, their _heartbeat counters_, and timestamps, specifying when the heartbeat counter was incremented for the last time. 
	- Periodically, each member increments its heartbeat counter and distributes its list to a random neighbors. Upon the message receipt, the neighboring node merges the list with its own, updating heartbeat counters for the other neighbors.
	- If any node did not update its counter for long enough, it is considered failed
## Reducing the effects of failures
- Remove single point of failure  
  - By introducing redundancy: [Replication](./Replication.md)
