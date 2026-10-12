# 13 — The MMEL-parity audit (2026-10-12)

**Method.** Three sources, cross-checked: (1) the keyword census over
the MMEL-era corpus (private-models demo/, 10 models — every
top-level keyword counted); (2) Annex E, the GENERATED v2 bridge
(every construct's normative home); (3) the kernel's MMEL-era types
(the parser's construct inventory). The baseline: MMEL 0.1 + the MN
113 v2 additions — the language Primmel must retain entirely.

**Result: ONE gap.**

1. **The canvas layout facet grammar is UNSPECIFIED.** The corpus
   carries per-node `x`/`y` (every MMEL-era diagram; the Studio's
   editor depends on it), the kernel models it (`types/flow.ts` —
   `x: number; y: number` per flow node) — and §12's canvas clause
   said "a page of process components and edges with layout" without
   ever specifying WHAT layout is. Fixed in this change: §12 now
   specifies the position facets (node x/y; no waypoints — the
   corpus carries none and the renderers derive edge geometry).

**Everything else is covered:**

| MMEL-era surface | Where it lives |
|---|---|
| 22/22 corpus keywords (role, process, approval, provision, reference, subprocess→canvas, start/end/timer/signalcatch events, class, data_registry, exclusive_gateway, note, measurement, link, table, view→view_profile, figure, comment, metadata/root/version) | Annex E's generated bridge, each with its normative clause |
| measurement type vocabulary (NUMERIC/DATALIST/DERIVED/TEXT/TABLE_REFERENCE/TRUE/FALSE/DURATION) | clause 13.3 |
| note type vocabulary (NOTE/CAUTION/WARNING/EXAMPLE/COMMENTARY) | clause 13 |
| map_profile ↔ the .prm mapping plane | clause 16.4 + the wire-mapping disambiguation (16.6) |
| registry↔dataclass pairing + forms | clause 11 (forms), C157 |
| v2 compliance plane (provision, verdict, constraint, predicate, competence_kind, conformance classes/tests) | clause 11 + Annex B |
| tables (column count, data rows, the canonical column defs) | clause 13 (the old columns dialect retired — throws) |

The audit's standing rule: Annex E regenerates with Annex A; a new
construct lands with its clause in one change (the freeze). The
next MMEL-source discovery re-runs this census.
