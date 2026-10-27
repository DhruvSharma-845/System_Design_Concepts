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
  - Race Conditions
    - In multi threading on single core, the threads execution is interleaved. If there is a shared data among the threads, writing to it can be in any non-deterministic order and can sometimes produce incorrect results.
    - Protect critical sections