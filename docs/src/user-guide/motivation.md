# Motivation

## Hasura Permissions are Hard

This project was born out of a few observations about Hasura's Permission Rules:

- Hasura permissions are **hard to configure**.
  - The amount of JSON quickly proliferates.
  - There aren't any mechanisms to keep the rules DRY (e.g., there are no fragments).
  - The rules need to be replicated to lots of different tables.
- Hasura permissions are **hard to share** with non-technical stakeholders.
  - They're baked into Hasura's YAML metadata.
  - They're JSON that only engineers can understand.
- Hasura permissions are **hard to change**.
  - They're tightly coupled to application code.

## Open Policy Agent: A Panacea

Open Policy Agent addresses a lot of these concerns, by the very act of decoupling policy decision-making from policy enforcement.

It frees the logic behind authorization and entitilements, codifying it in readable language that any stakeholder can read.

> Open Policy Agent (OPA, pronounced "oh-pa") ... provides a high-level declarative language that lets you specify policy as code and simple APIs to offload policy decision-making from your software. You can use OPA to enforce policies in microservices, Kubernetes, CI/CD pipelines, API gateways, and more... OPA decouples policy decision-making from policy enforcement. When your software needs to make policy decisions it queries OPA and supplies structured data (e.g., JSON) as input.

## The End Goal: OPA -> Hasura

How nice would it be if you could just sync your OPA policies straight into Hasura?

That is the dream of this project.

A CLI that you can use to simply import your OPA policies and sync them to your Hasura metadata.
