
# What it is
Service-discovery tools help solve the problem of finding which processes are listening at which addresses for which services.

# Characteristics
- Clients should be updated as soon as possible after the information associated with a service changes.

# How DNS acts as service discovery
DNS is designed for relatively stable name resolution with wide and efficient caching

## Issues with DNS
- It uses TTL to clean stale entries but there is a natural delay between when a name resolution changes and when the client notices.
- The way that clients handle multiple IPs in a DNS record is usually to take the first IP address and rely on the DNS server to randomize or round-robin the order of records. This is no substitute for more purpose-built load balancing.