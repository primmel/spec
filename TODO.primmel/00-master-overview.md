# TODO.primmel 00 — Master Overview

**Status:** ACTIVE — canonical plan for evolving Primmel from MMEL 0.1
**Date:** 2026-07-03
**Scope:** All work needed for Primmel to fully represent OIML SMART's current feature set

## Context

Primmel is the **second generation** of MMEL — the public distribution of the
Multi-Modal Modelling Language. The `MMEL 0.1` schema identifier inside `.mmel`
files and the `Primmel` project name refer to the same DSL.

This plan covers **five language extensions** that bring Primmel from MMEL 0.1
to fully representing OIML R 60 SMART's current capabilities. The extensions
are conceptually general — they benefit every compliance system, not just
OIML.

Companion plan: `~/src/oimlsmart/smart/TODO.UPGRADE/21-primmel-migration.md`
covers the consumer side (OIML SMART adopting Primmel as source format).

## The five extensions

| # | Construct | Purpose | Priority | Effort |
|---|-----------|---------|----------|--------|
| 1 | `form` + `subform` | Declarative data-capture form schemas with parameterized composition | HIGH | M |
| 2 | `symbol` | Typed, unit-aware symbol registry with LaTeX rendering | HIGH | S |
| 3 | `calculation` | Named, type-checked OCL computation primitives | HIGH | S |
| 4 | `state_machine` | Lifecycle with declarative side-effect cascades | MEDIUM | M |
| 5 | parameterization | `${{ param }}` substitution principle formalized | CROSS | S |

## Tooling dependencies

- **`~/src/mn/mmel-ts/`** — existing `@riboseinc/mmel` TS parser. Needs spec parity work (7 missing constructs) AND extension support for the 5 new keywords.
- **`~/src/mn/mmel-models/`** — real-world MMEL models (ISO27001, MDSAP, BS20400, BS44003, HLS, QMS) for parser validation.
- **`~/src/oimlsmart/smart/`** — early adopter; will provide bidirectional converter once parser is ready.

## File index

- [01-form-and-subform-spec.md](01-form-and-subform-spec.md) — spec for `form` and `subform`
- [02-symbol-registry-spec.md](02-symbol-registry-spec.md) — spec for `symbol`
- [03-calculation-registry-spec.md](03-calculation-registry-spec.md) — spec for `calculation`
- [04-state-machine-spec.md](04-state-machine-spec.md) — spec for `state_machine`
- [05-parameterization-spec.md](05-parameterization-spec.md) — `${{ param }}` substitution semantics
- [06-mmel-ts-spec-parity.md](06-mmel-ts-spec-parity.md) — bring parser to spec parity
- [07-primmel-ts-extensions.md](07-primmel-ts-extensions.md) — add new keyword support
- [08-oiml-smart-converter.md](08-oiml-smart-converter.md) — bidirectional YAML↔Primmel
- [09-build-pipeline-updates.md](09-build-pipeline-updates.md) — parts array, deployment

## Architectural principles

The five extensions follow these principles, derived from OIML SMART's
experience:

1. **Single source of truth** — every concept has ONE canonical declaration
2. **Open-closed** — adding new forms/symbols/calculations is data, not code
3. **DRY** — subforms eliminate repetition; parameterization eliminates
   per-dimension copies
4. **MECE** — each construct has a bounded, non-overlapping responsibility
5. **Traceability** — every construct can carry `reference { }` to its
   normative source
6. **Type safety** — symbols and calculations are typed; OCL expressions
   resolve through typed bindings
7. **Composability** — forms compose subforms; subforms compose other
   subforms; calculations reference symbols

## Phase plan

### Phase 1 — Spec extensions (this arc)

| Step | Where | Output |
|------|-------|--------|
| 1.1 | `sources/forms/` | Spec section for `form` + `subform` + parameterization |
| 1.2 | `sources/symbols/` | Spec section for `symbol` |
| 1.3 | `sources/calculations/` | Spec section for `calculation` |
| 1.4 | `sources/state-machines/` | Spec section for `state_machine` |
| 1.5 | `sources/spec/sections/` | Update model structure + file types |
| 1.6 | `scripts/build.rb` | Add new parts to `parts` array |
| 1.7 | `examples/` | Worked example demonstrating all five |

### Phase 2 — Parser parity (next arc, in mmel-ts repo)
Bring `@riboseinc/mmel` to MMEL 0.1 spec parity: add types and parsers for
`note`, `table`, `figure`, `satisfy` blocks, `view_profile`, `link`,
`map_profile`.

### Phase 3 — Parser extensions (next arc, in mmel-ts repo)
Add types and parsers for `form`, `subform`, `symbol`, `calculation`,
`state_machine`. Add the `${{ param }}` substitution pass.

### Phase 4 — Bidirectional converter (in OIML SMART repo)
YAML ↔ Primmel conversion. Round-trip tests.

### Phase 5 — Adoption (in OIML SMART repo)
Migrate `data/oiml-r60/*.yaml` to a canonical `data/oiml-r60/r60.mmel`. YAML
becomes generated output.

## What's NOT in scope

- **Paneron extension** — the Paneron SMART editor extension builds are
  archived in `~/src/mn/mmel-models/Paneron extension/`. Updating them is a
  separate effort.
- **OIML-specific semantics** — lab selection, sample selection, capability
  modeling are operational concerns, not language features. They stay in
  OIML SMART's data layer.
- **PDF generation** — the existing build pipeline emits HTML only.

## Success criteria

1. All five spec sections build cleanly via `bundle exec ruby scripts/build.rb`
2. The worked example `.mmel` file demonstrates all five constructs in one model
3. The build's leak count is zero for each new part
4. Each spec section follows the existing ascidoc structure (General → Syntax → Properties → Examples)
5. No AI attribution in any commit
