# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo is

The public home of **Primmel** — the second generation of the **Multi-Modal Modelling Language (MMEL)** — containing both the language specification and a library of teaching examples. Primmel is the public distribution of MMEL; the `MMEL 0.1` schema identifier inside `.mmel` files is the language name, and `Primmel` is the project name. Both refer to the same DSL.

The repo has two distinct content areas:

- **`sources/`** — eleven Metanorma-style AsciiDoc specification documents (`spec`, `data-model`, `process-model`, `compliance`, `measurement`, `mapping`, `documentation`, `terminology`, `workspace`, `authoring-guide`, `methodology-guide`). Compiled to static HTML and published via GitHub Pages. Each part has a `document.adoc` header (title + attributes + includes) and a `sections/` folder of numbered section files that the header pulls in via `include::sections/NN-name.adoc[]`.
- **`examples/`** — fictional, anonymised `.mmel` / `.sdc` / `.map` / `.sws` artifacts that demonstrate the language's primitives. **Never copy real standards content (ISO, BSI, OIML, MDSAP, etc.) or proprietary organisation data into `examples/`.** All content here must be invented for teaching. See `examples/README.adoc` for the reading order.

The build pipeline renders only `sources/`. `examples/` ships as plain reference files; the `.mmel` DSL is not parsed by `scripts/build.rb`.

## Build / develop commands

There is no test suite in this repo. The build pipeline itself is the validation.

```sh
# install deps (pulls coradoc* gems straight from the metanorma/coradoc main branch)
bundle install

# build all parts -> dist/<part>/index.html
bundle exec ruby scripts/build.rb

# build a single part ad-hoc (the build script has no per-part flag)
bundle exec ruby -r ./scripts/coradoc_build -e \
  'puts CoradocBuild.build_file("sources/spec/document.adoc")[0, 1000]'
```

The first build will take a while because `Gemfile` points at `branch: 'main'` of `metanorma/coradoc` — Bundler clones and compiles the gems every time `Gemfile.lock` is invalidated.

## Architecture (build pipeline)

The pipeline is defined across two files and is worth reading end-to-end before touching it:

1. **`scripts/coradoc_build.rb`** — the `CoradocBuild` module:
   - `build_file(path, css_theme:)` — runs the AsciiDoc → CoreModel → HTML chain end-to-end:
     1. `Coradoc::AsciiDoc.parse(content)`
     2. `doc.expand_includes(File.dirname(path))` — resolves `include::` against the source directory
     3. `Coradoc::AsciiDoc::Transform::ToCoreModel.transform(expanded)` — flattens to the lutaml-model core
     4. `Coradoc::Html::Config.embedded_stylesheet(css_theme:)` — fetches the named theme CSS
     5. `Coradoc::Html::Static::Configuration.new(...)` with TOC on, 4 levels, section numbering on
     6. `Coradoc::Html::Static.convert(core, config)` — emits the final HTML
   - `write(html, output_path)` — creates the output dir and writes the file.
   - `leak_count(html)` — counts stray `Coradoc::Html::Drop` markers; **must be zero** for a clean build.
   - `DEFAULT_CSS_THEME = 'professional'` — change here to retheme the whole site.
2. **`scripts/build.rb`** — orchestrator. It owns the canonical **parts list** (order, set of names) and loops them, skipping any directory that lacks a `document.adoc`. Any new document part is added by adding a directory under `sources/` **and** adding the name to the `parts` array in this file. Per-part results print as `OK` / `LEAKS: N` / `ERROR`; the trailing summary line tallies bytes and errors.

Anything not in `parts` will be silently skipped, so the parts array is the single source of truth for what gets built.

## Deployment

`.github/workflows/deploy.yml` runs `bundle exec ruby scripts/build.rb` on push to `main` (or manual dispatch) with Ruby 3.4, uploads `dist/` as a GitHub Pages artifact, then deploys it. Concurrency group is `pages` and is not cancelled — wait for in-flight deployments.

## Output / ignored files

- `dist/` is **gitignored** generated output. Never commit it; never hand-edit it.
- `Gemfile.lock` is also gitignored.
- The `:docnumber:`, `:mn-document-class: ribose`, `:mn-output-extensions: xml,html,pdf,rxl` attributes in each `document.adoc` are Metanorma-style metadata. Only HTML is currently emitted; the other extensions are aspirational and must not be removed (they are part of the document contract).

## Things future agents trip on

- `coradoc` deps come from a branch of an external repo, not RubyGems. `bundle update coradoc` will pull fresh `main`. Treat the lockless state as intentional.
- No linting, formatting, or static analysis is configured. Do not introduce RuboCop / Standard / etc. without asking.
- No specs. Do not invent a test framework "for completeness" — the build script is the contract.
- The `Coradoc::Html::Drop` leak check is the closest thing this repo has to a unit test. Treat any non-zero leak count as a build failure to investigate, not a warning to suppress.
- When editing `scripts/build.rb`'s `parts` array, keep its order roughly user-facing (front matter / spec / data model / ... / authoring guides) — it doubles as the default reading order in the deployed table-of-contents.
