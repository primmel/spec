# Primmel Models

Canonical Primmel (`.mmel`) representations of standards modelled in the
Primmel language.

## Available models

| Model | Standard | Status |
|---|---|---|
| [r60/r60.mmel](r60/r60.mmel) | OIML R 60:2021 (Load Cells) | ✅ Phase 1-7 — full model |

## R 60 model coverage

`r60/r60.mmel` covers:

| Source | Constructs | Status |
|---|---|---|
| Roles | 6 (IA, TestLab, MTL, Manufacturer, AuthorisedRep, BIML) | ✅ |
| Helper classes | 5 (Address, Contact, Accreditation, DocumentRef, CustodyEvent) | ✅ |
| Data classes | 16 (Manufacturer, IA, TestLab, Family, Group, Instrument, Sample, Application, TestRequest, TestAssignment, TestReport, FormInstance, FormOmission, TestReportDetermination, ModelEvaluation, EvaluationReport, Certificate, CertificateAnnex) | ✅ |
| Data registries | 15 (one per data class) | ✅ |
| References | ~60 (R 60-1, R 60-2, R 60-3, Annexes, external OIML D 11/R 76) | ✅ |
| Symbols | 18 (formal metrological symbols with LaTeX) | ✅ |
| Calculations | 9 (loadCellError, referenceIndication, conversionFactor, repeatabilityError, mean, creep, deadLoadOutputReturn, humidityCHmin/max) | ✅ |
| Provisions | ~35 (all R 60-1 §5 metrological + §6 technical) | ✅ |
| Notes | 2 (external definitions, certificate layout) | ✅ |
| Processes — examinations | 4 | ✅ |
| Processes — metrological tests | 6 | ✅ |
| Processes — electronic tests | 9 | ✅ |
| Processes — IA evaluation | 3 (ReviewAdmissibility, SynthesizePerModel, IssueCertificate) | ✅ |
| Approval | 1 (BIMLRegistration) | ✅ |
| Workflow subprocess | 1 (5-phase certification flow) | ✅ |

## Source of truth

This file is hand-authored based on the YAML data at
`~/src/oimlsmart/smart/data/oiml-r60/`. The YAML is the working data;
this .mmel is the canonical Primmel representation.

The bidirectional converter at
`~/src/oimlsmart/smart/browser/build/{yaml-to-primmel,primmel-to-yaml}.ts`
can verify the .mmel is structurally equivalent to the YAML.

## Future models

- `r129/r129.mmel` — OIML R 129 (Dynamic weighing) — to be authored
- `r144/r144.mmel` — OIML R 144 (Test report formats) — to be authored
