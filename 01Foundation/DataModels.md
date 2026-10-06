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

### Object Relational Mapping
There is inherent disconnect between object oriented models and relational model(called as Impedance Mismatch) because of which a translation layer is required between them.  
ORMs serve the purpose.  

## Document
- Represents data as interconnected graph of JSON
 