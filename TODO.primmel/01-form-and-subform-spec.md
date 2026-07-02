# TODO.primmel 01 — `form` and `subform` spec

**Status:** ACTIVE — implement in `sources/forms/`
**Priority:** HIGH (every compliance system has data-capture forms)
**Depends on:** 02-symbol-registry-spec (form fields reference symbols via calculations)

## Why

MMEL 0.1 has no first-class construct for declarative form schemas. OIML
SMART's `forms/*.yaml` (load-test, humidity-ch, creep-dr, etc.) had to
invent this in YAML because MMEL couldn't express it. Every compliance
system — audit checklists, test reports, inspection records, QC sheets —
has the same structural need.

## What MMEL 0.1 has (closest match)

- `data_registry` — typed record storage. NOT a fillable form schema.
- `class#data` — entity shape. NOT a fillable form schema.
- `measurement` — typed value. NOT a multi-field schema with derivation rules.

## What OIML SMART has

- `forms/*.yaml` — 35+ form schemas with:
  - Field-level type, unit, obligation, measurement_method
  - Calculation bindings (`calculation_bindings: { avgIndication: ... }`)
  - OCL evaluation rules (`evaluation: { rule: "ocl{...}" }`)
  - Applicability scoping (`applicability: { accuracy_class: [...] }`)
  - Pass/fail criteria (`pass_fail: { pass_if: "ocl{...}" }`)
- `subforms/load-test-row.yaml` — parameterized row shape
- `$ref` composition with `${{ param }}` substitution

## Proposed Primmel spec

### Top-level: `form`

```
form <FormID> {
  name "Display name"
  description "..."
  data_class <DataClassID>             // instances of this form persist as DataClassID records
  header <HeaderFormID>                 // optional shared header form
  conformance_process <ProcessID>       // links to the process this form fills
  applicability {                       // when this form applies
    <dimension>: [<values>]
  }

  field <FieldName> : <type> {          // explicit-typed field
    label "..."
    definition "..."
    unit "..."
    required true | false
    measurement_method direct | computed | derived | declared | lookup | evaluated
    calculation <CalculationID>         // optional: invokes named calculation
    calculation_bindings {              // calculation input bindings
      <param>: <field or symbol ref>
    }
    evaluation {                        // optional: pass/fail rule
      rule "ocl{...}"
      condition "human-readable"
    }
    reference { <ReferenceID> }         // optional: traceability
  }

  subform_ref <SubformID> {             // compose a parameterized subform
    parameters {
      <name>: <value>
    }
    applicability { ... }               // call-site applicability
  }

  pass_fail {                            // form-level pass/fail
    criteria "human-readable"
    pass_if "ocl{...}"
  }
}
```

### Top-level: `subform`

```
subform <SubformID> {
  parameters {                           // declared parameters with optional defaults
    <ParamName> : <type> {
      description "..."
      default <value>
      mapping {                          // optional: dimension-driven resolution
        <key>: <value>
      }
    }
  }

  type object | array                    // shape (object for one row, array for many)
  description "..."

  field <FieldName> : <type> { ... }     // same field grammar as form
  // ${{ ParamName }} placeholders in field properties are substituted
  // at composition time
}
```

### Composition: `subform_ref`

When a `form` (or another `subform`) declares `subform_ref <SubformID>`,
the subform's content is **inlined** at the call site with parameters
substituted. The result is semantically equivalent to writing the subform's
fields directly in the parent.

```
form HumidityTest {
  field load_test_before : array {
    subform_ref LoadTestRow {
      parameters { n_runs: 3 }
      applicability { phase: before }
    }
  }
  field load_test_after : array {
    subform_ref LoadTestRow {
      parameters { n_runs: 3 }
      applicability { phase: after }
    }
  }
}
```

After composition:
```
form HumidityTest {
  field load_test_before : array<LoadTestRow_Before> { ... }
  field load_test_after : array<LoadTestRow_After> { ... }
}
// LoadTestRow_Before and LoadTestRow_After are LoadTestRow with n_runs=3 substituted
```

## Spec sections to author

`sources/forms/document.adoc`:
```
= MN 113-7: MMEL Forms and Subforms
:docnumber: 113.7
... (standard header)
include::sections/01-forms-overview.adoc[]
include::sections/02-form-syntax.adoc[]
include::sections/03-field-types.adoc[]
include::sections/04-applicability.adoc[]
include::sections/05-subforms.adoc[]
include::sections/06-parameter-substitution.adoc[]
include::sections/07-composition-rules.adoc[]
include::sections/08-formal-grammar.adoc[]
```

## Section content sketch

### 01 — Forms overview
- Purpose: data-capture schemas with typed fields, derivations, evaluation rules
- Relationship to `data_class`: a form instance persists as a record of `data_class`
- Relationship to `process`: a form fills when a process executes
- Relationship to `measurement`: form fields can reference measurements

### 02 — Form syntax
- Grammar (EBNF)
- `name`, `description`, `data_class`, `header`, `conformance_process`, `applicability`
- Field block
- `pass_fail` block

### 03 — Field types
- Same grammar as `class` fields, plus:
- `measurement_method` (direct, computed, derived, declared, lookup, evaluated)
- `calculation` reference + `calculation_bindings`
- `evaluation` rule + condition

### 04 — Applicability
- Dimension-based scoping
- Multi-dimension constraints (AND)
- Call-site override

### 05 — Subforms
- `subform` block
- Parameters with defaults and mappings
- Composition via `subform_ref`

### 06 — Parameter substitution
- `${{ name }}` syntax
- Whole-string vs inline substitution
- Substitution scope (build-time only; runtime sees resolved values)

### 07 — Composition rules
- Order: parameters resolved first, then inlined, then recursively composed
- Override precedence: call-site wins
- Idempotency: composing the same subform twice produces two independent copies

### 08 — Formal grammar
- EBNF

## Examples to add

`examples/07-forms-and-calculations.mmel` — see TODO 09.

## Validation

- Build cleanly via `bundle exec ruby scripts/build.rb`
- Zero leak count
- Worked example demonstrates: form with inline fields, form with subform_ref, parameter substitution, applicability override

## Out of scope for this section

- The `calculation` and `symbol` constructs (separate sections)
- Runtime evaluation (parser concern, not spec)
- UI rendering (consumer concern, not spec)
