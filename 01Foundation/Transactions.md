---
title: "Transactions"
type: concept
domain: [databases, distributed-systems]
tags: [acid, isolation-levels, concurrency-control, two-phase-commit, distributed-transactions, exactly-once]
summary: "ACID transactions on single nodes and distributed systems: isolation levels, concurrency control, 2PC/3PC, and exactly-once."
use_when:
  - "Correctness under concurrent writes"
  - "Atomic updates across shards or services"
  - "Choosing isolation levels"
related:
  - "01Foundation/Consensus.md"
  - "01Foundation/Consistency.md"
  - "03Patterns/WorkflowEngines.md"
status: solid
---

# Single Node Transactions
A _transaction_ is a set of operations(reads and writes) as indivisible logical unit of work, working as an atomic unit of execution.
- Either the entire transaction succeeds resulting into commit or it fails resulting into abort/rollback. Partial failures cannot happen.
- To improve efficiency, we need to allow concurrent transaction execution.
- To preserve correctness, we have to ensure that concurrently executing transactions preserve ACID properties
## ACID Guarantees
- Atomicity
	- All results of the transaction execute successfully and become visible or none of them do.
	- Rollback(Undo any writes it has done so far) if the transaction cannot complete
	- If a transaction has a side effect outside the database, in case of rollback, those side-effects might not be revertable.
	- The _log manager_ holds a history of operations (log entries) applied to cached pages but not yet synchronized with persistent storage to guarantee they won’t be lost in case of a crash. 
	- In other words, the log is used to reapply these operations and reconstruct the cached state during startup. 
	- Log entries can also be used to undo changes done by the aborted transactions.
- Consistency
	- a transaction should only bring the database from one valid state to another valid state, maintaining all database invariants (such as constraints, referential integrity, and others)
- Isolation
	- Multiple concurrently executing transactions should be able to run without interference, as if there were no other transactions executing at the same time. Each transaction can pretend that it is the only transaction running on the entire database.
	- The database ensures that when the transactions have committed, the result is the same as if they had run serially. In realilty, many databases use isolation levels that are weaker because serializability has performance cost.
	- In isolation, it is also ensured that a transaction cannot read the partial updates of another transaction.
	- The transaction manager coordinates and schedules the transactions.
	- The _lock manager_ guards access to these resources and prevents concurrent accesses that would violate data integrity
	- Schedules:
		- A _schedule_ is a list of operations required to execute a set of transactions from the database-system perspective
		- A schedule is said to be _serial_ when transactions in it are executed completely independently and without any interleaving. Prevents concurrency.
		- Serializability: When the order of execution of operations of transactions is equivalent to sequential(serial) execution of the transactions. Ensures concurrency as well as correctness. It produces the same result as if we executed a set of transactions one after another in _some_ order.
- Durability
	- Once a transaction has been committed, all database state modifications have to be persisted on disk and be able to survive power outages, system failures, and crashes.
	- Databases usually also have a write-ahead log or similar feature which allows them to recover 
	- In a replicated database, durability may mean that the data has been successfully copied to a certain number of nodes(Synchronous Replication).

## Atomicity
- Commit Log
	- A _write-ahead log_ is an append-only auxiliary disk-resident structure used for crash and transaction recovery.
	- Until the cached contents are flushed back to disk, the only disk-resident copy preserving the operation history is stored in the WAL.
	- If the commit record was successfully written to disk before the crash, the transaction is considered committed. If not, any writes from that transaction are rolled back.
	- Allow lost in-memory changes to be reconstructed from the operation log in case of a crash. The pre-crash database state is fully restored.
	- Checkpoints are a way for a log to know that log records up to a certain mark are fully persisted and aren’t required anymore.
## Isolation
### When do Isolation Issues happen?
If we allow multiple transactions to execute without coordination where one or all of them write a data that other transactions are reading.
- Dirty Read: a transaction can read uncommitted changes from other transactions
- Non-repeatable read: transaction queries the _same row_ twice and gets different results
- Phantom Read: A _phantom read_ is when a transaction queries the same _set of rows_ twice and receives different results
- Dirty Write: one of the transactions takes an uncommitted value (i.e., dirty read), modifies it, and saves it.
- Lost Update: when transactions `T1` and `T2` both attempt to update the value of `V`, the results of `T1` might be overwritten by the results of `T2`
	- Atomic Write, Explicit Locking for read-modify-write cycle, Conditional Write(allowing an update to happen only if the value has not changed since you last read it)
	- Allow transactions to execute in parallel and, if the transaction manager detects a lost update, abort the transaction
	- In replicated databases, allow concurrent writes to create several conflicting versions of a value (also known as _siblings_) and to use application code or special data structures to resolve and merge these versions after the fact
- Write Skew: each individual transaction respects the required invariants, but their combination does not satisfy these invariants.
	- It usually happens with query functions(Count, Sum, GroupBy etc) and can involve multiple objects. Different transactions update different objects.
	- Phantom: A write in one transaction changes the result of a search query in another transaction
	- A solution is to explicitly lock the rows that the transaction depends on.
To prevent isolation issues, additional coordination is required which negatively impacts the performance.
### Isolation Levels
Isolation level describe the degree to which transactions are isolated from other concurrently executing transactions.  
- Read uncommitted: the transactional system allows one transaction to observe uncommitted changes of other concurrent transactions. Dirty Reads are allowed.
- Read committed: No dirty reads and writes, but phantom and nonrepeatable reads are. If there was a committed modification between two reads, two queries in the same transaction would yield different results.
	- Row-level locks; hold the lock until the transaction is committed or aborted.
	- Maintain old committed value and newly written value. While the transaction is going on, others transactions would see old committed value.
- Repeatable Read: If between two reads of same data record, some other transaction updates it and commit as well, then we can get different results.
	- If we further disallow non-repeatable reads in Read Committed, we get a repeatable read isolation level.
	- Snapshot Isolation
		- Snapshot isolation guarantees that all reads made within the transaction are consistent with a snapshot of the database.
		- The snapshot contains all values and transactions that were _committed before_ the transaction’s start timestamp.
		- If there’s a _write-write conflict_ (i.e., when two concurrently running transactions attempt to make a write to the same cell), only one of them will commit. The others are aborted and rolled back.
		- Prevents read skew: In between the transaction, cannot see the updated values by some other concurrent committed transaction. can only see the snapshot of the database.
		- Prevents lost update: Whichever transaction attempts to commit first, will commit, and the other one will have to abort.
		- Implementation: Multiversion Concurrency Control
			- It is used for implementing snapshot isolation.
			- Guarantees a consistent view of the database at some point in the past.
			- allow multiple timestamped versions of the record to be present because  various in-progress transactions may need to see the state of the database at different points in time
			- reads can continue accessing older values until the new ones are committed.
			- Whenever a write happens, the data is tagged with transaction id.
			- When a transaction reads from the database, transaction IDs are used to decide which row versions it can see and which are invisible.
			- Any writes made by transactions with a later transaction ID are ignored
			- Any writes made by the concurrent transactions are ignored.
			- Indexes:  each index entry points at one of the versions of a row that matches the entry. A query that uses the index must then iterate over the rows to find one that is visible
- Serializable:  The database guarantees that transaction outcomes will appear in _some_ order as if transactions were executed _serially_. It does not impose any ordering constraint(like in linearizability)
	- Write skews can be solved through serializable isolation only.
	- Linearly execute transactions in serial order
		- Every transaction must be small and fast
		- Sometimes runs faster because it can avoid the coordination overhead of locking.
		- Shard the data so that each transaction needs to read and write data only within a single shard. Each shard can have its own transaction processing thread running independently from the others
	- Pessimistic - Lock-based  
		- Transactions to maintain locks on database records to prevent other transactions from modifying locked records and assessing records that are being modified until the transaction releases its locks.
		- Two-phase locking
			- In 2PL, writers don’t just block other writers; they also block readers, and vice versa.
			- If a transaction wants to read an object, it must first acquire the lock in shared mode. Several transactions are allowed to hold the lock in shared mode simultaneously.
			- If a transaction wants to write to an object, it must first acquire the lock in exclusive mode. No other transaction may hold the lock at the same time.
			- The _growing phase_ (also called the _expanding phase_), during which all locks required by the transaction are acquired and no locks are released. It must continue to hold the lock until the end of the transaction
			- The _shrinking phase_, during which all locks acquired during the growing phase are released.
			- a transaction cannot acquire any locks as soon as it has released at least one of them.
			- Deadlock: A situation may occur when two transactions, while attempting to acquire locks they require in order to proceed with execution, end up waiting for each other to release the other locks they hold. The solution is to introduce timeouts and abort long-running transactions under the assumption that they might be in a deadlock
			- Reduced Concurrency: if two concurrent transactions try to do anything that may in any way result in a race condition, one has to wait for the other to complete.
		- Predicate Locks
			- Prevents write skew(caused by Phantom)
			- It works similarly to the shared/exclusive lock described earlier, but rather than belonging to a particular object (e.g., one row in a table), it belongs to all objects that match a search condition
	- Optimistic - Serializable Snapshot Isolation
		- full serializability with only a small performance penalty
		- all reads within a transaction are made from a consistent snapshot of the database
		- Allows transactions to execute concurrent read and write operations in the hope that everything will turn out all right
		- **Detection of serialization conflicts**: When a transaction wants to commit, the database determines whether or not the result of the combined execution is serializable before committing their results.
		- Only transactions that executed serializably are allowed to commit.
		- The transactions maintain histories of their operations, and check these histories for possible read/write conflicts before commit. If execution results in a conflict, one of the conflicting transactions is aborted
		- How to detect if search result have changed(to avoid write skew)?
			- Detecting reads of a stale MVCC object version(uncommitted write was ignored in MVCC but that write was committed before it itself is committed)
			- Detecting writes that affect prior reads (the write occurs after the read)
			- Bookkeeping overhead can become significant
### Concurrency Control Mechanisms
- pessimistic - Lock-free
	- determine transaction conflicts while they’re running and block or abort their execution.
	- each transaction has a timestamp
	- To implement that, the transaction manager has to maintain `max_read_timestamp` and `max_write_timestamp` per value, describing read and write operations executed by concurrent transactions.
	- _Read_ operations that attempt to read a value with a timestamp lower than `max_write_timestamp` cause the transaction they belong to be aborted, since there’s already a newer value
	- _write_ operations with a timestamp lower than `max_read_timestamp`would conflict with a more recent read. However, _write_ operations with a timestamp lower than `max_write_timestamp` are allowed,
	- Aborted transactions restart with a _new_ timestamp

# Distributed Transactions
Multi-leader or leaderless replication: Managing the operations that need to write to several shards.
## Atomicity 
Changes have to be durably propagated to all of the nodes involved in the transaction or none of them.

## Atomic Commitment algorithms
Atomic commitment doesn’t allow disagreements between the participants: a transaction _will not_ commit if even one of the participants votes against it. Either all commit or all abort
### Two-phase commit
- Assumes the presence of leader that holds state, collects votes. It can be picked by [Leader Election Algorithm](./Consensus.md) or assigned manually.
- Phase 1(Prepare)
	- the decided value is distributed, and votes are collected
	- The coordinator notifies cohorts about the new transaction
	- Cohorts make a decision on whether or not they can commit the part of the transaction that applies to them.
	- If a cohort decides that it can commit, it notifies the coordinator about the positive vote. Otherwise, it responds to the coordinator, asking it to abort the transaction.
- Phase 2(Commit)
	- nodes just flip the switch, making the results of the first phase visible.
	- If even one of the cohorts votes to abort the transaction, the coordinator sends the `Abort` message to all of them. 
	- Only if all cohorts have voted positively does the coordinator send them a final `Commit` message
- During each step the coordinator and cohorts have to write the results of each operation to durable storage to be able to reconstruct the state and recover in case of local failures.
- The protocol contains two crucial “points of no return”: when a participant votes yes, it promises that it will definitely be able to commit later (although the coordinator may still choose to abort); and once the coordinator decides, that decision is irrevocable. Those promises ensure the atomicity of 2PC.
- **Cohort failure**: If one of the cohort fails, the coordinator stops the transaction. If the node fails in phase 2, it has to learn the actual outcome of the vote before it can server clients. The coordinator shares the decision with the failed participants.
- **Coordinator failure**: If the coordinator fails in the second phase and does not share the decision, the participant can ask the peers about the decision. If the coordinator fails just after the first phase, all participants are blocked. The participants can do nothing but wait
### Three-phase commit

- Prevents undecided blocked state on coordinator failure.  
- Propose
	- The coordinator sends out a proposed value and collects the votes.
- Prepare
	- The coordinator notifies cohorts about the vote results. If the vote has passed and all cohorts have decided to commit, the coordinator sends a `Prepare` message, instructing them to prepare to commit. Otherwise, an `Abort` message is sent and the round completes.
	- communicates cohort states collected by the coordinator during the propose phase, allowing the protocol to carry on even if the coordinator fails
- Commit
	- Cohorts are notified by the coordinator to commit the transaction.
- **Coordinator failure**: In case of Network partition, some nodes successfully move to the prepared state, and now can proceed with commit after the timeout. Some can’t communicate with the coordinator, and will abort after the timeout
- 3PC assumes a network with bounded delay and nodes with bounded response times; in most practical systems with unbounded network delay and process pauses; 3PC cannot guarantee atomicity.

## Isolation
- Serial transaction execution on sharded databases
- Serializable Snapshot isolation can have serializability checkers in distributed settings as well.
- Two-phase locking can also be configured for distributed systems.

## Database-internal Distributed Transactions
NewSQL: All the participating nodes are part of the same database running the same software.
- Use 2PC to ensure atomicity: Replicate the coordinator and failover using consensus.
## Transactions spanning heterogenous technologies
The participants are two or more technologies.
- Use XA transactions
- it is very sensitive to faults in the coordinator and the application code driving the transaction
### Exactly once semantics
Atomically committing multiple operations, one of which contains message processing.
The operations must be revertible(for eg, sending email is irrevertible).
- An operation takes effect exactly once, even if a crash occurs while it is being processed and the processing needs to be retried.
For a special case where the transaction contains write in database and message processing, the overhead of distributed transaction is not required.
- Recording the message ID in the database makes the message processing _idempotent_, so that message processing can be safely retried without duplicating its side effects.
- Used by Kafka Streams
