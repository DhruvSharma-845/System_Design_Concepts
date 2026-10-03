---
type: architecture
domain: security, distributed systems
summary: Architectures for distributed systems from security perspective
---
# First-party App + Backend
# First-party App using managed IdP
- The recommended approach is Authorization Code + PKCE([IAM](../03Patterns/IdentityAndAccessManagement)) with tokens stored 
	- in memory only (not `localStorage`), 
	- or Backend-for-Frontend (BFF) pattern that holds tokens server-side and communicates with the browser via `HttpOnly` cookies to keep tokens out of the browser entirely.
# Microservices
- In the case of machine-to-machine authorization, the Client is also the Resource Owner, so no end-user authorization is needed
- The recommended approach is Client Credentials flow. It holds the Client ID and Client Secret and uses them to get an Access Token from the Authorization Server.
# Third-party App 
# API access
