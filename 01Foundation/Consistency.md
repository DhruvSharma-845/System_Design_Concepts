---
type: concept
domain: distributed system
summary: Visibility and behavioral semantics in the presence of multiple copies of data.
---

# What it is
Consistency is a property of a system that ensures the data remains consistent among multiple copies. Also, the operations order on multiple nodes remains same i.e. linearlizable. 

# CAP Theorem
It says we cannot implement a system that guarantees both availability and consistency in the presence of network partition. 
With weakened guarantees or sometimes, violations, we can implement a system that works most of the time.

## Two types of systems
- CP(Consistent and Partition Tolerant)
  - Prefer failing the request to serving inconsistent data.
- AP(Available and Partition Tolerant)
  - Allow serving inconsistent data

## Use it carefully
Network partition does not mean node crash or failure. It means we can face consistency issues even when all nodes are up, but there are connectivity issues between them.