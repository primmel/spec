# TODO.primmel/10 — the dataspace + trust + alignment constructs (Primmel v3.1)

**The doctrine (the user, 2026-08-27, refined)**: Primmel is ALWAYS
the single source of truth in modelling — and Primmel never IMPORTS
an external standard's semantics. Primmel defines its OWN primitives,
self-contained: a Primmel model is complete and comprehensible with
zero external references. Third-party standards live in the
EXPRESSION layer only — a Primmel primitive can be exported as an
ODRL document, expressed as an AAS submodel, carried as a W3C VC,
mapped to a DPP attribute, referenced to a CDD concept — projection
codecs and correspondence claims, the same shape as the existing
RDF/SHACL and ReqIF exports. The third-party standard is an output
format, never an input dependency. Correspondence (maps-to) is not
import (is-defined-by): a correspondence declaration never carries
the semantics' source.

**The concern boundary (the same doctrine's other half)**: Primmel is
data definition + workflow definition. A model may DECLARE that an act
requires a privilege (a transition's `requires` — a requirement-level
statement, model content). The permission SYSTEM's realization (roles,
grants, cones, tokens, the enforcement machinery) belongs to the
runtime platform alone — NEVER the language. The constructs in this
wave are all declarations/content (the dataspace's definition, the
policies' rules as scheme content, the trust references, the
correspondences); none is a permission mechanism.

**The trigger**: the dataspace design (smart repo's
docs/future/09-dataspaces.md + TODO.dataspace/00) needs the dataspace
as a model object; the same doctrine generalizes every alignment.

## The constructs (the v3.1 extension set)

### 1. `kind dataspace` (Primmel's own dataspace primitive)

The dataspace DEFINITION as a model object — self-contained Primmel
semantics (a reader needs no IDS/DSP knowledge to understand it; the
DSP/IDS alignment is the platform's expression layer, the connector
surface that maps this primitive to the DSP catalog/negotiation/
transfer): the participant classes
(the org kinds), the artifact classes (the entity/form kinds the
dataspace exchanges), the policy sets (by reference, construct 2),
the trust anchors (construct 3), the governance references (the
scheme documents' clauses — the existing provenance machinery:
`source: { doc, clause }`). A dataspace package is then a published,
versioned model object; another scheme's dataspace declares
compatibility explicitly.

### 2. The `policy` model object (Primmel's OWN policy grammar)

The usage-policy SET as first-class model content, expressed in
PRIMMEL'S OWN grammar: rules (permission / obligation / prohibition)
over the model's artifact classes and the actions on them, with
constraints in Primmel's existing expression dialects (the OCL
dialect; quantities per the measurement model). A policy is fully
meaningful with zero external references. ODRL 2.2 is a CODEC OUTPUT:
the Primmel policy exports to an ODRL document for the dataspace wire
(the DSP connector consumes the expression; the semantics are ours).
Each policy also carries its model identity: the artifact classes it
governs, the default-posture flag, the clause provenance. The
scheme's standing policies (the access tiers: public / restricted /
working) become the default policy set every dataspace artifact class
inherits.

### 3. The `trust_ref` reference type

The model-level reference to the trust plane: names an org by its
registry id and (optionally) a key by kid, resolved against the OP's
public endpoint (`/op/keys/<org-id>.json`). The entity-reference
machinery extends with the resolution contract (the reference is
opaque to the model; the platform resolves it at runtime; the
conformance corpus pins the resolution semantics against a stub).

### 4. The generalized CORRESPONDENCE annotations (maps-to, never import)

The product-reference packages' `map_profiles` pattern
(AGENTS.d/13) generalizes into a first-class, per-node correspondence
declaration: any model node may carry `corresponds:` entries naming
the external CONCEPT it maps to — the CDD IRDI (already carried on
attributes as `irdi`; the construct generalizes to every node kind),
and the mapping declarations that drive the EXPRESSION codecs (how
this node projects into the AAS submodel / the DPP attribute / the VC
claim — the codec's input, authored once in the model). The semantics
stay Primmel's; the annotations declare correspondence and steer the
projections. A new Recommendation declares its correspondences ONCE,
in the model, and every bridge consumes them instead of its own hand
mapping.

## The work split (the estate's repos)

| Wave | Where | What |
|---|---|---|
| 10a the spec | THIS repo | The MN 114 v3 draft's next revision gains the four constructs' sections (the grammar + the semantics + the examples); the published site (primmel.github.io) gains the guides |
| 10b the kernel | `~/src/primmel/primmel-ts` | The parser/validator/linker for the new constructs (the kind vocabulary + the linker R-rules + the trust_ref resolution contract) |
| 10c the conformance suite | `~/src/primmel/primmel-ts/conformance` | The corpus grows per construct (positive + negative cases; the suite.json + clauses.json declare the new rules; the 61/61 becomes the larger set) |
| 10d the first consumer | the smart repo | TODO.dataspace/01 (the OIML-CS dataspace package) authored IN the new constructs — the language wave's proof by consumption |

## The rules

- **The language first, always**: the platform consumes the
  constructs the kernel ships; a platform feature that needs a
  construct the language lacks is a language wave, never a local
  workaround.
- **The conformance suite grows with the language, in the same
  wave**: a construct without its corpus cases does not ship.
- **The spec's amendment discipline**: the MN 114 draft carries the
  constructs with their rationale + the examples; the version note
  says what v3.1 added.
- **Backwards compatibility is proven, not promised**: every v3
  corpus case keeps passing unchanged (the extension is additive).
- The OIML SMART platform's consumption (TODO.dataspace) is the
  first customer, never the language's assumption — the constructs
  are scheme-neutral.

## Done when

- [ ] The MN 114 v3.1 draft carries the four constructs with examples.
- [ ] The kernel parses + validates + links them; the conformance
      suite covers them; every v3 corpus case still passes.
- [ ] The published site's guides carry them.
- [ ] The OIML-CS dataspace package (TODO.dataspace/01) authors in
      them and validates clean — the proof by consumption.
