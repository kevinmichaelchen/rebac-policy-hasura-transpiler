# rebac-policy-hasura-transpiler

A CLI to transpile [ReBAC][rebac] policies to JSON for Hasura Permissions Rules.

The policies themselves are inspired by [permit.io][permit-io]'s API.

## Motivation

This project may interest you if:

- you're using Hasura;
- you've got lots of interconnected tables;
- your authorization logic is complex; and
- you want a way to derive your Hasura [Permissions Rules JSON][hasura-perms]
  from a dedicated entitlements system

## Considerations

### Arbitrary Nesting

In Permit's [API][permit-api], you can seemingly self-referential _role
derivations_ that span an indefinite number of edges in the graph.

#### Imaginary Domain

Imagine you're building an LDAP system for school districts, and you've got a
few kinds of models: Users, Organizational Units (which can be nested) and
Classrooms.

With the Permit API, you can give the following grant to any users with the
`editor` role on an Org Unit, thereby causing editor privileges to trickle down
the Org Unit tree, all the way to the leaves.

```json
{
  "granted_to": {
    "users_with_role": [
      {
        "linked_by_relation": "parent",
        "on_resource": "org_unit",
        "role": "editor"
      }
    ]
  }
}
```

#### The Problem

The problem is that the JSON in Hasura's Permissions Rules has no way to express
this kind of indefinite, arbitrarily long path length.

While not a perfect solution, this CLI lets you specify the number of levels
that the Hasura rules should traverse.

[hasura-perms]: https://hasura.io/docs/latest/auth/authorization/permissions/
[permit-io]: https://permit.io
[permit-api]:
  https://docs.permit.io/modeling/google-drive#foldereditor---fileeditor-via-parent
[rebac]: https://en.wikipedia.org/wiki/Relationship-based_access_control