---
title: "Security Architectures"
type: architecture
domain: [security, distributed-systems]
tags: [oauth2, pkce, bff, client-credentials, token-storage]
summary: "Recommended auth flows per architecture: first-party apps, managed IdP, BFF, microservices, and third-party API access."
use_when:
  - "Choosing an auth flow for a given client type"
  - "Securing service-to-service calls"
related:
  - "02BuildingBlocks/Authentication&Authorization.md"
  - "03Patterns/IdentityAndAccessManagement.md"
  - "01Foundation/Security.md"
status: partial
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
