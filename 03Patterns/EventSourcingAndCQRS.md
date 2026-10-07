---
type: pattern
domain: event-driven systems
summary: event sourcing and CQRS description
---

# Event Sourcing
It is to have different representations of data separately optimised for reading and writing.
The best approach for writing data is event log(appending data at the end).  
For reading, materialized views or projections can be created from the event log.  
Whenever there is a new addition in event log, the materialized views need to be refreshed.  