# dbt Core Local Setup + First Models (Learning Revision)

Based on your current lesson flow: CLI-first setup with UV, Databricks adapter, dbt init, source config, and first bronze models.

## 1) Big picture from this lesson
- dbt Core is CLI-driven.
- VS Code is used as the working environment for files + terminal.
- You need:
  - Python environment
  - dbt Core package
  - one adapter (Databricks here)
  - a valid profiles configuration

Learning takeaway:
- dbt Core gives transformation engine via CLI; adapter connects dbt to target platform compute.

## 2) UV workflow you practiced
Core UV commands:

```bash
uv init
uv sync
uv add dbt-core
uv add dbt-databricks
```

What each does:
- uv init: initializes project metadata and basic setup files.
- uv sync: creates/syncs virtual environment from project definition.
- uv add: adds dependency and updates pyproject and lock file.

Important files created/updated:
- .python-version
- pyproject.toml
- uv.lock
- .venv/ (after sync)

Learning takeaway:
- With UV, dependency and environment management are project-native and reproducible.

## 3) Why adapter is mandatory
- Installing only dbt Core is not enough for execution.
- Adapter maps dbt to warehouse/lakehouse-specific connection and SQL behavior.

Examples:
- dbt-databricks
- dbt-snowflake
- dbt-bigquery
- dbt-redshift

Learning takeaway:
- dbt Core is engine; adapter is the platform bridge.

Tech note:
- Adapter selection affects SQL compilation and connection/session behavior at runtime.

## 4) dbt init flow you practiced
Command:

```bash
dbt init <project_name>
```

What happens:
- creates project folder structure
- asks for adapter selection
- collects connection values for profile setup

Typical prompts (Databricks):
- host
- http path
- auth method (token)
- catalog
- schema
- threads

## 5) Two critical files to align
### dbt_project.yml
- project-level behavior and path config
- profile key must match profile name in profiles file

### profiles.yml
- connection targets and credentials
- in dbt Core, usually under user home .dbt directory by default

Rule:
- profile name in dbt_project.yml and top-level profile name in profiles.yml must match.

Tech note:
- Mismatch causes parse/load failures before model execution even starts.

## 6) Common beginner error you saw
Error pattern:
- running dbt commands from wrong directory (parent folder)

Fix:
- cd into actual dbt project directory, then run dbt commands.

Fast validation:

```bash
dbt debug
```

If all checks pass, project + profile + connection are wired correctly.

## 7) Recommended model folder setup (medallion)
Inside models folder, create:
- bronze/
- silver/
- gold/
- source/ (or sources/) for source YAML declarations

Why:
- clearer architecture
- easier onboarding
- better lineage readability

## 8) Why source YAML is important
Instead of hardcoding fully qualified table names in SQL models, declare sources in YAML and reference them dynamically.

Benefits:
- cleaner SQL
- lineage graph includes true source nodes
- easier maintenance if schema/catalog changes

Typical source declaration includes:
- source name
- database or catalog
- schema
- table list

Tech note:
- Source declarations are foundational for freshness checks and source-level contracts.

## 9) Bronze model pattern you used
Bronze goal:
- pull source data with minimal or no transformation.

Model pattern:
- select all or near-raw columns from declared source tables
- materialize consistently as table or view per project config

## 10) Materialization config concept
In dbt_project.yml, model groups can be configured with defaults like materialized table or view.

Key idea:
- this is project-level configuration
- model-level config can override when needed

Tech note:
- Precedence is specificity-driven: model SQL config overrides project defaults.

## 11) Running models and seeing outputs
Command:

```bash
dbt run
```

What dbt does:
- compiles SQL + Jinja
- builds selected models in target platform
- prints per-model status in CLI logs

## 12) target folder and compiled SQL
After run/build/compile, target folder appears.

Why it matters:
- contains compiled and executed SQL artifacts
- best place for debugging what dbt actually ran

Learning takeaway:
- I use compiled artifacts to troubleshoot SQL generation and model behavior.

Tech note:
- `manifest.json` and `run_results.json` are key for CI diagnostics and state comparisons.

## 13) Cleaning generated artifacts
Command:

```bash
dbt clean
```

Purpose:
- removes generated folders configured in clean-targets
- useful to reset local generated state
## 14) Practical checklist before coding models
1. confirm virtual environment is active
2. confirm dependencies installed (dbt-core + adapter)
3. run dbt debug in project folder
4. verify profile name matching
5. verify source tables exist in platform

## 15) Template Recap
- Concept: local dbt Core setup requires environment, adapter, profile wiring, and model/source structure.
- Tech note: correctness depends on profile matching, source declarations, and artifact-aware debugging.
- Learning takeaway: describe setup-to-first-run flow, including common directory/profile mistakes and fixes.
- Quick command/example: `dbt debug && dbt run --select models/bronze`
