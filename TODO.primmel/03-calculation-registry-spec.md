# TODO.primmel 03 — `calculation` registry spec

**Status:** ACTIVE — implement in `sources/calculations/`
**Priority:** HIGH (needed by `form` for field derivations)
**Depends on:** 02-symbol-registry-spec (calculations reference symbols)

## Why

MMEL 0.1's `validate_measurement` expressions are inline strings with no
type checking. For any standard with non-trivial calculations (OIML R 60
has ~30: load cell error, repeatability, creep, DR, humidity effects,
temperature effects), you need named, type-checked, referenceable
calculation primitives.

The `validate_measurement` shorthand isn't enough because:
1. No input/output typing
2. No named reference (forms repeat the same formula in 4 places)
3. No reference traceability to the source standard's formula

## What MMEL 0.1 has (closest match)

- `measurement DERIVED` with a `definition` string — untyped, unparameterized
- `validate_measurement` expression strings — inline, not named

## What OIML SMART has

- `calculations.yaml` — 30+ named calculations with:
  - Inputs and outputs (typed)
  - OCL expression
  - Reference to source formula
- `formulas.yaml` — engine-facing JS expressions (compiled from calculations)

## Proposed Primmel spec

### Top-level: `calculation`

```
calculation <CalculationID> {
  name "Display name"
  description "..."
  inputs {
    <param> : <type> {
      unit "..."
      description "..."
    }
  }
  output : <type> {
    unit "..."
  }
  expression "ocl{...}"                  // OCL expression, references inputs by name
  reference { <ReferenceID> }            // traceability to source formula
}
```

### Example

```
calculation loadCellError {
  name "Load cell error"
  description "Signed difference between observed and reference indication, divided by conversion factor."
  inputs {
    avgIndication : number { unit "counts" }
    referenceIndication : number { unit "counts" }
    conversionFactor : number { unit "counts/v" }
  }
  output : number { unit "v" }
  expression "ocl{(avgIndication - referenceIndication) / conversionFactor}"
  reference { R60-3-2-1-2-2 }
}

calculation mean {
  name "Arithmetic mean"
  description "Mean of a list of values."
  inputs {
    values : list<number> { unit "1" }
  }
  output : number { unit "1" }
  expression "ocl{values->sum() / values->size()}"
}

calculation repeatabilityError {
  name "Repeatability error"
  description "Max - min of a list of values."
  inputs {
    values : list<number> { unit "1" }
  }
  output : number { unit "1" }
  expression "ocl{values->max() - values->min()}"
}
```

## Use in forms

Form fields reference calculations by name with bindings:

```
form LoadTest {
  field average_indication : number {
    calculation mean
    calculation_bindings {
      values: runs.indication    // path expression
    }
  }
  field error_EL : number {
    calculation loadCellError
    calculation_bindings {
      avgIndication: average_indication
      referenceIndication: reference_indication
      conversionFactor: f
    }
  }
}
```

The parser:
1. Looks up the calculation by name
2. Validates the bindings match the calculation's inputs (by name)
3. Validates units are compatible (binding unit == input unit, allowing
   dimensionless coercion)
4. The output type and unit become the field's type and unit

## Spec sections to author

`sources/calculations/document.adoc`:
```
= MN 113-9: MMEL Calculation Registry
:docnumber: 113.9
... (standard header)
include::sections/01-calculations-overview.adoc[]
include::sections/02-calculation-syntax.adoc[]
include::sections/03-inputs-and-outputs.adoc[]
include::sections/04-ocl-expressions.adoc[]
include::sections/05-binding-resolution.adoc[]
include::sections/06-formal-grammar.adoc[]
```

## Section content sketch

### 01 — Calculations overview
- Purpose: named, type-checked OCL computation primitives
- Relationship to `symbol`: calculations reference symbols in expressions
- Relationship to `form`: forms invoke calculations via field.calculation
- Relationship to `validate_measurement`: validate_measurement can be
  expressed as an inline anonymous calculation

### 02 — Calculation syntax
- Grammar
- `name`, `description`, `inputs`, `output`, `expression`, `reference`

### 03 — Inputs and outputs
- Typed parameters
- Unit annotations (must match symbol units when bound)
- Default values (optional)

### 04 — OCL expressions
- Subset of OCL supported (let parser define)
- Path expressions (`runs.indication`, `temperature_readings->first().value`)
- Quantifiers (`forAll`, `exists`, `collect`, `select`, `reject`)
- Aggregates (`sum`, `mean`, `min`, `max`, `count`, `size`)

### 05 — Binding resolution
- Call-site bindings map calculation inputs to form fields or sub-paths
- Type checking: bound field's type must match calculation input's type
- Unit checking: bound field's unit must match calculation input's unit
- Sub-path resolution: `runs.indication` means "the indication field of
  each item in the runs array"

### 06 — Formal grammar
- EBNF

## Built-in library

Primmel should ship with a standard calculation library (defined in
`examples/` as `.mmel` files, available to all models by default):

- `mean(list<number>) → number`
- `sum(list<number>) → number`
- `min(list<number>) → number`
- `max(list<number>) → number`
- `count(list<T>) → integer`
- `abs(number) → number`
- `sqrt(number) → number`
- `every(list<boolean>) → boolean`
- `some(list<boolean>) → boolean`

These are referenced by OCL operators (`->sum()`, `->max()`, etc.) and
don't need explicit import.

## Validation

- Build cleanly
- Zero leak count
- Worked example demonstrates: typed inputs/outputs, unit checking,
  reference traceability, binding resolution from a form
