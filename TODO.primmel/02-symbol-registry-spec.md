# TODO.primmel 02 — `symbol` registry spec

**Status:** ACTIVE — implement in `sources/symbols/`
**Priority:** HIGH (foundational for technical/scientific standards)
**Required by:** 03-calculation-registry-spec, 01-form-and-subform-spec

## Why

MMEL 0.1 measurements have implicit symbols (their identifier), but no
formal symbol registry. For technical standards (OIML R 60 has ~50
symbols: `f`, `n_LC`, `Emax`, `MPE`, `C_C`, `C_DR`, `p_LC`, `Y`, `Z`,
`v_min`, etc.), you need:

- Typed symbols (number, integer, string)
- Unit annotations (`counts/v`, `kg`, `v`, `°C`)
- LaTeX rendering for documentation
- Reference traceability to normative source
- Cross-form consistency (the `f` in load-cell-errors.yaml is the same `f`
  in repeatability.yaml)

Without a symbol registry, OCL expressions reference bare identifiers
with no type checking, no unit validation, no rendering hint.

## What MMEL 0.1 has (closest match)

- `variable` (typed as NUMERIC/DATALIST/etc.) — runtime value, not formal symbol
- `measurement` — same; runtime value

## What OIML SMART has

- `symbols.yaml` — 50+ symbols with:
  - `id`, `label`, `unit`, `latex`, `specification_reference`
  - Cross-references from calculations and forms

## Proposed Primmel spec

### Top-level: `symbol`

```
symbol <SymbolID> {
  name "Human-readable name"             // required
  definition "Formal definition"         // optional but recommended
  type number | integer | string | boolean | enum   // required
  unit "counts/v" | "kg" | "1"          // optional (dimensionless = "1")
  latex "<LaTeX rendering>"              // optional, for documentation
  reference { <ReferenceID> }            // optional, traceability
}
```

### Example

```
symbol f {
  name "Conversion factor"
  definition "Ratio of indication change to load change at 75% of Max. Converts counts to verification units (v)."
  type number
  unit "counts/v"
  latex "f"
  reference { R60-3-2-1-2-4 }
}

symbol nLC {
  name "Maximum number of verification intervals"
  type integer
  unit "1"
  latex "n_{LC}"
  reference { R60-1-3-5-8 }
}

symbol MPE {
  name "Maximum permissible error"
  type number
  unit "v"
  latex "MPE"
  reference { R60-1-5-3-2 }
}
```

## Use in OCL expressions

OCL expressions reference symbols by their identifier with square brackets
or bare:

```
validate_measurement {
  "[E_L] <= [MPE]"
  "abs([C_C]) <= 0.7 * abs([MPE])"
}
```

The parser resolves `[E_L]` to the symbol `E_L`, validates its type and
unit, and emits the LaTeX rendering when generating documentation.

## Spec sections to author

`sources/symbols/document.adoc`:
```
= MN 113-8: MMEL Symbol Registry
:docnumber: 113.8
... (standard header)
include::sections/01-symbols-overview.adoc[]
include::sections/02-symbol-syntax.adoc[]
include::sections/03-types-and-units.adoc[]
include::sections/04-latex-rendering.adoc[]
include::sections/05-cross-references.adoc[]
include::sections/06-formal-grammar.adoc[]
```

## Section content sketch

### 01 — Symbols overview
- Purpose: typed, unit-aware formal symbol table
- Relationship to `measurement`: symbols are types; measurements are instances
- Relationship to `calculation`: calculations reference symbols in their
  expressions
- Relationship to OCL: `[X]` resolves to the symbol `X`

### 02 — Symbol syntax
- Grammar
- `name`, `definition`, `type`, `unit`, `latex`, `reference`

### 03 — Types and units
- Allowed types: `number`, `integer`, `string`, `boolean`, `enum`
- Unit conventions (SI-compatible)
- Dimensionless symbols use unit `"1"`

### 04 — LaTeX rendering
- The `latex` field provides rendering hints for documentation generators
- Defaults to the identifier if not specified
- Subscripts use `_{...}`, superscripts use `^{...}`

### 05 — Cross-references
- Symbols link to normative sources via `reference { }`
- A symbol can be defined in multiple references; the canonical one is
  listed first

### 06 — Formal grammar
- EBNF

## Validation

- Build cleanly
- Zero leak count
- Worked example demonstrates: typed symbols, unit annotations, LaTeX,
  cross-references
