---
title: "Security"
type: concept
domain: [security]
tags: [cryptography, public-key, signatures, tls, mtls, certificates, jwt]
summary: "Cryptographic foundations: public-key crypto, signatures, TLS and mTLS, certificates, and JWT security tokens."
use_when:
  - "Securing transport between clients and services"
  - "Choosing token formats such as JWT"
related:
  - "02BuildingBlocks/Authentication&Authorization.md"
  - "04Architectures/SecurityArchitectures.md"
status: partial
---

# Cryptography
## Public-key cryptography
- Relies on a pair of keys — a public key and a private key. Anything encrypted with the public key can be decrypted only with the _private_ key.
- a server that decrypts a message that was encrypted with the public key proves that it possesses the private key
# Signature
# SSL and TLS 
It authenticates the server in a client-server connection and encrypts communications between client and server so that external parties cannot spy on the communications.
## Certificate
It is a data file that contains important information for verifying a server's or device's identity, including the public key, a statement of who issued the certificate, and the certificate's expiration date.  
TLS certificates are issued by a certificate authority: an external organization that checks if the certificate owner legitimately owns the associated domain
## TLS Handshake
TLS connection establishment includes an exchange of certificates to verify the identity of the server (and optionally client), and the selection of an algorithm to check that the data is not tampered with in transit.
It is process for verifying the TLS certificate and the server's possession of the private key.
- Server presents its TLS certificate
- Client verifies the server's certificate
Once a connection is established, in-flight data is encrypted using symmetric cryptography, which has a negligible performance penalty as modern CPUs have dedicated encryption hardware.

# mTLS
It ensures that the parties at each end of a network connection are who they claim to be by verifying that they both have the correct private key. The information within their respective TLS certificates provides additional verification.
Used in zero trust security environment.
- Server presents its TLS certificate
- Client verifies the server's certificate
- Client presents its TLS certificate
- Server verifies the client's certificate
- Server grants access
The organization implementing mTLS acts as its own certificate authority.
# Security Tokens
## JWT
JWT defines a compact and self-contained way for securely transmitting identity of authenticated user as a JSON object.
JWT are used as default access tokens in [OAuth 2.0](../02BuildingBlocks/Authentication&Authorization#Authorization)  
The resource servers can validate this token locally without network roundtrip.  
A JWT has three dot-separated parts: 
- a base64url-encoded header specifying the algorithm, 
- a base64url-encoded payload containing the claims, 
- and a signature computed over both.

RFC 9068 defines required claims — `iss`, `exp`, `aud`, `sub`, `client_id`, `iat`, `jti` — and a standard `scope` claim.  
The resource server validates the signature using the authorization server's public key , then checks `aud` to confirm the token was issued for this specific resource server.

**Good Practices**
- Keep lifetimes short because they cannot be revoked before they expire.
