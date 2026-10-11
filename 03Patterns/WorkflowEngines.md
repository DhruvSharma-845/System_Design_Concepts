---
type: pattern
domain: distributed systems
---

# What it is
Workflows are typically defined as a graph of tasks.  
Workflow definitions may be written in 
- a general-purpose programming language, 
- a domain-specific language (DSL), or 
- a markup language such as Business Process Execution Language (BPEL)
Workflows are run, or executed, by a _workflow engine_. Workflow engines determine 
- when and on which machine to run each task, 
- what to do if a task fails (e.g., if the machine crashes while the task is running), 
- how many tasks are allowed to execute in parallel
Workflow engines are typically composed of an orchestrator and an executor: 
- the _orchestrator_ is responsible for scheduling tasks to be executed, and 
- the executor is responsible for executing tasks

# Exactly-once Semantics
Durable execution frameworks are a way to provide _exactly-once semantics_ for workflows. If a task fails, the framework will re-execute the task, but will skip any RPC calls or state changes that the task made successfully before failing. It will pretend to make the call, but will instead return the results from the previous call. This is possible because durable execution frameworks log all RPCs and state changes to durable storage like a write-ahead log