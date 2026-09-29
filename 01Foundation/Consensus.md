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


