package main

type Relationship struct {
	// e.g., "org_unit:5"
	Subject string `json:"subject"`
	// e.g., "parent"
	Relation string `json:"relation"`
	// e.g., "org_unit:10"
	Object string `json:"object"`
}

// RoleDerivation - A role derivation is a rule that specifies that a role on
// one resource instance automatically means another role on a related resource
// instance.
//
// Suppose we have two kinds of models: Organizational Units and Classrooms.
// Suppose our goal is to allow editors of any Org Unit to implicitly be granted
// editor access on any Classrooms that are a child of that Org Unit. We can do
// this with a Role Derivation.
//
// LIMITATIONS: Can this only span one edge at a time?
// TODO what about 2nd-order derivations? org-prog-site-class
type RoleDerivation struct {
	GrantedTo struct {
		// UsersWithRole - Like a conditional or a logical antecedent.
		UsersWithRole []struct {
			// e.g., "parent"
			LinkedByRelation string `json:"linked_by_relation"`
			// e.g., "org_unit"
			OnResource string `json:"on_resource"`
			// e.g., "editor"
			Role string `json:"role"`
		} `json:"users_with_role"`
	} `json:"granted_to"`

	// Implied — If the conditional is satisfied, these are the permissions that
	// are implicitly granted.
	Implied struct {
		// e.g., "classroom"
		Resource string `json:"resource"`
		// e.g., "editor"
		Role string `json:"role"`
	}
}
