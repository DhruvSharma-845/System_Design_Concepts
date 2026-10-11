---
type: architecture
domain: distributed system
summary: Distributed systems architectures based on events
---
# Important Entities
## Event Broker
- Events go via an intermediary called a event broker.
- The communication via a message broker is _asynchronous_
- logically decouples the sender from the recipient
- Act as a buffer if the recipient is not available.
- redeliver messages to a process that has crashed

## Message/Event
Message brokers typically don’t enforce any particular data model. A message is just a sequence of bytes with some metadata, so you can use any encoding format.  
A common approach is to use Protocol Buffers, Avro, or JSON, and to deploy a schema registry alongside the message broker to store all the valid schema versions and check their compatibility.

# Actor Framework
-  logic is encapsulated in _actors_.
- It may have some local state (which is not shared with any other actor), 
- it communicates with other actors by sending and receiving asynchronous messages
- actors can be scheduled independently across multiple nodes.