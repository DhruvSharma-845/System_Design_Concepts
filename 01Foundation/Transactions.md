---
type: concept
domain: storage
summary: ACID guarantees on single-node and distributed systems
---
# Single Node Transactions
A _transaction_ is a set of operations, an atomic unit of execution.
## ACID Guarantees
- Atomicity
	- All results of the transaction become visible or none of them do.
	- Rollback if the transaction cannot complete
- Consistency
- Isolation
	- Serializability: When the order of execution of operations of transactions is equivalent to sequential execution of the transactions.
	- Implementation Approaches
		- Lock-based(pessimistic)
		- Try and validate(optimistic)
		- Snapshot Isolation
			- Snapshot isolation guarantees that all reads made within the transaction are consistent with a snapshot of the database.
			- The snapshot contains all values that were _committed before_ the transaction’s start timestamp.
			- If there’s a _write-write conflict_ (i.e., when two concurrently running transactions attempt to make a write to the same cell), only one of them will commit.
			- Prevents read skew: In between the transaction, cannot see the updated values by some other concurrent committed transaction. can only see the snapshot of the database.
- Durability
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
