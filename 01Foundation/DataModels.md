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
- Updates are done to smaller areas and faster.
Disadvantages:
- Reading would involve more joins and slower.

Normalization and denormalization has trade-offs and they have to be carefully chosen in the implementation.

## Document
- Represents data as interconnected graph of JSON
- Fits more naturally to represent the object structure graph(especially one-to-many relationships), thus, reducing the impedance mismatch.
- Most often, denormalized data schema is used.

### Types of relationship
- One-to-many
- Many-to-many: Does not fit in self-contained JSON document model. Normalisation is required in the form where the source JSON contains partial one-to-many part that in turn contains the references to other JSON document.