---
type: concept
domain: distributed systems
summary: Establishing consensus between multiple nodes of distributed system to reach a decision
---

# What it is


# Real-world application

## Electing leader

### Why leader is needed
- The leader can help reaching a decision with reduced synchronisation overhead
- The leader is responsible for coordinating steps of distributed algorithms
- The leader can help achieve total order of messages in a broadcast

### When leader election is triggered
- System is started and leader is selected for the first time
- Existing leader crashes or fails to communicate  
  - The system must have failure detection mechanisms

### Leader election algorithms

#### Bully Algorithm
- Each process gets a unique rank.
- The process which has highest rank becomes a leader.
- If a process notices that there is no leader or existing leader has stopped responding,  
  - it sends election messages to higher-ranked processes
  - If no other process responds to its message, it assumes leadership and notifies all lower-ranked processes.
  - If some other processes responds, it sends acknowledgement to highest-rank process among them and then, that process assumes leadership and notifies all lower-ranked processes about the election result. 

**Issues with algorithm**
- In case of network partitions, the system can reach state of split brain: each partition will have its leader.
- An unstable high rank process can be stuck into reelection and failure cycle.

#### Next In-line failover
- It is a variation of bully algorithm
- Each elected leader provides a list of failover nodes.
- When a process needs to start the leader election, it sends message directly to highest-rank process in the failover list of the failing leader. If it does not respond, it tries the next one and so on.
- When the process itself is the candidate, it assumes leadership and notifies all other processes.
- The advantage is that less number of steps are required if next in-line process is alive.

