# dbt init: Files Created and Purpose

Use this as a revision note for project work and practical learning.

## 1) What dbt init does
When you run:

```bash
dbt init <project_name>
```

dbt creates a starter project with standard folders, starter models, and config files.

Tech note:
- dbt init scaffolds conventions that dbt parsers and CLI commands expect by default.

Typical structure:

```text
<project_name>/
  dbt_project.yml
  README.md
  analyses/
  macros/
  models/
    example/
      my_first_dbt_model.sql
      my_second_dbt_model.sql
      schema.yml
  seeds/
  snapshots/
  tests/
```

## 2) High-level purpose of this structure
- Standardization: every dbt project follows similar layout.
- Team collaboration: easier onboarding and code review.
- Separation of concerns: models, tests, macros, snapshots each have clear homes.

Tech note:
- This structure improves parser determinism and team-level code discoverability.

## 3) Most important file: dbt_project.yml
Purpose:
- Central project configuration.

What it usually controls:
- project name and version
- profile name to use from profiles.yml
- folder paths (models, seeds, tests, macros, snapshots)
- model defaults such as materialization and schema behavior

Why this matters:
- It shows you understand how dbt behavior is configured globally.

Tech note:
- Config inheritance starts here and can be overridden downstream at more specific scopes.

## 4) models/ (core transformation layer)
Purpose:
- Stores SQL models that become tables/views/incremental objects in your warehouse/lakehouse.

Key concept:
- Models are the heart of dbt because transformation logic lives here.

Starter files inside models/example:

### my_first_dbt_model.sql
- Demonstrates a basic model.
- Often includes a model-level config example.

### my_second_dbt_model.sql
- Demonstrates model dependency using ref().
- Shows how dbt builds DAG lineage.

### schema.yml
- Stores model documentation and tests.
- Common tests: not_null, unique, relationships, accepted_values.

Tech note:
- YAML-defined metadata is consumed by docs generation and test graph compilation.

## 5) macros/
Purpose:
- Reusable Jinja + SQL snippets.

Why useful:
- Avoid repeated logic.
- Enforce standards (for example naming patterns or shared expressions).

Tech note:
- Macros are adapter-aware and can dispatch different SQL implementations per platform.

## 6) tests/
Purpose:
- Stores custom SQL tests (singular tests).

Difference from schema.yml tests:
- schema.yml: generic tests declared in YAML.
- tests/ SQL files: custom, case-specific assertions.

Tech note:
- Singular tests pass only when query output is empty (zero violating rows).

## 7) seeds/
Purpose:
- Stores CSV files loaded with dbt seed.

When to use:
- Small, static reference data (country codes, category mappings, flags).

Tech note:
- Seed loading is deterministic and versionable, making lookup-table changes auditable.

## 8) snapshots/
Purpose:
- Tracks row-level historical changes over time.

Key keyword:
- Used for SCD-style tracking (especially SCD Type 2 patterns).

Tech note:
- Snapshot strategy (timestamp/check) controls change detection semantics and history quality.

## 9) analyses/
Purpose:
- One-off or exploratory SQL files.

Important:
- Usually not part of production model DAG outputs.

Tech note:
- Analyses are useful for ad hoc SQL without polluting production model lineage.

## 10) README.md
Purpose:
- Human documentation for project setup and usage.

What to include:
- setup steps
- run/test commands
- project conventions
- environment notes

Tech note:
- A strong project README reduces onboarding time and incident recovery friction.

## 11) What dbt init sets up outside project folder
Usually during onboarding/setup, dbt expects:

```text
~/.dbt/profiles.yml
```

profiles.yml purpose:
- Connection and target config (adapter, host, schema/catalog, threads, credentials).
- Environment switching (for example dev vs prod targets).

Tech note:
- Keep credentials externalized and avoid committing sensitive profile values.

## 12) What is NOT created by dbt init (but appears later)
After running commands like dbt run/build/docs, you will often see:
- target/ (compiled SQL, artifacts like manifest.json, run results)
- logs/ (execution logs)
- dbt_packages/ (if you install packages)

Why this matters:
- Helps you explain init-time files vs runtime artifacts clearly.

Tech note:
- Runtime artifacts power state-based selection, docs, and CI diagnostics.

## 13) Fast command flow after init
Typical first steps:

```bash
dbt debug
dbt run
dbt test
dbt docs generate
dbt docs serve
```

Tech note:
- Start with dbt debug before first run to catch profile/target misconfiguration early.

## 14) Template Recap
- Concept: `dbt init` creates the project skeleton and conventions for models, tests, macros, and docs.
- Tech note: runtime artifacts are generated later by run/build/test/docs and are key for diagnostics.
- Learning takeaway: differentiate init-time files from execution-time artifacts and explain why both matter.
- Quick command/example: `dbt init demo_project && dbt debug`