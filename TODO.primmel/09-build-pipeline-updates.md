# TODO.primmel 09 — Build pipeline updates

**Status:** ACTIVE — work in `~/src/primmel/mmel/scripts/`
**Priority:** HIGH (must happen alongside TODO 01-04)
**Independent of:** parser work (TODO 06-08)

## Why

The Primmel build pipeline is defined in `scripts/build.rb`. The `parts`
array is the canonical list of parts to build. New parts must be added
here.

## Current state

```ruby
parts = %w[
  spec data-model process-model compliance measurement mapping
  documentation terminology workspace authoring-guide methodology-guide
]
```

## Work to do

### Step 1 — Add new parts to the array

```ruby
parts = %w[
  spec data-model process-model compliance measurement mapping
  documentation terminology workspace authoring-guide methodology-guide
  forms symbols calculations state-machines
]
```

### Step 2 — Verify each new part has the expected files

Each new part needs:
- `sources/<part>/document.adoc` — header
- `sources/<part>/sections/NN-*.adoc` — numbered section files

### Step 3 — Update `sources/spec/sections/09-model-structure.adoc`

Add the new top-level constructs to the model structure example and
summary table:

```
// Forms
form <ID> { ... }

// Subforms
subform <ID> { ... }

// Symbols
symbol <ID> { ... }

// Calculations
calculation <ID> { ... }

// State Machines
state_machine <EntityName> { ... }
```

### Step 4 — Update `sources/spec/sections/06-file-types.adoc`

Note that `.mmel` files now contain these new constructs.

### Step 5 — Build verification

```sh
cd ~/src/primmel/mmel
bundle exec ruby scripts/build.rb
```

Expected output: 15 parts, all OK, no leaks.

### Step 6 — Deploy

`.github/workflows/deploy.yml` runs on push to main. No changes needed
unless we add new deployment targets.

## Acceptance criteria

- All 15 parts build cleanly
- Zero leak count across all parts
- Model structure section lists all new constructs
- File types section mentions new constructs

## Effort

~30 minutes after the spec sections are written.

## Out of scope

- New deployment targets
- PDF rendering (still HTML only)
- Theme changes
