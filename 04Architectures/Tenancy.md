---
type: architecture
domain: distributed system
summary: It defines how the customer's privacy is maintained
---
# Multitenancy
- Each tenant is a customer.
- Multiple users may have logins on the same tenant.
-  Each tenant has a self-contained dataset that is separate from those of other tenants.
- [Sharding](../01Foundation/Sharding.md) can be used to implement multitenancy from database point of view.