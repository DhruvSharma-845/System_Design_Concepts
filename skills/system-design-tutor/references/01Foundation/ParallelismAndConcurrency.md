---
title: "Parallelism and Concurrency"
type: concept
domain: [distributed-systems]
tags: [parallelism, concurrency, threads, processes, race-conditions, locks, deadlocks, thread-pools]
summary: "Single-node concurrency using processes and threads: resource utilization, coordination, race conditions, locks, deadlocks, and thread pools."
use_when:
  - "Improving request throughput or resource utilization with concurrent execution"
  - "Coordinating threads and protecting shared state"
related:
  - "01Foundation/Scalability.md"
  - "01Foundation/Transactions.md"
  - "04Architectures/MonolithArchitecture.md"
status: partial
---

# What it is
Executing multiple pieces of code parallely or concurrently on multiple processing nodes.

# Single node Concurrency

## Motivation
Optimization of resource utilization so as to increase processing capability.

## Why concurrency
A long running request can make other requests starve for processing.  
The requests should be processed in overlapping manner.  
When a process is busy waiting for I/O operations or data to be available, other process can run.  
With a multicore chip, the software that has been structured for parallel activities can be executed concurrently on multiple cores.  

## Concurrency Mechanisms
- Process
- Thread
  - Every process has single thread of execution by default.
  - The thread has access to resources and process's environment. 
  - It has its own stack to manage method calls.
  - Multi-threading
    - Non-deterministic order of execution
    - Preemption: Once a scheduler gives the thread an execution time slot, it can interrupt the thread after time slot and schedule another one.
  - Threads Coordination
    - Using joins: It causes the calling thread to block until the other threads terminate.
    - Using guarded blocks: Guarded blocks use a condition as a guard that must hold before the thread resumes the execution. wait() and notify() are its examples.
  - Race Conditions
    - In multi threading on single core, the threads execution is interleaved. If there is a shared data among the threads, writing to it can be in any non-deterministic order and can sometimes produce incorrect results.
    - Protect critical sections: It is a section of code that updates shared data and hence, must be executed atomically. When multiple threads want to update the shared data, only one thread is permitted to enter critical section and all other threads block. It can be implemented through locks
    - Acquiring locks in different order by multiple processes can lead to deadlock where all threads are blocked on each other for acquisition of lock.
  - Thread pools
    - Helps in efficient utilization of resources and limits the overconsumption of resources in the absence of thread pool.