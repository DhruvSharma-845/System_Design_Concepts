---
type: concept
domain: database
summary: Database storage engines is the layer that manages the persistence of data on disk.
---

# What it is

# Storage Structures

**Assumptions**
- Each key is associated with one data record

## B-Tree
- In-place update storage structure
- In case of BSTs/AVLs, 
	- due to low fanout , we have to perform balancing, relocate nodes, and update pointers rather frequently
	-  since elements are added in random order, there’s no guarantee that a newly created node is written close to its parent
	- Height is logn but it is still high from disk seeks perspective.
- High-fanout and low-height

#### Properties
- B-Trees are _sorted_: keys inside the B-Tree nodes are stored in order
- Using B-Trees, we can efficiently execute both _point_ and _range_ queries.
- During the range scan, iteration starts from the closest found key-value pair and continues by following sibling pointers until the end of the range is reached or the range predicate is exhausted
- Node splitting: If the target node doesn’t have enough room available, we say that the node has overflowed and has to be split in two to fit the new data. If the parent node is full and does not have space available for the promoted key and pointer to the newly created node, it has to be split as well. This operation might propagate recursively all the way to the root.
- Node merging: If neighboring nodes have too few values (i.e., their occupancy falls under a threshold), the sibling nodes are merged. This situation is called _underflow_
## Log Structure Storage

# Disk Storage and File Formats




