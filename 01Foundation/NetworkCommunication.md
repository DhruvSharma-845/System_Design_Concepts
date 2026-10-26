---
title: "Network Communication"
type: concept
domain: [networking]
tags: [encoding, protobuf, avro, json, schema-evolution, rest, rpc, grpc]
summary: "Data encoding formats, schema evolution and compatibility, and REST and RPC communication styles."
use_when:
  - "Designing service APIs"
  - "Choosing serialization formats"
  - "Planning backward and forward compatible schema changes"
related:
  - "01Foundation/DataModels.md"
  - "04Architectures/Microservices.md"
status: partial
---

# Data Encoding
It is a translation between in-memory representation of data and self-contained sequence of bytes that can be sent over network.
- Language-specific formats: Java(java.io.Serializable), Python(pickle)
	- Incompatible for other languages
	- No versioning
- JSON, XML
	- Standardized encoding
	- XML is verbose, JSON does not have floating point precision
- Protocol Buffers
	- binary encoding
	- Requires a schema
	- Uses tag instead of field names in encoded data and thus, provides backward and forward compatibility.
- Avro
	- Uses writer's and reader's schema
	- Records can contain version number of schema version that it is encoded with.

# Data Evolution
## Database Schema
- Relational: One schema is active at a time. All data conforms to one schema. The schema can change using DDL.
- NoSQL: It is schema-less database so different versions of data formats can be written in the same database.

## Network Communication Schema

### Application Layer
New and old versions of data formats might coexist at the same time.
- Rolling upgrade of a service
- Some clients have not installed the update of the app.
**Compatibility**
- Backward compatibility: Ensures that newer code can read data written by older code
- Forward compatibility: Ensures that older code can read data written by newer code
# Network Communication
- HTTP and REST: Clients(and servers) can connect to servers to make requests to server's API.
	- Clients can be web browsers, native apps.
	- Predefined schemas for inputs and outputs of APIs.
	- REST emphasizes simple data formats, using URLs for identifying resources and using HTTP features for cache control, authentication, and content type negotiation
	- Service developers often use an IDL to define and document their service’s API endpoints and data models, and to evolve them over time. Other developers can then use the service definition to determine how to query the service.
- Remote Procedure Call
	- Request to remote service looks like calling a local function
	- gRPC (Protocol Buffers) and Avro RPC

### Network Layer
Data is transmitted from source to destination using IP protocol.It consists of addressing and routing protocols.

- Routers: They are the devices that help in transmitting the data from source to destination. They receive the data from one network connect and place it on other network based on its destination

### Physical Layer
It manages the transmission of data in a single network segment, from node A to node B.
Network often comprises of heterogeneous machines, with different types of communication channels.
- Wired
  - LAN: Connect devices at small scale
  - WAN: traverses globe and make up the internet, using high speed fiber optics data pipelines 
- Wireless
  - Wireless Ethernet networks that use 802.11 protocol for transmission.
  - Cellular uses radio waves to transmit data between phone and cell towers that are connected through wire to the internet.



