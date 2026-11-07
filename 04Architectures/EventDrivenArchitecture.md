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
# What it is

Message producers simply store a message on a queue, without concern about how it is processed by consumers. There can be one or many consumers, and the collection of producers and consumers can evolve over time.   
This buys you immense architectural flexibility and has benefits in improving service responsiveness, smoothing out request arrival spikes through buffering, and maintaining system processing in the face of unavailable consumers.

# Important Entities


# Actor Framework
- a mechanism for managing concurrency and distributed execution of communicating modules. 
- logic is encapsulated in _actors_.
- It may have some local state (which is not shared with any other actor), 
- it communicates with other actors by sending and receiving asynchronous messages
- actors can be scheduled independently across multiple nodes.