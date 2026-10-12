# 12 — LML alignment + consolidation: the implementation graph

*The work program for the revised Primmel language (2026-10-12). The
gap register it implements: `primmel-ts/TODO.lang-gaps/00–19`. The
reference implementations to align with: LML spec
`~/src/lutaml/docs/sources/` (RS 3001 lang + RS 3010 declarations +
path/register/transform/collection/evolution), the LML parser
`~/src/lutaml/lutaml-lml` (grammar in PARG, parsanol-ruby), and the
Parsanol parser family `~/src/parsanol/` (parsanol-ts for this
kernel; parsanol-rs for the wasm path).*

**The target in one line:** Primmel strictly > LML — the LML data-
modelling substrate declared in the package surface (mappings,
defaults, string formats, enum payloads, namespaces, paths, register,
transforms, versions) PLUS the metrology loop's higher constructs
(subjects, promises, requirements, processes-with-step-signatures,
checks, evidence, attestation), under the prose quarantine.

## The dependency graph

```
P0 SPEC ──────────────► P1 GRAMMAR ──────────────► P2 KERNEL ─────► P3 CORPUS ────► P4 CONSUMER
spec/sources/            grammar/primmel.parg       packages/primmel  model-library-   oimlsmart/smart
language-v3/sections     (mirrors §17               (parse, check,    spike            (pin bump,
(§07–§17, §90–§92)        rule-for-rule)             ser-des, API)     oiml-r60-lml     services)
     │                        │                          │                 │                │
     └── §17 EBNF draft ──────┘                          └─ gates ─────────┴─ r60 gates ───┴─ smart gates
                                                          (compile/vitest/   (package check,  (vitest/validate/
                                                           conformance)       golden runs)     test:ssot)
RELEASE GATE: owner picks the version number (never tooling) ───────────────────────────────┘
```

Critical path: **§17 EBNF → primmel.parg → kernel parse/materialize →
r60 migration → kernel gates → release → SMART bump.**
Parallelizable: the spec sections (P0.2) are independent of each
other; the checker rules (P2.2) can land while ser-des (P2.3) is in
flight; corpus conversion (P3) is mechanical once the checker is green.

## P0 — Spec first (`~/src/primmel/spec`)

**P0.1 The decision record** (this file + TODO.lang-gaps 18): every gap
ADOPTs except **18-operations = DECLINE** (default; revisit only if a
real XMI-source corpus demands it). Version NUMBERS are always the
owner's.

**P0.2 Section revisions** (sources/language-v3/sections/):

| Section | Revises | Gap files |
|---|---|---|
| 07-lexical-structure | `description { }` block form; label vs description; urn tokens | 02 |
| 08-model-structure | package `version`; namespace declaration (uri+prefix); **datum** (origin × scope); enum `member_fields` + `from_table`; `string_format`; attribute `default`/`render_nil`; record templates; variants DERIVE from dimensions | 04 06 08 10 11 12 13 |
| 09-subject-model | datum unification; behavior.response → description + `ref quotes`; promise.statement → description | 02 04 |
| 10-requirements-and-conformance | the **check** primitive; limits/criteria as checks; urn-only refs; prose quarantine | 01 02 03 |
| 11-processes | **step signatures** + flavors; executor dissolution (actor + run-bound executors with qualification evidence; twins are subjects); gateways are steps; ONE process + realized_by | 01 05 07 |
| 12-data-quantities-time | conditions log as observed datums; completion checks over logs (the 20 °C / 5 min example as the normative example) | 01 04 |
| 13-references-and-relations | ref roles + urn unification; **LutaML Path** as the intra-model address (urns stay external citations) | 02 14 |
| 15-serialization | LML mapping blocks verbatim (xml + key-value), compiling to the kernel's MapProfile | 09 |
| 16-checker | the validation contract (attribute/class/reference families + the Primmel-exceeding set); the DELETION TEST linter; signature-closure rule; change-level rules over model-diff | 02 03 17 19 |
| 17-formal-grammar | the new EBNF — rule-for-rule with primmel.parg (P1.1 co-evolves) | all |
| 90-annex-a-constructs | the revised construct catalogue | all |
| 91-annex-b-rule-catalog | the new checker rules | 02 03 17 |
| 92-annex-c-comparison | the LML strict-superset proof table (per LML construct → the Primmel counterpart or the recorded decline) | 09–19 |

**P0.3** `spec/examples/` + `spec/models/` updated to the revised
syntax (the r60 excerpts first). **Gate:** the spec site builds; §92's
parity table complete; no prose outside label/description in the
spec's own examples.

## P1 — Grammar (`primmel-ts/grammar/primmel.parg`, 489 lines today)

**P1.1** New declaration rules, in §17 lockstep: `mapping` blocks (xml
+ key-value forms), `string_format`, `member_fields`/`from_table`,
`namespace` blocks, `datum` + origin/scope facets, `default`/
`render_nil`, `step`/`binding`/`check` forms, `description {}` block,
package `version`, ref-role grammar.
**P1.2** parsanol-ts: `PargRuntime#parseShape` over the new nesting;
the wasm path verified end-to-end (parsanol-rs → wasm → the kernel's
browser bundle) — the dist-browser leg must stay green.
**P1.3** `conformance/grammar-leg` fixtures per new construct.
**Gate:** grammar leg green; parseShape round-trips every new block.

## P2 — Kernel (`primmel-ts/packages/primmel`)

**P2.1** Materialize the new constructs (ser-des parse-block → typed
shapes; NO casts — the R1–R6 gate).
**P2.1b Calculations are declared math** (TODO.lang-gaps 20): the math
block (notation + formula) with plurimath-ts as the reference engine
(/Users/mulgogi/src/plurimath/plurimath-ts); math is NOT in OCL;
every formula identifier is a bound declared symbol (C165); the
formula parses in its declared notation (C166). The symbol registry is
the binding target.
**P2.2** Checker rules: prose quarantine, urn-only refs, undeclared
names in expressions, signature closure (every consumed name is
produced), member_fields validation, mapping-block coverage, change
levels over model-diff.
**P2.3** Ser-des: compile declared mapping blocks into profiles;
package version in the document model; dumper round-trip.
**P2.4** Public API: step/binding/check/datum types exported.
**Gate:** `yarn compile` (the CI gate), vitest, conformance (248 +
new legs), dist-browser build.

## P3 — Corpus (`~/src/oimlsmart/model-library-spike`)

**P3.1 `oiml-r60-lml` FIRST** (the reference package): prose →
description{}, label unification, urn-only refs, checks, steps with
signatures (machine_steps + calculation_bindings dissolve; verdict +
within_mpe become declared calculations bound at steps), datum
unification, variants derived, enum payloads where applicable.
**P3.2** Gates on the new kernel: package check standalone + composed.
**P3.3** The rest of the library (r91/r129/r144, oiml-cs, CASCO) —
the SMART prompt's scope, same conversions.
**Gate:** all package checks green; golden instances attest.

## P4 — Consumer (`~/src/oimlsmart/smart`)

**P4.1** Bump the `@oimlsmart/primmel-packages` toolchain pin to the
new primmel-ts release (owner picks the number).
**P4.2** Update the dissolved-construct consumers: `verdict.service.ts`
and `form-calculation.ts` (within_mpe → declared checks executed by
the kernel), the test-run runtime (step signatures → INADMISSIBLE by
coverage), `gen:data` (new dumper output), the SSOT guards.
**P4.3** Gates: `npx vitest run`, `npm run validate`, `npm run
test:ssot`.
**P4.4** The SMART agent prompt — written LAST, referencing the real
released version + the real new API surface.

## The release gate

This is a MAJOR Primmel revision (breaking: new constructs, dissolved
constructs, prose quarantine). The change-level discipline (gap 17)
applies to Primmel itself: the corpus, grammar artifact, and kernel
release in lockstep. **The version number is the owner's decision** —
the plan never picks it.
