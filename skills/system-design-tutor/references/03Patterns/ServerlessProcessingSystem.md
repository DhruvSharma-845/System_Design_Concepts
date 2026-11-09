---
title: "Serverless Processing System"
type: pattern
domain: [distributed-systems, data-processing]
tags: [serverless, dynamic-provisioning, autoscaling, event-driven, pay-per-use]
summary: "On-demand serverless compute that dynamically scales with incoming requests and avoids statically provisioning application infrastructure."
use_when:
  - "Handling bursty or unpredictable request traffic"
  - "Scaling processing capacity automatically with demand"
  - "Reducing operational work for managing compute infrastructure"
related:
  - "01Foundation/BatchProcessing.md"
  - "01Foundation/StreamProcessing.md"
  - "03Patterns/WorkflowEngines.md"
status: partial
---

# What it is

Traditionally, cloud applications have been deployed on an infrastructure as a service (IaaS) platform utilizing virtual machines (VMs). In this case, you pay for the resources you deploy regardless of how highly utilized they are.  
**Static Provisioning:** Your costs are essentially proportional to the type of VMs you choose, the duration they are deployed for.  
**Dynamic Provisioning**: Serverless does not require any compute resources to be statically provisioned. The application code is loaded and executed on demand, when requests arrive. If there are no active requests, there are essentially no resources in use and no charges to meet.  
They eliminate many of the deployment complexities associated with managing and updating clusters of explicitly allocated virtual machines
# Where it is needed
- Traffic Spikes

# Auto scaling
As simultaneous requests arrive, additional processing capacity is created to handle requests and, ideally, provide consistently low response times. When request loads drop, additional processing capacity is decommissioned, and no charges are incurred.
