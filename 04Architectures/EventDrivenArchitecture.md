---
type: architecture
domain: distributed system
summary: Distributed systems architectures based on events
---
# Important Entities


# Actor Framework
- a mechanism for managing concurrency and distributed execution of communicating modules. 
- logic is encapsulated in _actors_.
- It may have some local state (which is not shared with any other actor), 
- it communicates with other actors by sending and receiving asynchronous messages
- actors can be scheduled independently across multiple nodes.