---
type: concept
domain: storage
summary: ACID guarantees on single-node and distributed systems
---
# Single Node Transactions
A _transaction_ is a set of operations as indivisible logical unit of work, working as an atomic unit of execution.
- To improve efficiency, we need to allow concurrent transaction execution.
- To preserve correctness, we have to ensure that concurrently executing transactions preserve ACID properties
## ACID Guarantees
- Atomicity
	- All results of the transaction execute successfully and become visible or none of them do.
	- Rollback if the transaction cannot complete
	- The _log manager_ holds a history of operations (log entries) applied to cached pages but not yet synchronized with persistent storage to guarantee they won’t be lost in case of a crash. 
	- In other words, the log is used to reapply these operations and reconstruct the cached state during startup. 
	- Log entries can also be used to undo changes done by the aborted transactions.
- Consistency
	- a transaction should only bring the database from one valid state to another valid state, maintaining all database invariants (such as constraints, referential integrity, and others)
- Isolation
	- Multiple concurrently executing transactions should be able to run without interference, as if there were no other transactions executing at the same time 
	- In realilty, many databases use isolation levels that are weaker
	- The transaction manager coordinates and schedules the transactions.
	- The _lock manager_ guards access to these resources and prevents concurrent accesses that would violate data integrity
	- Schedules:
		- A _schedule_ is a list of operations required to execute a set of transactions from the database-system perspective
		- A schedule is said to be _serial_ when transactions in it are executed completely independently and without any interleaving. Prevents concurrency.
		- Serializability: When the order of execution of operations of transactions is equivalent to sequential(serial) execution of the transactions. Ensures concurrency as well as correctness. It produces the same result as if we executed a set of transactions one after another in _some_ order.
- Durability
	- Once a transaction has been committed, all database state modifications have to be persisted on disk and be able to survive power outages, system failures, and crashes

## Atomicity
- Commit Log
	- A _write-ahead log_ is an append-only auxiliary disk-resident structure used for crash and transaction recovery.
	- Until the cached contents are flushed back to disk, the only disk-resident copy preserving the operation history is stored in the WAL.
	- Allow lost in-memory changes to be reconstructed from the operation log in case of a crash. The pre-crash database state is fully restored.
	- Checkpoints are a way for a log to know that log records up to a certain mark are fully persisted and aren’t required anymore.
## Isolation
### Isolation Issues if we allow multiple transactions to execute without coordination
- Dirty Read: a transaction can read uncommitted changes from other transactions
- Non-repeatable read: transaction queries the _same row_ twice and gets different results
- Phantom Read: A _phantom read_ is when a transaction queries the same _set of rows_ twice and receives different results
- Lost Update: when transactions `T1` and `T2` both attempt to update the value of `V`, the results of `T1` might be overwritten by the results of `T2`
- Dirty Write: one of the transactions takes an uncommitted value (i.e., dirty read), modifies it, and saves it.
- Write Skew: each individual transaction respects the required invariants, but their combination does not satisfy these invariants.
To prevent isolation issues, additional coordination is required which negatively impacts the performance.
### Isolation Levels
Isolation level describe the degree to which transactions are isolated from other concurrently executing transactions.  
- Read uncommitted: the transactional system allows one transaction to observe uncommitted changes of other concurrent transactions. Dirty Reads are allowed.
- Read committed: dirty reads are not permitted, but phantom and nonrepeatable reads are. If there was a committed modification between two reads, two queries in the same transaction would yield different results.
- Repeatable Read: If we further disallow nonrepeatable reads in Read Committed, we get a repeatable read isolation level.
- Serializable:  transaction outcomes will appear in _some_ order as if transactions were executed _serially_. It does not impose any ordering constraint(like in linearizability)
- Snapshot Isolation
	- Snapshot isolation guarantees that all reads made within the transaction are consistent with a snapshot of the database.
	- The snapshot contains all values and transactions that were _committed before_ the transaction’s start timestamp.
	- If there’s a _write-write conflict_ (i.e., when two concurrently running transactions attempt to make a write to the same cell), only one of them will commit. The others are aborted and rolled back.
	- Prevents read skew: In between the transaction, cannot see the updated values by some other concurrent committed transaction. can only see the snapshot of the database.
	- Prevents lost update: Whichever transaction attempts to commit first, will commit, and the other one will have to abort.
### Concurrency Control Mechanisms
- pessimistic - Lock-free
	- determine transaction conflicts while they’re running and block or abort their execution.
	- each transaction has a timestamp
	- To implement that, the transaction manager has to maintain `max_read_timestamp` and `max_write_timestamp` per value, describing read and write operations executed by concurrent transactions.
	- _Read_ operations that attempt to read a value with a timestamp lower than `max_write_timestamp` cause the transaction they belong to be aborted, since there’s already a newer value
	- _write_ operations with a timestamp lower than `max_read_timestamp`would conflict with a more recent read. However, _write_ operations with a timestamp lower than `max_write_timestamp` are allowed,
	- Aborted transactions restart with a _new_ timestamp
- Pessimistic - Lock-based  
	- Transactions to maintain locks on database records to prevent other transactions from modifying locked records and assessing records that are being modified until the transaction releases its locks.
	- Two-phase locking
		- The _growing phase_ (also called the _expanding phase_), during which all locks required by the transaction are acquired and no locks are released.
		- The _shrinking phase_, during which all locks acquired during the growing phase are released.
		- a transaction cannot acquire any locks as soon as it has released at least one of them.
		- Deadlock: A situation may occur when two transactions, while attempting to acquire locks they require in order to proceed with execution, end up waiting for each other to release the other locks they hold. The solution is to introduce timeouts and abort long-running transactions under the assumption that they might be in a deadlock
- Try and validate(optimistic)
	- Allows transactions to execute concurrent read and write operations, and determines whether or not the result of the combined execution is serializable before committing their results.
	- The transactions maintain histories of their operations, and check these histories for possible read/write conflicts before commit. If execution results in a conflict, one of the conflicting transactions is aborted
- Multiversion
	- Guarantees a consistent view of the database at some point in the past.
	- allow multiple timestamped versions of the record to be present.
	- reads can continue accessing older values until the new ones are committed.
	- It is used for implementing snapshot isolation.

# Distributed Transactions
## Atomicity 
Changes have to be durably propagated to all of the nodes involved in the transaction or none of them.

## Atomic Commitment algorithms
Atomic commitment doesn’t allow disagreements between the participants: a transaction _will not_ commit if even one of the participants votes against it.
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
- **Cohort failure**: If one of the cohort fails, the coordinator stops the transaction. If the node fails in phase 2, it has to learn the actual outcome of the vote before it can server clients. The coordinator shares the decision with the failed participants.
- **Coordinator failure**: If the coordinator fails in the second phase and does not share the decision, the participant can ask the peers about the decision. If the coordinator fails just after the first phase, all participants are blocked.
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
