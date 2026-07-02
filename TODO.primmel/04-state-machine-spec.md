# TODO.primmel 04 — `state_machine` spec

**Status:** ACTIVE — implement in `sources/state-machines/`
**Priority:** MEDIUM (lifecycle-heavy domains; OIML has it, general MMEL may not)
**Independent of:** other extensions

## Why

MMEL 0.1 has `exclusive_gateway` (decision points) and `process_flow`
edges, but no first-class state machine construct. Side-effects on
state transitions are implicit in the flow topology, not declarative.

For lifecycle-heavy domains (certification, audit, approval), you need
to declare: "when this entity's state changes, these dependent entities
also change." BPMN-style flowcharts aren't enough.

OIML SMART has this in `state-machines.yaml`:

```yaml
- from: IN_PROGRESS
  to: COMPLETED
  action: lab_issues_test_report
  cascade:
    - entity: test_report
      where: 'testRequestId = ${this.id}'
      set: { status: SUBMITTED }
    - entity: form_instance
      where: 'testReportId = ${testReport.id}'
      set: { status: LOCKED }
```

This is a generic pattern — every domain with stateful entities needs it.

## What MMEL 0.1 has (closest match)

- `exclusive_gateway` — decision points in process flow
- `process` — atomic activity

Neither captures "entity lifecycle" semantics.

## Proposed Primmel spec

### Top-level: `state_machine`

```
state_machine <EntityName> {
  initial <InitialState>

  states {
    <StateName>
    <StateName>
    ...
  }

  transition <From> -> <To> [action <ActionName>] {
    guard "<OCL predicate>"              // optional: condition that must hold
    cascade <EntityName> {                // optional: side-effects on related entities
      where "<OCL predicate>"
      set {
        <field>: <value>
      }
    }
    reference { <ReferenceID> }           // optional: traceability
  }
}
```

### Example

```
state_machine TestReport {
  initial DRAFT

  states {
    DRAFT
    SUBMITTED
    UNDER_REVIEW
    ACCEPTED
    REJECTED
  }

  transition DRAFT -> SUBMITTED action lab_submits {
    cascade FormInstance {
      where "testReportId = ${this.id}"
      set { status: "LOCKED" }
    }
  }

  transition SUBMITTED -> UNDER_REVIEW action ia_starts_review {
  }

  transition UNDER_REVIEW -> ACCEPTED action ia_accepts {
    guard "every(FormInstance where testReportId = ${this.id}).result != 'FAIL'"
    cascade EvaluationReport {
      where "testReportIds->includes(${this.id})"
      set { admissibility_progress: "incremented" }
    }
  }

  transition UNDER_REVIEW -> REJECTED action ia_rejects {
    guard "some(FormInstance where testReportId = ${this.id}).result = 'FAIL'"
  }
}
```

## Composition rules

- A state machine is bound to ONE entity (typically a `class#data`)
- The `cascade` block references OTHER entities (also `class#data`)
- `${this.id}` resolves to the source entity's id
- `${this.field}` resolves to any field on the source entity
- The `where` predicate is OCL over the target entity's fields
- The `set` block declares field-by-field updates

## Spec sections to author

`sources/state-machines/document.adoc`:
```
= MN 113-10: MMEL State Machines
:docnumber: 113.10
... (standard header)
include::sections/01-state-machines-overview.adoc[]
include::sections/02-state-machine-syntax.adoc[]
include::sections/03-transitions.adoc[]
include::sections/04-cascades.adoc[]
include::sections/05-guards.adoc[]
include::sections/06-token-substitution.adoc[]
include::sections/07-formal-grammar.adoc[]
```

## Section content sketch

### 01 — State machines overview
- Purpose: explicit entity lifecycle with declarative side-effects
- Relationship to `process`: state machines describe entity state;
  processes describe activities
- Relationship to `exclusive_gateway`: gateways are decision points in
  flow; state machines are entity lifecycles

### 02 — State machine syntax
- Grammar
- `initial`, `states`, `transition`

### 03 — Transitions
- `from`, `to`, `action`, `guard`, `cascade`
- Atomicity: a transition + its cascades execute atomically
- Idempotency: firing the same transition twice is an error

### 04 — Cascades
- `cascade <Entity> { where, set }` syntax
- Multiple cascades per transition
- `${this.field}` and `${transition.field}` tokens
- Cascade ordering: source entity updated first, then cascades in declaration order

### 05 — Guards
- OCL predicate that must hold for the transition to fire
- Evaluated BEFORE the transition
- Failure: transition does not fire; caller receives a guard violation

### 06 — Token substitution
- `${this.id}` — source entity id
- `${this.<field>}` — source entity field value
- `${<TransitionName>.<field>}` — value produced by a named prior cascade
- Substitution is build-time (for static values) or runtime (for entity fields)

### 07 — Formal grammar
- EBNF

## Validation

- Build cleanly
- Zero leak count
- Worked example demonstrates: initial state, transitions with guards,
  cascades with where/set, token substitution
