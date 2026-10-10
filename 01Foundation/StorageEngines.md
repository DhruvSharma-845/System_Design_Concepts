---
type: concept
domain: database
summary: Database storage engines is the layer that manages the persistence of data on disk.
---

# What it is
Data model is the high-level format that is an interface exposed by the database. The actual storage format that the database employs can be entirely different. That storage mechanisms are covered in this article.

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

### Properties
- B-Trees are _sorted_: keys inside the B-Tree nodes are stored in order
- Each node is a fixed size disk block
- Using B-Trees, we can efficiently execute both _point_ and _range_ queries.
- During the range scan, iteration starts from the closest found key-value pair and continues by following sibling pointers until the end of the range is reached or the range predicate is exhausted
- Node splitting: If the target node doesn’t have enough room available, we say that the node has overflowed and has to be split in two to fit the new data. If the parent node is full and does not have space available for the promoted key and pointer to the newly created node, it has to be split as well. This operation might propagate recursively all the way to the root.
- Node merging: If neighboring nodes have too few values (i.e., their occupancy falls under a threshold), the sibling nodes are merged. This situation is called _underflow_
- Every modification to the tree is first written to write ahead log

## Log Structure Storage
- Writes out immutable files
- Maintains a hashmap mapping every key to the byte offset of the value on the disk where the most recent value is present.

### SSTable 
It is a collection of blocks(segments) where each block contains key-value pairs, sorted by key.
- First, the writes are performed in memory to a memtable.
- When it is filled, it is written to disk as a segment.
- Searching would be sequential from most recent segment to least recent segment.
- Merging of sorted segments is performed as background process.
- To ensure the data written to memtable is not lost, a separate log is maintained on disk to which every write is immediately logged.

**Bloom filters**
It fixes the read performance issue in SSTable. It provides fast but approximate way of checking if the key is not present in the table.

**Types of compaction Strategies**
- Size-tiered: Newer and smaller tables are merged into older ones.
- Leveled: Groups the tables into increasing levels. L0 contains most recently written values. All levels beyond L0 contain key-range-partitioned values. Level i SSTable combines to make Level i+1

# Index
It is an additional structure that is derived from the primary data and helps in efficiently find the value for a particular key.
Maintaining index incurs overhead during writes.  
Clustered Index: If the actual data is stored in the index structure

## Secondary Indexes
Enables searching by columns other than the primary key
- Keys are not unique
- Values can contain actual data records or just pointers to primary index(primary key of the record).

# Disk Storage and File Formats

## Column oriented storage: Stores the values of one column together




