---
type: concept
domain: distributed systems
summary: software systems that can accommodate growth
---
# What it is
Scalability is the property of a system to handle a growing amount of work by adding resources to the system.  
Increasing a system’s capacity in some dimension by increasing resources is called _scaling up_ or _scaling out_. In addition, it is often equally important to be able to _scale down_ the capacity of a system to reduce costs.

# How to scale
## Replication
Replicate the software processing resources to provide more capacity to handle requests and thus increase throughput.
Database replication is described in detail [here](./Replication.md).

## Optimization
Optimize the processing by using more efficient algorithms, adding extra indexes in our databases to speed up queries, or even rewriting our server in a faster programming language.