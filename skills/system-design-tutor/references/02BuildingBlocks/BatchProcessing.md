---
title: "Batch Processing"
type: building_block
domain: [data-processing]
tags: [mapreduce, spark, derived-data, offline, scheduling]
summary: "Offline processing of bounded, immutable input into derived data, as in MapReduce or Spark, and workflow scheduling."
use_when:
  - "Periodic large-scale data processing"
  - "Building derived datasets, ETL, or analytics"
related:
  - "02BuildingBlocks/StreamProcessing.md"
  - "03Patterns/WorkflowEngines.md"
status: partial
---

# What it is
A batch processing job takes input data (which is read-only, immutable) and produces output data.
- The output is a form of _derived data_; that is, a dataset that can be re-created by running the batch process again
- heavily influenced by MapReduce
- nowadays, done using frameworks such as Spark or Flink

It provides a strong reliability guarantee. Failed tasks are automatically retried, and partial output from failed tasks is automatically discarded

# Where it is needed
- The input is bounded so that the batch process knows when it has finished reading its input and start processing.

# Batch Processing in Distributed System
When the data is too large to fit in memory or on disk.

## Components of Distributed Batch Process
- Distributed File System
	- Files are broken into blocks, which are distributed across many machines.
	- Blocks are read by making network requests to a machine in the cluster that stores the block.
	- Distributed filesystems also need a way to track file locations spread across machines, permission settings, and so on
- Object Stores
	- Alternative to distributed filesystems
	- object stores are generally optimized for large objects (megabytes to gigabytes) and less frequent, larger reads
- Job Orchestration
	- Batch processing frameworks send a request to an orchestrator’s scheduler to run a job.
	- Task Executor: Executors are responsible for running job tasks, sending heartbeats to signal their liveness, and tracking task status and resource allocation on the node
	- Resource Manager: resource manager stores metadata about each node, including available hardware (CPUs, GPUs, memory, disks, and so on), task statuses, network location, node status, and other relevant information.
	- Scheduler: receives requests to start, stop, or check on the status of a job. The scheduler uses the information from the request and the state of the resource manager to determine which tasks to run on which nodes. They must figure out how to optimally allocate the cluster’s limited resources among jobs with competing needs.
- 
# Scheduling Workflows 
Often the output from one job needs to become the input to one or more other jobs, and each job may have several inputs that are produced by other jobs. This is called a _workflow_ or _directed acyclic graph_ (DAG) of jobs. 
It is more typical for one job in a workflow to write its output to a distributed filesystem or object store and for the next job to read it from there. This decouples the jobs from each other, allowing them to run at different times.
