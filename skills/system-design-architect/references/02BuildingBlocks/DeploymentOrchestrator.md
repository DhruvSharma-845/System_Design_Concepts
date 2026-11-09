---
title: "Kubernetes Deployment Orchestrator"
type: building_block
domain: [distributed-systems]
tags: [kubernetes, containers, deployment, orchestration, self-healing]
summary: "Using Kubernetes to deploy, scale, and maintain containerized applications through declarative configuration and controllers."
use_when:
  - "Deploying and scaling containerized applications"
  - "Automating recovery and desired-state management across a cluster"
  - "Improving infrastructure portability and resource utilization"
related:
  - "04Architectures/Microservices.md"
  - "02BuildingBlocks/LoadBalancer.md"
status: partial
---
# Kubernetes
Kubernetes is an open source orchestrator for deploying containerized applications. It provides the software necessary to successfully build and deploy reliable, scalable distributed systems.

## When to use
- Development velocity
	- Velocity is measured not in terms of the raw number of features you can ship per hour or day, but rather in terms of the number of things you can ship while maintaining a highly available service
	- Containers and Kubernetes can provide the tools that you need to move quickly, while staying available.
	- **Immutability**: With _immutable_ infrastructure, once an artifact is created in the system, it does not change via user modifications. Rather than a series of incremental updates and changes, an entirely new, complete image is built, where the update simply replaces the entire image with the newer image in a single operation.
	- **Declarative Configuration**: Everything in Kubernetes is a _declarative configuration object_ that represents the desired state of the system. It is the job of Kubernetes to ensure that the actual state of the world matches this desired state. The idea of storing declarative configuration in source control is often referred to as “infrastructure as code.”
	- **Self Healing**: _Continuously_ takes actions to ensure that the current state matches the desired state. This means that not only will Kubernetes initialize your system, but it will guard it against any failures or perturbations that might destabilize the system and affect reliability.
- Scaling (of both software and teams)
	- Decoupling components via load balancers makes it easy to scale
	- Decoupling servers via APIs makes it easier to scale the development teams because each team can focus on a single, smaller _microservice_ with a comprehensible surface area
	- Because your containers are immutable, and the number of replicas is merely a number in a declarative config, scaling your service upward is simply a matter of changing a number in a configuration file
- Abstracting your infrastructure
	- Portable: When you build your applications in terms of container images and deploy them in terms of portable Kubernetes APIs, transferring your application between environments, or even running in hybrid environments, is simply a matter of sending the declarative config to a new cluster
- Efficiency
	- Applications can be colocated on the same machines without impacting the applications themselves. This means that tasks from multiple users can be packed tightly onto fewer machines.
	- Kubernetes provides tools that automate the distribution of applications across a cluster of machines, ensuring higher levels of utilization than are possible with traditional tooling.
- Cloud native ecosystem

## Operators
 With operators, more advanced logic needed to maintain, scale, and heal a specific piece of software is encoded into an operator application that runs as a container in the cluster. The code in the operator is responsible for more targeted and advanced health detection and healing than can be achieved via Kubernetes’s generic self-healing.
