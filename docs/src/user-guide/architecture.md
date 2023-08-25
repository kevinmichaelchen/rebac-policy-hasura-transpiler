# Architecture

Transpilation works in a few phases:

1. We parse external policies (e.g., written in Rego) and transforms them into an internal structure.
1. We convert that internal structure into a GraphQL AST.
1. We convert that GraphQL AST into JSON for Hasura Permissions Rules.
1. (Future) We sync the JSON into your Hasura metadata.


```d2
direction: right

rego: {
  policy: Policy
  ast: AST
}
graphql-ast: GraphQL AST
hasura-permissions-json: Hasura Permissions JSON

rego.policy -> rego.ast
rego.ast -> graphql-ast: enrich
graphql-ast -> hasura-permissions-json
```

## Abstract Syntax Trees (ASTs) 🌲

We rely heavily on several libraries to do the heavy lifting around ASTs:

- [GoDoc — open-policy-agent/opa/ast][godoc-opa-ast]
- [GoDoc — graphql-go/graphql/language/ast][godoc-graphql-ast]

[godoc-graphql-ast]: https://pkg.go.dev/github.com/graphql-go/graphql/language/ast
[godoc-opa-ast]: https://pkg.go.dev/github.com/open-policy-agent/opa/ast

## Example OPA Policy Evaluation

OPA policies are expressed in the [Rego][rego] Policy Language, a high-level declarative language purpose-built for expressing policies over complex hierarchical data structures.

Before we can evaluate a policy, we first need some data to evaluate it against!

### Data

Here's some example data:

```json
{
  "orgUnits": [
    {"id": 1, "name": "US Dept of Education"},
    {"id": 2, "name": "NY State DoE", "parent": 1},
    {"id": 3, "name": "NYC Public Schools", "parent": 2},
    {"id": 4, "name": "NYC PS 46", "parent": 3},
    {"id": 5, "name": "NYC PS 99", "parent": 3}
  ],
  "classrooms": [
    {"id": 1, "orgUnitID": 4, "name": "1st Period"},
    {"id": 2, "orgUnitID": 4, "name": "2nd Period"},
    {"id": 3, "orgUnitID": 5, "name": "1st Period"},
    {"id": 4, "orgUnitID": 5, "name": "2nd Period"}
  ],
  "teachers": [
    {"id": 1, "orgUnitID": 4, "name": "Alice"},
    {"id": 2, "orgUnitID": 4, "name": "Bob"},
    {"id": 3, "orgUnitID": 5, "name": "Celeste"},
    {"id": 4, "orgUnitID": 5, "name": "Diego"}
  ],
  "teacherClassrooms": [
    {"teacherID": 1, "classroomID": 1},
    {"teacherID": 2, "classroomID": 2},
    {"teacherID": 3, "classroomID": 3},
    {"teacherID": 4, "classroomID": 4}
  ]
}
```

In this example, we're keeping the JSON data as normalized as our database. OPA allows nesting, so we could nest the `teachers` array under `classrooms`... but that would diverge from our Hasura schema — which is ultimately what we want to map to!

### Policy

Let's suppose we need to implement some new authorization rules:

- Teachers should only have write access to classrooms they teach.
- Teachers should only have read access to classrooms in their school.
- Teachers should only have read access to _terminal_ org units which oversee classrooms they teach.
  - A _terminal_ org unit is one with no subordinate org units ("no child org units").

#### Modifying classrooms

**A teacher should only be able to modify their own classrooms.**

We can model this specific rule / policy with the following Rego:

```rego
package classroom_write_access

default allow = false

classroom_teacher[teacher_id] {
    teacherClassrooms[tc]
    tc.teacherID == teacher_id
}

allow {
    input.action == "modify"
    input.resource.type == "classrooms"
    input.teacher_id == input.resource.teacher_id
    classroom_teacher[input.teacher_id]
}
```

#### Reading other classrooms

**A teacher should only be able to read data about classrooms that they either directly teach, or that belong their school.**

```rego
package classroom_read_access

default allow = false

classroom_belongs_to_teacher_classroom(classroomID, teacherID) {
    teacherClassrooms[tc]
    tc.teacherID == teacherID
    tc.classroomID == classroomID
}

classroom_belongs_to_teacher_org_unit(classroomID, teacherID) {
    classroom_belongs_to_teacher_classroom(classroomID, teacherID)
    classrooms[classroom]
    classroom.id == classroomID
    orgUnits[ou]
    ou.id == classroom.orgUnitID
    teaches_in_classroom[teacherID][classroom.id]
}

teaches_in_classroom[teacherID] = {classroomID | classroom_belongs_to_teacher_classroom(classroomID, teacherID)}

teaches_in_org_unit[teacherID] = {classroomID | classroom_belongs_to_teacher_org_unit(classroomID, teacherID)}

allow {
    input.action == "read"
    input.resource.type == "classrooms"
    input.teacher_id == input.resource.teacher_id
    (classroom_belongs_to_teacher_classroom(input.resource.id, input.teacher_id) or
    classroom_belongs_to_teacher_org_unit(input.resource.id, input.teacher_id))
}
```

#### Reading org units

**A teacher should only be able to read data about schools to which their classrooms belong.**

```rego
package org_unit_read_access

default allow = false

direct_parent(orgUnitID, parentID) {
    orgUnits[parent]
    parent.id == parentID
    orgUnitID == parent.parent
}

teaches_in_classroom(teacherID, classroomID) {
    teacherClassrooms[tc]
    tc.teacherID == teacherID
    classrooms[classroom]
    tc.classroomID == classroom.id
    classroom.orgUnitID == orgUnitID
}

allow {
    input.action == "read"
    input.resource.type == "orgUnits"
    input.teacher_id == input.resource.teacher_id
    teaches_in_classroom[input.teacher_id][input.resource.id]
    orgUnits[ou]
    ou.id == input.resource.id
    direct_parent(ou.id, classroom.orgUnitID)
}
```

[rego]: https://www.openpolicyagent.org/docs/latest/policy-language/
