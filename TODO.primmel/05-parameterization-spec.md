# TODO.primmel 05 — Parameterization (`${{ param }}` substitution)

**Status:** ACTIVE — formalize in spec, applies to forms/subforms
**Priority:** CROSS (used by 01-form-and-subform-spec)
**Depends on:** 01-form-and-subform-spec (for context)

## Why

OIML SMART discovered that the same dimension flows through the
**requirement → conformance test → test report form** chain. For example,
`accuracy_class` determines MPE tier (R 60-1), procedure count (R 60-2),
and run count (R 60-3). Without parameterization, you get N copies of the
same form (one per value of N) — a DRY violation.

Parameterized subforms collapse N copies into ONE schema with parameters.

## The principle

> The same dimension parameterizes the requirement, the conformance test,
> and the test report form. Parameterization makes the dimension flow
> explicit and the schemas DRY.

## Proposed Primmel spec

### `${{ name }}` placeholder syntax

Placeholders appear in field property values inside `subform` blocks:

```
subform LoadTestRow {
  parameters {
    n_runs : integer {
      mapping {
        A: 5
        B: 5
        C: 3
        D: 3
      }
    }
  }

  type object

  field runs : array<Run> {
    min_items "${{ n_runs }}"          // placeholder
    max_items "${{ n_runs }}"          // placeholder
  }
}
```

### Substitution semantics

1. **Whole-string substitution**: if the entire string value is a single
   placeholder (`"${{ name }}"`), the substituted value retains its
   native type (number stays number, string stays string).

2. **Inline substitution**: if the placeholder appears within a longer
   string (`"n_runs is ${{ n_runs }}"`), the result is a string with the
   placeholder replaced by `String(value)`.

3. **Missing parameter**: if a placeholder references a parameter not in
   scope, the build fails with an error (no silent `${{ }}` left in output).

4. **Recursive**: substitution happens before composition. If a subform
   references another subform with parameters, the outer parameters
   propagate inward.

5. **Build-time only**: substitution happens at parse/composition time.
   The runtime sees fully-resolved values. This keeps the runtime simple.

### Parameter resolution

Parameters can be resolved in three ways:

1. **Literal value at call site**:
   ```
   subform_ref LoadTestRow {
     parameters { n_runs: 3 }
   }
   ```

2. **Mapping from a dimension** (defined in the subform):
   ```
   subform LoadTestRow {
     parameters {
       n_runs : integer {
         mapping { A: 5, B: 5, C: 3, D: 3 }
       }
     }
   }
   ```
   The call site provides the dimension value (e.g., `accuracy_class: A`)
   and the resolver looks up `n_runs` from the mapping.

3. **Default value** (declared in the subform):
   ```
   parameters {
     n_runs : integer {
       default 3
     }
   }
   ```
   Used when neither a literal nor a dimension-derived value is provided.

### Resolution order

1. Call-site literal value (highest precedence)
2. Mapping derived from call-site dimension value
3. Subform default
4. Error (parameter required, no resolution)

## Spec section

This is part of `sources/forms/sections/06-parameter-substitution.adoc`
(see TODO 01). It doesn't need its own top-level part.

## Validation

- Build cleanly
- Zero unresolved `${{ }}` placeholders in output
- Worked example demonstrates: literal, mapping-derived, default, error
  on missing parameter
