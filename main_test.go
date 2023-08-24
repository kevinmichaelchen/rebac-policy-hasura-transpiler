package main

import (
	"github.com/graphql-go/graphql/language/ast"
	"github.com/graphql-go/graphql/language/parser"
	"github.com/sanity-io/litter"
	"github.com/stretchr/testify/require"
	"testing"
)

func TestParse(t *testing.T) {
	astDoc, err := parser.Parse(parser.ParseParams{
		Source: s,
		Options: parser.ParseOptions{
			// include source, for error reporting
			NoSource: false,
		},
	})
	require.NoError(t, err)

	litter.Dump(astDoc)

	require.Equal(t, "Document", astDoc.Kind)
	require.NotEmpty(t, astDoc.Definitions)

	node0 := astDoc.Definitions[0]
	require.Equal(t, "OperationDefinition", node0.GetKind())

	opDef := node0.(*ast.OperationDefinition)
	require.NotNil(t, opDef)

	ss := opDef.SelectionSet
	require.NotNil(t, ss)

	selections := ss.Selections
	require.NotEmpty(t, selections)

	selection := selections[0]
	field0 := selection.(*ast.Field)
	require.NotNil(t, field0)

	args := field0.Arguments
	require.NotEmpty(t, args)

	arg0 := args[0]
	argValue := arg0.Value
	ov := argValue.(*ast.ObjectValue)

	// IMPORTANT: This is where the magic happens
	// This is what the CLI will transpile to.
	fields := ov.Fields
	require.NotEmpty(t, fields)
}
