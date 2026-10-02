---
type: concept
domain: security, cryptography
summary: application security related concepts and cryptographic mechanism
---
# Cryptography
## Public-key cryptography
- Relies on a pair of keys — a public key and a private key. Anything encrypted with the public key can be decrypted only with the _private_ key.
- a server that decrypts a message that was encrypted with the public key proves that it possesses the private key
# Signature
# SSL and TLS Certificate
It is a data file that contains important information for verifying a server's or device's identity, including the public key, a statement of who issued the certificate, and the certificate's expiration date.  
TLS certificates are issued by a certificate authority.
# Security Tokens
## JWT
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
