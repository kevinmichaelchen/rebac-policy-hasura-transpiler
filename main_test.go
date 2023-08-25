package main

import (
	_ "embed"
	"encoding/json"
	"github.com/graphql-go/graphql/language/ast"
	"github.com/graphql-go/graphql/language/parser"
	"github.com/stretchr/testify/require"
	"os"
	"testing"
)

//go:embed test.graphql
var s string

func TestParse(t *testing.T) {
	astDoc, err := parser.Parse(parser.ParseParams{
		Source: s,
		Options: parser.ParseOptions{
			// include source, for error reporting
			NoSource: false,
		},
	})
	require.NoError(t, err)

	//litter.Dump(astDoc)

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

	require.Equal(t, "where", arg0.Name.Value)
	argValue := arg0.Value

	// IMPORTANT: This is where the magic happens
	// This is what the CLI will transpile to: a JSON object.
	ov := argValue.(*ast.ObjectValue)
	ASTToJSON(t, ov)

	fields := ov.Fields
	require.NotEmpty(t, fields)
}

func ASTToJSON(t *testing.T, a ast.Node) interface{} {
	t.Helper()

	// Serialize the AST Node
	b, err := json.Marshal(a)
	require.NoError(t, err)

	err = os.WriteFile("test.json", b, 0644)
	require.NoError(t, err)

	// De-serialize the AST Node
	var f interface{}
	err = json.Unmarshal(b, &f)
	require.NoError(t, err)

	return f
}
