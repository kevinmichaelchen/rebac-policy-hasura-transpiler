# Import

The import command is used to ingest policies from policy engines.

## Supported Policy Languages

- [OpenPolicyAgent][opa]'s [Rego][rego] language

### Supported Policy Engines

Several policy engines are supported out of the box, by virtue of the fact that the Rego language is somewhat of a standard.

For example, [Aserto][aserto] supports Rego.

### Future Support

We might consider the following languages in the future.

- [AuthZed][authzed]
- [OpenFGA][open-fga-lang]
- [Ory][ory-permission-lang]

[aserto]: https://docs.aserto.com/docs/overview/policy-lifecycle
[authzed]: https://authzed.com/docs/guides/writing-relationships
[opa]: https://www.openpolicyagent.org/docs/latest/
[open-fga-lang]: https://openfga.dev/docs/configuration-language
[ory-permission-lang]: https://www.ory.sh/what-is-the-ory-permission-language/
[rego]: https://www.openpolicyagent.org/docs/latest/#rego
