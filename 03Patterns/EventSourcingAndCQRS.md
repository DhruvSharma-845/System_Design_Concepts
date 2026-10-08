---
type: pattern
domain: event-driven systems
summary: event sourcing and CQRS description
---

# Event Sourcing
It is the mechanism of using events as source of truth and expressing every state change as an event.
- It is to have different representations of data separately optimised for reading and writing. The best approach for writing data is event log(appending-only log of immutable events).  
- For reading, materialized views or projections can be created from the event log.  All materialized views process the events in exactly the same order as they appear in the log. Whenever there is a new addition in event log, the materialized views need to be refreshed.  

# Command Query Responsibility Segregation(CQRS)
It is the principle of maintaining separate read-optimized representations and deriving them from the write-optimized representation.