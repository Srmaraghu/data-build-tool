# dbt Core Workflow Setup and Bronze Foundation

### 1) dbt Core workflow is CLI-first
- dbt Core is command-line driven.
- VS Code is used as editor + terminal workspace.
- dbt Cloud gives UI; dbt Core gives raw CLI control.

Tech note:
- In Core workflows, reproducibility depends on versioned config + command discipline.

### 2) UV-based Python environment and dependency flow
Commands used in your flow:
- uv init
- uv sync
- uv add dbt-core
- uv add dbt-databricks

What this established:
- project metadata and lock management
- virtual environment creation/sync
- dbt core engine install
- Databricks adapter install

Tech note:
- Lock-file driven installs reduce cross-machine dependency drift.

### 3) Adapter concept (important learning point)
- dbt Core alone is not enough.
- Adapter is required to connect dbt to execution platform.
- In your case: dbt-databricks adapter.

Learning takeaway:
- dbt Core is the engine, adapter is the platform bridge.

Tech note:
- Adapter compatibility with dbt-core version is a common setup failure point.

### 4) dbt init and profile setup
You covered:
- dbt init project creation
- selecting Databricks adapter option
- host + http path + token authentication inputs
- catalog/schema/threads setup

Important detail:
- connection profile is critical for dbt Core to work.

Tech note:
- Profile target settings control where models physically materialize.

### 5) dbt debug usage and common mistake
- dbt debug validates project/profile/connection wiring.
- Running from wrong directory causes failures.
- Fix: run commands from actual dbt project folder.

Tech note:
- `dbt debug` verifies both config validity and live adapter connectivity.

### 6) dbt project structure understanding
You explored purpose of:
- dbt_project.yml
- models/
- macros/
- seeds/
- snapshots/
- tests/
- analyses/

Key understanding:
- dbt_project.yml controls major project behavior.

### 7) Source system setup in Databricks
You prepared source catalog/schema/tables for raw data.
Tables mentioned:
- fact_sales
- fact_returns
- dim_customer
- dim_product
- dim_store
- dim_date

### 8) source YAML and lineage-safe references
You introduced source declaration YAML and switched from hardcoded table naming to source function references.

Benefit learned:
- better lineage and cleaner model references.

Tech note:
- Source metadata also enables freshness and source-level quality governance.

### 9) Bronze model creation approach
You created bronze models using select-based SQL.

Design principle used:
- bronze layer should be near-raw with minimal transformations.

### 10) Materialization config idea
You covered model materialization via dbt_project.yml (example folder-level behavior such as table/view).

Key idea:
- configuration can be controlled centrally and changed by layer.

Tech note:
- Config precedence determines final behavior when project/properties/model settings conflict.

### 11) dbt run outcome
- dbt run builds models in target warehouse/lakehouse.
- objects appeared in configured schema in Databricks.

### 12) target artifacts and dbt clean
You covered:
- target folder contains compiled/executed artifacts
- useful for debugging generated SQL
- dbt clean removes generated artifacts according to clean targets

Tech note:
- Artifact cleanup helps avoid stale compile state during iterative development.

## Learning summary
This note covers local dbt Core setup with UV, adapter installation, project/profile configuration, connectivity validation with dbt debug, source-to-bronze modeling basics, model execution, and artifact cleanup for reliable iterative development.

## Template Recap
- Concept: this note captures a practical foundation for starting dbt Core projects and building the first bronze layer.
- Tech note: repeatable setup plus clean command discipline reduces configuration and execution drift.
- Learning takeaway: mastering setup + source + bronze gives a strong base for testing, silver models, and production workflows.
- Quick command/example: `dbt debug && dbt run`
