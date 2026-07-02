# TODO.primmel 06 — Bring mmel-ts to spec parity

**Status:** ACTIVE — work in `~/src/mn/mmel-ts/`
**Priority:** HIGH (must happen BEFORE parser extensions, TODO 07)
**Independent of:** spec extensions (TODO 01-05)

## Why

The existing `@riboseinc/mmel` parser at `~/src/mn/mmel-ts/packages/mmel/`
is incomplete relative to the current MMEL 0.1 spec. Before we can extend
it for Primmel's new keywords, we need to bring it to spec parity.

## Current state (verified by reading src/types/ and src/ser-des/)

### Supported constructs (types + parser entries)

- `class#data` and `class` (helper)
- `enum`
- `data_registry`
- `reference`
- `provision`
- `role`
- `process`
- `subprocess` + `process_flow`
- `start_event` / `end_event`
- `timer_event`
- `signal_catch_event`
- `exclusive_gateway`
- `approval`
- `variable` (measurement)

### Missing constructs (in spec, not in parser)

| Spec construct | Type file | Parser entry | Notes |
|---|---|---|---|
| `note` | ❌ | ❌ | Spec: `sources/compliance/sections/05-notes.adoc` |
| `table` | ❌ | ❌ | Spec: `sources/measurement/sections/04-table-lookup.adoc` |
| `figure` | ❌ | ❌ | Spec: documentation |
| `satisfy` block on fields | ❌ | ❌ | Spec: `sources/data-model/sections/07-satisfy-blocks.adoc` |
| `view_profile` | ❌ | ❌ | Spec: `sources/measurement/sections/05-view-profiles.adoc` |
| `link` | ❌ | ❌ | Spec: cross-model reference |
| `map_profile` | ❌ | ❌ | Spec: cross-model mapping |
| `parallel_gateway` | ❌ | ❌ | Spec: process model |
| `metadata` extended fields | partial | partial | Spec lists more fields than parser handles |

## Work to do

### Step 1 — Add type definitions

Create one type file per missing construct in
`~/src/mn/mmel-ts/packages/mmel/src/types/`:

- `Note.ts`
- `Table.ts`
- `Figure.ts`
- `ViewProfile.ts`
- `Link.ts`
- `MapProfile.ts`
- `ParallelGateway.ts`

Update `Standard.ts` to include these in the top-level model interface.

### Step 2 — Add parser entries

For each new construct, add a parser entry in
`~/src/mn/mmel-ts/packages/mmel/src/ser-des/parse.ts`'s
`ParserConfiguration`. Reuse the existing tokenize/brace-matching machinery.

### Step 3 — Add resolve entries

For each new construct that has references to other constructs, add a
resolve pass in `~/src/mn/mmel-ts/packages/mmel/src/ser-des/resolve.ts`.

### Step 4 — Add dump entries

For each new construct, add a serializer entry in
`~/src/mn/mmel-ts/packages/mmel/src/ser-des/dump.ts`.

### Step 5 — Tests

Use the existing MMEL models in `~/src/mn/mmel-models/` (ISO27001,
MDSAP, BS20400, BS44003, HLS, QMS) to validate round-trip parsing.

For each model:
1. Parse the `.mmel` file
2. Dump back to a string
3. Parse again
4. Assert the two parsed models are structurally equal

### Step 6 — Publish

Bump version to `0.2.0` and publish `@riboseinc/mmel`.

## Acceptance criteria

- All 7 missing constructs have types, parsers, resolves, dumps
- Round-trip tests pass for all 6 models in mmel-models
- Version bumped to 0.2.0
- README updated to document new constructs

## Effort

~1-2 weeks of focused work. Mechanical; no design decisions.

## Out of scope

- Primmel extensions (TODO 07) — separate, after this completes
- Performance optimization — current parser is fine for these model sizes
- Documentation rendering — that's the spec repo's job
