---
type: concept
domain: database, network communication
summary: Modelling the real world data into easy to use format
---

# What it is

# Layers of representation
Each layer hides the complexity of the layer below it.
- Modelling real-world objects in terms of high-level objects, data structures and APIs that manipulate them.
- Next level is storing the data in terms of relational tables, JSON etc
- The last layer is storing these structures in the disk in terms of bytes

# Types of data models 
## Relational
- Data is organized into tables
- A table is unordered collection of tuples(rows)
- Better support for joins
- Schema on write: The schema is explicit and the database ensures that all data conforms to it when the data is written

### Types of relationship
- One-to-many
- Many-to-many: Represented by a separate join table that contains foreign keys.

### Object Relational Mapping
There is inherent disconnect between object oriented models and relational model(called as Impedance Mismatch) because of which a translation layer is required between them.  
ORMs serve the purpose.  

### Normalisation
Breaking the tables into smaller more-cohesive tables.  
Advantages:
- No duplication of data in each referred record
- Updates are done to localized portion o data and thus, are faster.
Disadvantages:
- Reading would involve more joins and slower.

Normalization and denormalization has trade-offs and they have to be carefully chosen in the implementation.

### Query Language
SQL

## Document
- Represents data as interconnected graph of JSON
- Fits more naturally to represent the object structure graph(especially one-to-many relationships), thus, reducing the impedance mismatch.
- Relaxed schema constraints(schemaless) but more appropriately, it is schema on read(interpreted only when the data is read)
	- Advantageous if the items in the collection don’t all have the same structure
- Better performance due to data locality
- Most often, denormalized data schema is used.

### Types of relationship
- One-to-many: Fits naturally
- Many-to-many: Does not fit in self-contained JSON document model. Normalisation is required in the form where the source JSON contains partial one-to-many part that in turn contains the references to other JSON document.
### Query Language
JSONPath, $lookup etc.

## Graph
- Suitable for complex many-to-many relationships 
- Can store heterogeneous data types as vertices in single database

### Types of storage structure 
- Property Graph Model
  - Has two relational table: vertices and edges
  - edges table is like join table in Many-to-many relationship in relational data model
  - Query Languages
    - Cypher: In a graph query, number of joins can be variable and might not be known in advance.
- Triple Stores Graph model
  - Every information is stored in three-part statements: Subject, predicate and object
  - Query Languages
    - SPARQL: Uses RDF data model

# GraphQL
It is a query language that allows the clients to request the data from server with a specific JSON structure.  
Clients can rapidly change queries based on the requirement changes.
This flexibilty comes with a cost: need a transformation layer that converts the graphql query to the backend APIs.  
Can be built over any data model - relational, document or graph