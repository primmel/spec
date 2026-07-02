# TODO.primmel README

This directory is the canonical plan for evolving Primmel from MMEL 0.1.

## File index

| # | File | Subject | Status |
|---|------|---------|--------|
| 00 | [master-overview.md](00-master-overview.md) | Plan summary + phase plan | active |
| 01 | [01-form-and-subform-spec.md](01-form-and-subform-spec.md) | `form` + `subform` spec | active |
| 02 | [02-symbol-registry-spec.md](02-symbol-registry-spec.md) | `symbol` spec | active |
| 03 | [03-calculation-registry-spec.md](03-calculation-registry-spec.md) | `calculation` spec | active |
| 04 | [04-state-machine-spec.md](04-state-machine-spec.md) | `state_machine` spec | active |
| 05 | [05-parameterization-spec.md](05-parameterization-spec.md) | `${{ param }}` substitution | active |
| 06 | [06-mmel-ts-spec-parity.md](06-mmel-ts-spec-parity.md) | Bring parser to spec parity | active |
| 07 | [07-primmel-ts-extensions.md](07-primmel-ts-extensions.md) | Parser support for new keywords | active |
| 08 | [08-oiml-smart-converter.md](08-oiml-smart-converter.md) | YAML ↔ Primmel converter | active |
| 09 | [09-build-pipeline-updates.md](09-build-pipeline-updates.md) | Build pipeline updates | active |

## Phase order

1. **Phase 1** (this arc): spec extensions (TODO 01-05) + build pipeline (TODO 09)
2. **Phase 2** (next arc): parser parity (TODO 06)
3. **Phase 3** (next arc): parser extensions (TODO 07)
4. **Phase 4** (after parser): bidirectional converter (TODO 08)
5. **Phase 5** (ongoing): adoption in OIML SMART

## Quick links

- OIML SMART companion plan: `~/src/oimlsmart/smart/TODO.UPGRADE/21-primmel-migration.md`
- mmel-ts repo: `~/src/mn/mmel-ts/`
- Sample models: `~/src/mn/mmel-models/`
- OIML SMART sample .mmel: `~/src/oimlsmart/smart/data/oiml-r60/examples/r60-metrological.mmel`

## Maintenance

- Update files inline as work progresses
- Mark each TODO item `[x]` when complete
- Don't move completed files out — they're the audit trail
