---
title: "Tenancy"
type: architecture
domain: [distributed-systems, multitenancy]
tags: [multitenancy, isolation, saas]
summary: "Multitenant architecture: isolating each customer's data and users, including shard-per-tenant strategies."
use_when:
  - "Designing SaaS products serving many customers"
  - "Tenant data isolation requirements"
related:
  - "01Foundation/Sharding.md"
  - "01Foundation/Security.md"
status: partial
---

# Multitenancy
- Each tenant is a customer.
- Multiple users may have logins on the same tenant.
-  Each tenant has a self-contained dataset that is separate from those of other tenants.
- [Sharding](../01Foundation/Sharding.md) can be used to implement multitenancy from database point of view.