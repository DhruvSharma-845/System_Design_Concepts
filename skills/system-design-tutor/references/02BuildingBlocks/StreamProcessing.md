---
title: "Stream Processing"
type: building_block
domain: [data-processing, event-driven]
tags: [events, message-brokers, queues, log-based-brokers, kafka, stream-joins]
summary: "Continuous processing of unbounded event streams: message brokers (queue and log based), stream joins, and fault tolerance."
use_when:
  - "Real-time or near-real-time processing"
  - "Async communication between services"
  - "Choosing a queue vs a log-based broker"
related:
  - "02BuildingBlocks/BatchProcessing.md"
  - "03Patterns/EventSourcingAndCQRS.md"
  - "04Architectures/EventDrivenArchitecture.md"
status: solid
---

# What it is
In Stream Processing, the job doesn’t finish running when it has processed the input, but instead continues watching the input and processes changes in the input shortly after they happen.
Batch Processing processes the data belonging to a fixed duration of time. Stream Processing takes this idea to extreme and processes every event as and when it comes.

# Where it is needed
- Unbounded data, coming gradually over time.

# Event
It is a small, self-contained, immutable object containing the details of something that happened at a point in time.  
Message brokers typically don’t enforce any particular data model. A message is just a sequence of bytes with some metadata, so you can use any encoding format.  
A common approach is to use Protocol Buffers, Avro, or JSON, and to deploy a schema registry alongside the message broker to store all the valid schema versions and check their compatibility.    
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
- **Durability**:
	- Some message brokers only keep messages in memory, while others (depending on configuration) write them to disk so that they are not lost in case of a broker crash.
	- Some message brokers automatically delete a message when it has been successfully delivered to its consumers. If you add a new consumer to a messaging system, it typically starts receiving messages sent only after the time it was registered.
- **Asynchronous**:
	- The delivery to consumers will happen at an undetermined future point in time.
- **Fault Tolerance**:
	- To ensure that the message is not lost, message brokers use _acknowledgments_: a client must explicitly tell the broker when it has finished processing a message so that the broker can remove it from the queue
	- If the acknowledgement is not received, broker redelivers the message. The combination of load balancing with redelivery inevitably leads to messages being reordered. 
- **Consumption patterns**:
	- Load balancing: Each message is delivered to _one_ of the consumers, so the consumers can share the work of processing the messages in the topic.
	- Fan-out: Each message is delivered to _all_ the consumers.
	- **Kafka as an example**:  When a consumer group subscribes to a topic, each message in the topic is sent to one of the consumers in the group (balancing load across the consumers in the group). If two separate consumer groups subscribe to the same topic, each message is sent to one consumer in each group (providing fan-out across consumer groups).

## Log-based message brokers
- A producer sends a message by appending it to the end of the log, and a consumer receives messages by reading the log sequentially. If a consumer reaches the end of the log, it waits for a notification that a new message has been appended.
- **Durability**: 
	- Messages are stored permanently and not deleted even after receiving acknowledgement.
	- Many log-based message brokers now store messages in object storage to increase their storage capacity
- **Scalability**: 
	- the log can be _sharded_. Kafka calls each shard as partition.
	- A topic can be defined as a group of shards(partitions) that all carry messages of the same type
- Within each shard, the broker assigns a monotonically increasing sequence number, or _offset_, to every message.
-  There is no ordering guarantee across different partitions.
- **Consumption patterns**:
	- supports fan-out messaging, because several consumers can independently read the log
	- Each consumer in the consumer group is assigned a shard(partition) from the topic.
	- The number of nodes sharing the work of consuming a topic can be at most the number of log shards in that topic
	- Consumers keep track of the offset of the message from a shard before which all messages have been processed.
- **Fault Tolerance**:
	- Partitions are replicated.
	- If a consumer node fails, another node in the consumer group is assigned the failed consumer’s shards, and it starts consuming messages at the last recorded offset.
- **Log Compaction**:
	- The storage engine periodically looks for log records with the same key, throws away any duplicates, and keeps only the most recent update for each key. This can make log segments much smaller

# Processing Stream
- You can take the data in the events and write it to a database, cache, search index, or similar storage system.
- You can push the events to users in some way—for example, by sending email alerts or push notifications etc.
- You can process one or more input streams to produce one or more output streams. Streams may go through a pipeline consisting of several such processing stages before they eventually end up at an output.
### Stream Joins
- Stream-Stream Join: Joining the events from two unrelated streams based on some id. The join operator searches for related events that occur within a window of time.
- Stream-table join: _enriching_ the activity events with information from the database.
- Table-table join: maintains a materialized view for a query that joins two tables(streams). Both input streams are database changelogs.
### Fault Tolerance
Break the stream into small blocks and treat each block like a miniature batch process. This approach is called _microbatching_.
**Atomicity**: Once the batch completes, only then its results are visible. If it fails, it can be started again.
Provides effectively-once semantics, not exactly-once.  As soon as output leaves the stream processor (e.g., when it writes to a database, publishes messages to an external message broker, or triggers the sending of emails), the framework is no longer able to discard the output of a failed microbatch. Restarting a failed task causes the external side effect to happen twice.
**Atomic Commit**: Ensure that all outputs and side effects of processing an event persist _if and only if_ the processing is successful. 