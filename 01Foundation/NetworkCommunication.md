---
type: concept
domain: network communication
summary:
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



