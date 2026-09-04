# TODO.primmel/11 — the AI-consumption constructs (Primmel v3.2)

**Status:** ACTIVE — canonical plan for the v3.2 extension set
**Date:** 2026-09-04
**Driver:** primmel/spec#18 — requirements from a production RAG consumer
(the OIML SMART estate, ai.oimlsmart.org: 644 typed model nodes live
across R 60/91/129/144). Two measured facts motivate the wave: typed
model objects (calculation, constraint, test-sequence) exist ONLY in the
Primmel representation, and the biggest universal retrieval gap is
vocabulary — the everyday-words → defined-term bridge fails everywhere.

## The doctrine

The same two doctrines as the v3.1 wave (TODO.primmel/10) bind this set:

1. **Self-containment**: the constructs carry Primmel's own semantics.
   External registers (UnitsML, bibliographic identifier schemes) are
   expression-layer correspondences (`corresponds`, clause 19.4), never
   imports.
2. **The concern boundary**: the language declares data and workflow;
   retrieval indexes, vector stores, and agent runtimes are the
   consumer's realization, never the language's.

And the wave's own third rule, from the consumer contract: **what the
language makes first-class data is what retrieval can answer**. Every
ask of spec#18 is a re-homing of knowledge from prose/display strings
into typed, resolvable model content.

## The six constructs (the v3.2 extension set)

| # | Construct | spec#18 ask | Unblocks (consumer roadmap) | Slice |
|---|-----------|-------------|------------------------------|-------|
| 1 | The term alias family (`aliases`, `colloquial`, spelling-tagged variants) | ask 1 | L2 nomenclature bridging | 1 |
| 2 | The top-level `dimension` construct + the applicability dimension namespace | ask 2 | self-querying retrieval (the facet axis) | 2 |
| 3 | Structured document identity on `reference` (`org`, `edition`, `urn`) + the document-anchor grammar; manifest `superseded_by` lineage edge | asks 3+4 | F11 composition-aware answers; temporal steering / superseded demotion | 3 |
| 4 | Units-typed signatures: calculation input/output `quantity_kind` + `range`, the requirement limit's `quantity { kind unit }` | ask 5 | unit-aware retrieval; trustworthy execution | 4 |
| 5 | Verdict chains (`inputs` may name verdicts) + requirement parameter `bind`/`unit` (the instance-parameter schema) | ask 6 | F4 instance-grounded answers, F5 workflow statefulness (the primmel/sst binding contract) | 5 |
| 6 | The impact-edge registry + the `primmel export impact` reverse-dependency export | ask 7 | F6 impact analysis (committee tooling) | 6 |

The consumer-side feature references are the oimlsmart/rag annealment
ladder (`docs/annealment/`: F4, F5, F6, F11; the L2 nomenclature rung)
and its upstream map (`TODO.era3/04-05-planned-and-upstream.md`). The
serializer-side sibling is primmel/primmel-ts#65 (clause URNs
first-class, the `edition`/`model_version` split, the flat retrieval
facet, stable ids + content digests, diff-as-data, passport digests,
language-tagged variants): this wave defines the language constructs its
serialization projects. The deployed consumer contract it must stay
congruent with: oimlsmart/smart v2 `browser/scripts/derive-model-plane.ts`
(node ids are package-authored identifiers, clause URNs are
`<doc>#clause-<clause>`, `source_hash` over package bytes,
`plane: model-plane/1`).

## The work split (the estate's repos)

| Wave | Where | What |
|---|---|---|
| 11a the spec | THIS repo | The MN 114 draft's 2026-09-04 revision: the six constructs, their grammar, their checker rules (C110+), marked *roadmap* per the foreword's verification doctrine until the kernel lands |
| 11b the kernel | `~/src/primmel/primmel-ts` | Parser/validator/serializer for the new facets and the `dimension` construct; the checker rules C110+; the retrieval export (primmel-ts#65) projects them |
| 11c the conformance suite | `~/src/primmel/primmel-ts/conformance` | Corpus cases per construct (positive + negative) |
| 11d the consumers | the smart repo + oimlsmart/rag | The model plane ingests the new fields; the packages re-author (the R 144 `capabilities` applicability seam becomes a declared dimension) |

## The rules (carried from TODO.primmel/10)

- **The language first, always.**
- **The conformance suite grows with the language, in the same wave.**
- **The spec's amendment discipline**: the MN 114 draft carries the
  constructs with rationale + examples; the version note says what v3.2
  added.
- **Backwards compatibility is proven, not promised**: the extension is
  additive; every v3.1 corpus case keeps passing.
- **Roadmap honesty**: per the foreword's verification statement, every
  v3.2 construct is marked *roadmap* with its tracking reference
  (primmel/spec#18) until the kernel wave ships; the mark is removed in
  the same commit that cites the implementing toolchain version.

## Slice plan (the PR series)

Six stacked PRs, in leverage order (the issue's own ordering, with asks
3+4 merged — both are identifier/edge constructs):

1. term aliases — the alias family on `term`
2. typed applicability — the `dimension` construct and the namespace
3. resolvable references + lineage edges
4. units-typed quantities in limits and calculations
5. verdict chains + the instance-parameter schema
6. the impact-graph export

The stacking is dictated by the document's structure: one specification
document with a numbered clause sequence and shared annexes — parallel
branches would collide on Annex B's catalog tail and the foreword's
revision note.

## Done when

- [ ] The MN 114 draft (2026-09-04 revision) carries the six constructs
      with examples, grammar, and checker-rule identifiers.
- [ ] The kernel parses + validates + serializes them; the conformance
      suite covers them; every v3.1 corpus case still passes.
- [ ] The retrieval export (primmel-ts#65) projects the alias family,
      the applicability namespace, the structured references, the
      lineage edges, the typed units, and the impact graph.
- [ ] The OIML SMART packages re-author the seams this wave closes
      (the `capabilities` applicability key becomes a declared
      dimension), and the model plane consumes the new fields — the
      proof by consumption.
