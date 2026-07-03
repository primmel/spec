# TODO.primmel 07 — mmel-ts parser extensions for Primmel

**Status:** ✅ DONE — PR https://github.com/metanorma/mmel-ts/pull/2 (commit b3cdbd4) — work in `~/src/mn/mmel-ts/`
**Priority:** HIGH (after TODO 06 completes)
**Depends on:** 06-mmel-ts-spec-parity

## Why

After TODO 06 brings the parser to MMEL 0.1 spec parity, this phase adds
support for the five Primmel extensions: `form`, `subform`, `symbol`,
`calculation`, `state_machine`.

## Work to do

### Step 1 — Add type definitions

Create in `~/src/mn/mmel-ts/packages/mmel/src/types/`:

- `Form.ts` — form schema with fields, subform_refs, pass_fail
- `Subform.ts` — subform with parameters, fields
- `Symbol.ts` — symbol with type, unit, latex
- `Calculation.ts` — calculation with inputs, output, expression
- `StateMachine.ts` — state machine with states, transitions, cascades

Each type extends or composes existing types (DataAttribute for fields,
Reference for traceability, etc.).

### Step 2 — Update Standard.ts

Add the five new top-level collections:

```typescript
export default interface Standard {
  meta: Metadata;
  roles: Role[];
  provisions: Provision[];
  pages: Subprocess[];
  processes: Process[];
  dataclasses: DataClass[];
  regs: Registry[];
  events: EventNode[];
  gateways: Gateway[];
  refs: Reference[];
  approvals: Approval[];
  enums: Enum[];
  vars: Variable[];
  // NEW:
  forms: Form[];
  subforms: Subform[];
  symbols: Symbol[];
  calculations: Calculation[];
  stateMachines: StateMachine[];
  root: Subprocess | null;
}
```

### Step 3 — Add parser entries

For each new construct, add a parser entry in
`~/src/mn/mmel-ts/packages/mmel/src/ser-des/parse.ts`.

The `tokenize` machinery (brace-matching, quote-aware) already handles
the syntax. Each parser entry extracts keyword-specific structure.

### Step 4 — Add parameter substitution pass

New file: `~/src/mn/mmel-ts/packages/mmel/src/ser-des/substitute.ts`.

Walks the parsed model, finds `subform_ref` blocks, resolves them:
1. Looks up the referenced subform
2. Builds the parameter map (literal > mapping-derived > default)
3. Substitutes `${{ name }}` placeholders in the subform's fields
4. Inlines the substituted fields into the parent form
5. Recursively composes (subforms can reference subforms)

The result is a fully-expanded form tree with no `subform_ref` directives
visible to consumers.

### Step 5 — Add resolve entries

For each new construct's cross-references (e.g., form.conformance_process
→ Process, calculation.reference → Reference), add resolve entries in
`~/src/mn/mmel-ts/packages/mmel/src/ser-des/resolve.ts`.

### Step 6 — Add dump entries

For each new construct, add a serializer entry in
`~/src/mn/mmel-ts/packages/mmel/src/ser-des/dump.ts`.

The serializer should emit valid Primmel syntax that re-parses to the
same model. Subforms are emitted as `subform` blocks; subform_refs are
emitted as `subform_ref` blocks (NOT inlined — preserve the source
structure).

### Step 7 — Tests

Add test models in `~/src/mn/mmel-ts/packages/mmel/test/`:

- `forms-basic.mmel` — form with inline fields
- `forms-with-subform.mmel` — form with subform_ref + parameters
- `symbols-and-calculations.mmel` — symbol registry + calculation registry
- `state-machines.mmel` — state machine with cascades
- `parameterization.mmel` — all three parameter resolution modes
- `r60-metrological.mmel` — copy of the OIML SMART example, validates
  end-to-end

For each:
1. Parse → assert no errors
2. Resolve subforms → assert no `$ref` directives remain
3. Dump → assert valid output
4. Round-trip parse → structural equality

### Step 8 — Publish

Bump version to `1.0.0` (Primmel is a new major version). Publish as
`@riboseinc/mmel@1.0.0` or fork to `@primmel/parser@1.0.0`.

## Acceptance criteria

- All 5 new constructs have types, parsers, resolves, dumps
- Substitution pass handles all 3 parameter resolution modes
- Round-trip tests pass for all test models
- R 60 metrological example parses and resolves cleanly

## Effort

~2-3 weeks. The substitution pass is the trickiest part.

## Out of scope

- OCL expression evaluation (consumer concern; OIML SMART has `ocl-js` for this)
- UI rendering (consumer concern)
- Performance optimization beyond what existing tokenize provides
