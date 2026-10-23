---
type: building_block
domain: distributed systems
summary:
---

# What it is
In Stream Processing, the job doesn’t finish running when it has processed the input, but instead continues watching the input and processes changes in the input shortly after they happen.
Batch Processing processes the data belonging to a fixed duration of time. Stream Processing takes this idea to extreme and processes every event as and when it comes.

# Where it is needed
- Unbounded data, coming gradually over time.

# Event
It is a small, self-contained, immutable object containing the details of something that happened at a point in time.  
An event may be encoded as a text string, or JSON, or perhaps in a binary form.  
An event is generated once by a _producer_ (also known as a _publisher_ or _sender_) and then potentially processed by multiple _consumers_ (_subscribers_ or _recipients_).
Related events are grouped into an event stream or topic.

# Types of messaging systems

## Direct messaging from producer to consumer
- Brokerless messaging; no intermediary nodes
- Assumes that producers and consumers are constantly online.
## Queue-based message brokers
- A message broker runs as a server, with producers and consumers connecting to it as clients.
- Allows multiple producer nodes to send messages to the same topic 
- Allows multiple consumer nodes to receive messages in a topic
- Messages are buffered in queue in case consumer is not available or the producer is sending messages at speed far greater than what consumer can handle.
- Durability: Some message brokers only keep messages in memory, while others (depending on configuration) write them to disk so that they are not lost in case of a broker crash.
- Consumers are asynchronous: The delivery to consumers will happen at an undetermined future point in time.
- Some message brokers automatically delete a message when it has been successfully delivered to its consumers.
- To ensure that the message is not lost, message brokers use _acknowledgments_: a client must explicitly tell the broker when it has finished processing a message so that the broker can remove it from the queue
- If the acknowledgement is not received, broker redelivers the message. The combination of load balancing with redelivery inevitably leads to messages being reordered. 
Consumption patterns:
- Load balancing: Each message is delivered to _one_ of the consumers, so the consumers can share the work of processing the messages in the topic.
- Fan-out: Each message is delivered to _all_ the consumers.
- **Kafka as an example**:  When a consumer group subscribes to a topic, each message in the topic is sent to one of the consumers in the group (balancing load across the consumers in the group). If two separate consumer groups subscribe to the same topic, each message is sent to one consumer in each group (providing fan-out across consumer groups).

## Log-based message brokers