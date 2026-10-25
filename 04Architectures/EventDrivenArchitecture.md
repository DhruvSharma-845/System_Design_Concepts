---
title: "Event-Driven Architecture"
type: architecture
domain: [event-driven, distributed-systems]
tags: [events, actors, async-messaging]
summary: "Architectures built on asynchronous events and messages, including the actor model."
use_when:
  - "Loosely coupled services reacting to events"
  - "Highly concurrent, distributed message processing"
related:
  - "02BuildingBlocks/StreamProcessing.md"
  - "03Patterns/EventSourcingAndCQRS.md"
  - "04Architectures/Microservices.md"
status: partial
---

# Important Entities


# Actor Framework
- a mechanism for managing concurrency and distributed execution of communicating modules. 
- logic is encapsulated in _actors_.
- It may have some local state (which is not shared with any other actor), 
- it communicates with other actors by sending and receiving asynchronous messages
- actors can be scheduled independently across multiple nodes.