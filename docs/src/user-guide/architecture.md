# Architecture

Transpilation works in a few phases:

1. We parse external policies (e.g., written in Rego) and transforms them into an internal structure.
1. We convert that internal structure into a GraphQL AST.
1. We convert that GraphQL AST into JSON for Hasura Permissions Rules.
1. (Future) We sync the JSON into your Hasura metadata.

## Abstract Syntax Trees (ASTs) 🌲

We rely heavily on several libraries to do the heavy lifting around ASTs:

- [GoDoc — OPA AST][godoc-opa-ast]
- [GoDoc — GraphQL AST][godoc-graphql-ast]

## Example

TODO

[godoc-graphql-ast]: https://pkg.go.dev/github.com/graphql-go/graphql/language/ast
[godoc-opa-ast]: https://pkg.go.dev/github.com/open-policy-agent/opa/ast
