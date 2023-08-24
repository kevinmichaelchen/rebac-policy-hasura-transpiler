package main

import (
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
}
