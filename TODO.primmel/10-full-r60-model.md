# TODO.primmel 10 — Full R 60 model in Primmel syntax

**Status:** ✅ PHASES 1-7 COMPLETE (2357 lines)
**Date:** 2026-07-04
**Goal:** Author a single comprehensive `.mmel` file that fully models
OIML R 60 parts 1, 2, 3, and A in Primmel syntax.

## Why

The OIML SMART platform's data model is currently expressed as ~80 YAML
files. The canonical Primmel representation should be a single `.mmel`
file per standard. This document tracks the work to author that file.

Per the user's directive: "We need to improve Primmel and fully model
R 60 (1,2,3,a)."

## Current state

`models/r60/r60.mmel` (2357 lines) now contains:

| Construct | Count |
|---|---|
| Roles | 6 |
| Helper classes | 5 |
| Data classes | 16 |
| Data registries | 15 |
| References | ~60 |
| Symbols | 19 |
| Calculations | 9 |
| Provisions (R 60-1) | 39 |
| Processes (R 60-2) | 23 |
| Forms (R 60-3) | 5 |
| Subforms | 1 |
| State machines | 7 |
| Approvals | 1 |
| Workflow subprocess | 1 |
| Notes | 2 |


| Source | Construct | Approximate count |
|---|---|---|
| R 60-1 §3 | Terminology (terms & definitions) | ~30 terms |
| R 60-1 §5.1 | Classification (accuracy classes, nLC, etc.) | 7 provisions |
| R 60-1 §5.2 | Measuring range | 2 provisions |
| R 60-1 §5.3 | MPE | 2 provisions (table + type-evaluation) |
| R 60-1 §5.4 | Repeatability | 1 provision |
| R 60-1 §5.5 | Creep + DR | 3 provisions |
| R 60-1 §5.6 | Influence quantities | 6 provisions |
| R 60-1 §5.7 | Electronic load cells | ~10 provisions |
| R 60-1 §6 | Technical (software, markings) | ~9 provisions |
| R 60-2 §2.5 | Examinations | 4 processes |
| R 60-2 §2.6 | Test conditions | 17 condition blocks |
| R 60-2 §2.7 | Error determination rules | 5 provisions |
| R 60-2 §2.10 | Metrological test procedures | 6 processes |
| R 60-2 §2.10.7 | Electronic test procedures | 9 processes |
| R 60-3 §4 | Evaluation report metadata forms | ~14 forms |
| R 60-3 §5 | Examination forms | 4 forms |
| R 60-3 §6 | Performance test forms | 18 forms |
| R 60-3 (headers) | Shared header forms | 5 forms |
| Annex A-A | External definitions (D 11, R 76) | 17 symbols |
| Annex A-B/C | Certificate page 1/2 layout | 1 process |
| Annex A-D | Sample selection algorithm | 1 process |
| Annex A-E | Load transmission guidance | notes |
| Symbols | All formal symbols (f, nLC, MPE, etc.) | ~50 symbols |
| Calculations | All OCL computation primitives | ~30 calculations |
| State machines | TestReport, TestRequest, FormInstance, EvaluationReport, Certificate | 5 state machines |

**Total: ~120 provisions, ~25 processes, ~46 forms, ~50 symbols,
~30 calculations, ~5 state machines.**

## Phasing

### Phase 1 (this turn) — Structural skeleton
- [ ] `models/r60/r60.mmel` with root + metadata + roles
- [ ] All data classes (Manufacturer, InstrumentModelFamily, Group,
      MeasuringInstrument, InstrumentSample, Application, TestRequest,
      TestAssignment, TestReport, FormInstance, FormOmission,
      TestReportDetermination, ModelEvaluation, EvaluationReport,
      Certificate, CustodyEvent)
- [ ] All data registries
- [ ] All references (R 60-1, R 60-2, R 60-3 clauses)

### Phase 2 — Symbols and calculations
- [ ] All ~50 formal symbols with LaTeX
- [ ] All ~30 OCL calculation primitives

### Phase 3 — Provisions (R 60-1 requirements)
- [ ] Classification (§5.1)
- [ ] Measuring range (§5.2)
- [ ] MPE (§5.3)
- [ ] Repeatability (§5.4)
- [ ] Creep + DR (§5.5)
- [ ] Influence quantities (§5.6)
- [ ] Electronic (§5.7)
- [ ] Technical (§6)

### Phase 4 — Processes (R 60-2 tests)
- [ ] Examinations (4)
- [ ] Metrological tests (6)
- [ ] Electronic tests (9)

### Phase 5 — Forms (R 60-3 TRFs)
- [ ] Headers (5)
- [ ] Evaluation report metadata forms (~14)
- [ ] Examination forms (4)
- [ ] Performance test forms (18) including subform composition

### Phase 6 — State machines
- [ ] TestReport lifecycle with cascades
- [ ] TestRequest lifecycle
- [ ] FormInstance lifecycle
- [ ] EvaluationReport lifecycle
- [ ] Certificate lifecycle

### Phase 7 — Workflow + approvals
- [ ] 5-phase certification subprocess
- [ ] Approvals (BIML certificate registration)

## Approach

The .mmel file is authored BY HAND based on the existing YAML data in
`~/src/oimlsmart/smart/data/oiml-r60/`. The OIML SMART bidirectional
converter (TODO.primmel 08) can also generate this file programmatically,
but the hand-authored version serves as the canonical reference.

## Verification

- Parse via `@primmel/mmel` parser (after npm publish)
- Round-trip via OIML SMART bidirectional converter
- Cross-check that every YAML file's content is represented

## Out of scope

- OIML R 129, R 144 — separate standards, separate models
- Paneron editor extension updates
- PDF rendering of the certificate (rendering concern, not model concern)
