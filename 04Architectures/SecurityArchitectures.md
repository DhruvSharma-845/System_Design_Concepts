---
type: architecture
domain: security, distributed systems
summary: Architectures for distributed systems from security perspective
---
# First-party App + Backend
# First-party App using managed IdP
- The recommended approach is Authorization Code + PKCE with tokens stored 
	- in memory only (not `localStorage`), 
	- or Backend-for-Frontend (BFF) pattern that holds tokens server-side and communicates with the browser via `HttpOnly` cookies to keep tokens out of the browser entirely.
# Microservices
# Third-party App 
# API access
