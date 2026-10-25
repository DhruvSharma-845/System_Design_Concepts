---
title: "Event Sourcing and CQRS"
type: pattern
domain: [event-driven, databases]
tags: [event-sourcing, cqrs, cdc, materialized-views, event-log]
summary: "Using an immutable event log as the source of truth, separate read models (CQRS), and change data capture."
use_when:
  - "Audit trails or replayable state"
  - "Read and write workloads that need different models"
  - "Syncing derived systems from a database"
related:
  - "02BuildingBlocks/StreamProcessing.md"
  - "04Architectures/EventDrivenArchitecture.md"
status: partial
---

# Event Sourcing
It is the mechanism of using events as source of truth for storing data and expressing every state change as an immutable event.
The application logic is explicitly built on the basis of immutable events that are written to an event log.
- It is to have different representations of data, separately optimised for reading and writing. The best approach for writing data is event log(appending-only log of immutable events).  
- For reading, materialized views or projections can be created from the event log.  All materialized views process the events in exactly the same order as they appear in the log. Whenever there is a new addition in event log, the materialized views need to be refreshed.  
- Read-own-write is difficult to achieve:  A user could make a write to the log, then read from a derived view and find that their write has not yet been reflected in the view. To solve it, we need distributed transaction.

Log-based message brokers are well-suited for event sourcing. [Log-based messaging systems](../02BuildingBlocks/StreamProcessing.md).
# Command Query Responsibility Segregation(CQRS)
It is the principle of maintaining separate read-optimized representations and deriving them from the write-optimized representation.

# Change-Data Capture
Most nontrivial applications need to combine several technologies in order to satisfy their requirements—for example, using an OLTP database to serve user requests, a cache to speed up common requests, a full-text index to handle search queries, and a data warehouse for analytics.   
Each of these has its own copy of the data, stored in its own representation that is optimized for its own purposes.
They need to be kept in sync with one another.
- Dual Writes: the application code explicitly writes to each of the systems when data changes
	- Race conditions can lead to incorrect interleaving of operations or conflicts.
	- No atomicity
- CDC:
	- Process of observing all data changes written to a database and extracting them in a form in which they can be replicated to other systems
	- The application uses the database in a mutable way, updating and deleting records at will.
	- CDC makes the database the leader (the one from which the changes are captured) and turns the others(search index, cache) into followers.
	- A log-based message broker is well suited for transporting the change events from the source database to the derived systems.