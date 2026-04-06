# dbt + Databricks Quick Cheat Sheet

Major concepts only, compact version.

## 1) What is dbt?
dbt = Data Build Tool, mainly the T in ELT.

Tech note:
- dbt compiles Jinja + SQL into executable warehouse-specific SQL before running.

- E: Extract
- L: Load
- T: Transform

One-liner:
- dbt transforms data inside your warehouse/lakehouse using SQL + Jinja.

## 2) What dbt is not
- Not an ingestion tool
- Not an orchestration platform
- Not a warehouse/lakehouse

Tech note:
- In production stacks, dbt is usually triggered by orchestrators but does not replace them.

Usually handled elsewhere:
- Airflow, ADF, Databricks Jobs, Lakeflow

## 3) Where dbt runs
dbt runs on your platform compute:
- Databricks
- Snowflake
- BigQuery
- Redshift
- Synapse / Fabric

Key point:
- dbt does not bring its own storage or compute.

Tech note:
- Runtime cost and performance are governed by warehouse/lakehouse resource settings.

## 4) dbt in one line
- dbt is a framework for modular, testable, reusable SQL transformations.

Tech note:
- Modularity comes from model graph dependencies built via ref/source semantics.

## 5) Why teams use dbt
- Reusable SQL models
- Jinja templating
- Dependency-aware DAG using ref
- Built-in tests and docs
- Better Git/CI workflows

Without dbt:
- repeated SQL, weak structure, hard maintenance.

Tech note:
- dbt artifacts (manifest/run_results) make CI checks and lineage tooling practical.

## 6) dbt vs PySpark
PySpark:
- broader scope (ingestion + processing + writes + engineering workflows)

dbt:
- transformation-focused SQL layer (models, tests, lineage, docs)

Takeaway:
- dbt can replace part of transformation logic, not all of PySpark.

Tech note:
- Heavy procedural logic, custom UDF pipelines, and complex non-SQL flows often remain in Spark.

## 7) Core vs Cloud vs Canvas
### dbt Core
- Open source, CLI, self-managed.

### dbt Cloud
- Managed SaaS built on Core, with UI and team workflow features.

### dbt Canvas
- Visual model-building experience inside dbt Cloud.

Tech note:
- Core and Cloud share the same transformation engine semantics; operational UX differs.

## 8) dbt models
Model = usually a .sql file that materializes a table/view/incremental relation.

Tech note:
- Materialization choice directly impacts cost, latency, and downstream query behavior.

Mental flow:
- source -> cleaned -> curated -> reporting

## 9) Medallion layers
- Bronze: raw data
- Silver: cleaned and standardized data
- Gold: business-ready marts and KPI tables

Memory hook:
- Bronze = raw, Silver = clean, Gold = business-ready

Tech note:
- Keep layer contracts explicit (grain, keys, nullability) to avoid downstream ambiguity.

## 10) How dbt fits Medallion
Typical pattern:
1. Ingestion lands data in Bronze
2. dbt builds Silver models
3. dbt builds Gold marts

Practical note:
- dbt is most commonly used for Silver and Gold.

Tech note:
- Bronze is frequently ingestion-owned; dbt strengthens consistency from staging onward.

## 11) Databricks + dbt mental model
- Databricks = platform (storage + compute)
- dbt = transformation framework on top

Tech note:
- dbt-databricks adapter maps dbt semantics to Databricks SQL and Unity Catalog context.

## 12) Source vs dbt source
- Source (general): any raw input table/data feed
- dbt source: declared existing raw table in YAML for safe references

Tech note:
- Declared sources unlock freshness checks, source-level tests, and lineage visibility.

## 13) Strong learning combo
- Python/PySpark for ingestion-heavy work
- dbt for maintainable SQL transformation layer

Tech note:
- This split aligns ownership: ingestion reliability in code, analytics contracts in dbt.


## 15) Architecture picture
Source (CSV/API/DB)
-> Bronze (raw)
-> dbt models
-> Silver (cleaned)
-> dbt models
-> Gold (business-ready)
-> BI/Reports/Apps

Tech note:
- Add tests between layers so contract violations are caught before propagating.

## 16) Template Recap
- Concept: dbt is the SQL-first transformation layer in ELT, usually strongest in Silver and Gold.
- Tech note: source/ref-driven DAG plus materialization choices control lineage, performance, and cost behavior.
- Learning takeaway: explain dbt as transformation framework on warehouse compute, not orchestration or storage.
- Quick command/example: `dbt run --select models/silver`
