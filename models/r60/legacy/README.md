# Legacy R 60 monolithic model

This directory holds `r60-root.mmel` — the original single-file build
of the R 60 Primmel model (3837 lines, ~149 KB).

## Status: superseded

It was split into 20 MECE files under `../parts/` for maintainability.
The active model is composed by `../r60.mmel` via `include "parts/..."`
directives — this legacy file is **not referenced anywhere** in the
active build.

## Why it's preserved (not deleted)

Per project policy, source artifacts are never deleted even when
derived output exists. This file may be useful for:

- Historical reference (what the model looked like before the split)
- Diffing against the active split build to verify equivalence
- Bisection if a regression is introduced by the split

If you need to refresh it from the current state of `../parts/`,
concatenate the included files in the order declared by `../r60.mmel`.
