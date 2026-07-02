# TODO.primmel 08 — OIML SMART bidirectional converter

**Status:** ACTIVE — work in `~/src/oimlsmart/smart/browser/build/`
**Priority:** MEDIUM (after TODO 06+07 complete)
**Depends on:** 07-primmel-ts-extensions

## Why

Once Primmel can express our full feature set, we need a bidirectional
converter between our YAML representation and Primmel `.mmel` files.
This enables:

1. **Source-of-truth migration** — author in Primmel, generate YAML
2. **Backward compat** — read existing YAML, emit Primmel for external use
3. **Round-trip safety** — verify no information is lost in either direction

## Work to do

### Step 1 — Create converter modules

In `~/src/oimlsmart/smart/browser/build/`:

- `primmel-converter.ts` — reads `.mmel`, emits our YAML
- `yaml-to-primmel.ts` — reads our YAML, emits `.mmel`
- `primmel-roundtrip.test.ts` — round-trip tests

### Step 2 — YAML → Primmel conversion

For each YAML file, emit the corresponding Primmel construct:

| YAML file | Primmel construct |
|---|---|
| `data-classes.yaml` | `class#data` / `class` blocks |
| `entity-relationships.yaml` | (implicit via field types) |
| `state-machines.yaml` | `state_machine` blocks |
| `requirements/*.yaml` | `provision` blocks |
| `conformance/*.yaml` | `process` blocks with `validate_provision` |
| `forms/*.yaml` | `form` blocks |
| `subforms/*.yaml` | `subform` blocks |
| `symbols.yaml` | `symbol` blocks |
| `calculations.yaml` | `calculation` blocks |
| `formulas.yaml` | (folded into `calculation` expressions) |
| `tables.yaml` | `table` blocks |
| `value-model.yaml` | `table` + `TABLE_REFERENCE` |
| `enums.yaml` | `enum` blocks |
| `terminology/*.yaml` | `terminology` section |
| `references/*.yaml` | `reference` blocks |
| `notes/*.yaml` | `note` blocks |
| `roles.yaml` | `role` blocks |
| `workflow.yaml` | `subprocess` with `process_flow` |
| `processes.yaml` | `process` (if separate from workflow) |
| `gateways.yaml` | `exclusive_gateway` blocks |
| `approvals.yaml` | `approval` blocks |
| `cross-refs.yaml` | (resolved during conversion; not emitted as construct) |
| `instrument-parameters.yaml` | (folded into data class fields) |
| `data-registries.yaml` | `data_registry` blocks |
| `lab-selection-criteria.yaml` | (OIML-specific; stays in YAML) |
| `sample-selection-rules.yaml` | (OIML-specific; stays in YAML) |
| `certificate-template.yaml` | (out of model; rendering concern) |
| `evaluation-dimensions.yaml` | (folded into data class fields) |

### Step 3 — Primmel → YAML conversion

Reverse of step 2. Each Primmel construct emits one or more YAML files.

For OIML-specific concerns (lab selection, sample selection), the
converter emits them as YAML "extension" files that Primmel ignores.

### Step 4 — Round-trip tests

For each R 60 YAML file:
1. Convert YAML → Primmel
2. Convert Primmel → YAML
3. Assert semantic equality (allowing formatting differences)

For each test Primmel model (from TODO 07):
1. Parse the `.mmel`
2. Dump to YAML
3. Convert YAML → Primmel
4. Assert semantic equality with original

### Step 5 — Wire into build pipeline

Modify `~/src/oimlsmart/smart/browser/build/standards-plugin.ts` to:
- Detect whether a standard has a `.mmel` file
- If yes, parse it via `@riboseinc/mmel` and emit YAML at build time
- If no, use YAML directly (backward compat)

### Step 6 — Documentation

Author `~/src/oimlsmart/smart/docs/authoring-guide.md`:
- "Authoring in Primmel" workflow
- "Authoring in YAML" workflow
- When to use which

## Acceptance criteria

- All R 60 YAML files round-trip cleanly through Primmel
- All test Primmel models round-trip cleanly through YAML
- Build pipeline accepts either format
- Documentation explains both workflows

## Effort

~1 week. Mostly mechanical conversion logic.

## Out of scope

- Migrating all R 60 data to Primmel (separate effort, TODO 09)
- Removing YAML entirely (will happen after Primmel proves stable)
