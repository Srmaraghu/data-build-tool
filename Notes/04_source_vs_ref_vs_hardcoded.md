# source vs ref vs hardcoded names (Learning Note)

This note helps you explain dependency modeling choices in dbt clearly.

## 1) Quick mental model
- source(): for raw existing tables not built by current dbt project
- ref(): for models built by dbt in the same project or installed packages
- hardcoded table names: avoid in dbt models except rare temporary debugging

Learning takeaway:
- source connects dbt to upstream raw data, ref connects dbt models to each other.

Tech note:
- Both source and ref create graph edges; hardcoded names do not.

## 2) What source() means
Use source() when table already exists in platform and is declared in YAML.

Typical usage:
- raw ingestion tables
- landing/source schema tables
- external tables managed outside current dbt model DAG

Why it matters:
- lineage shows true upstream source nodes
- easier rename/change management via YAML centralization
- enables source tests and freshness checks

Tech note:
- source() resolves to declared metadata, reducing direct dependency on physical naming churn.

## 3) What ref() means
Use ref() when selecting from another dbt model.

What ref gives automatically:
- dependency ordering
- environment-aware relation resolution
- cleaner lineage graph
- safer renaming and modularity

Tech note:
- ref() also enables state-aware and selector-based workflows in larger projects.

## 4) Why hardcoded names are risky
Hardcoded full table names create maintenance and portability issues.

Problems:
- breaks when catalog/schema/object names change
- weak lineage in dbt docs graph
- brittle across dev/stage/prod environments
- harder refactoring

Tech note:
- Hardcoding is one of the fastest ways to introduce environment drift defects.

## 5) Wrong vs right: raw table reference
### Wrong (hardcoded)
```sql
select *
from dbt_tutorial_dev.source.fact_sales
```

### Right (source)
```sql
select *
from {{ source('source', 'fact_sales') }}
```

Why right is better:
- central metadata in source YAML
- portable and cleaner lineage

## 6) Wrong vs right: model-to-model reference
Assume you already have a model named stg_sales.

### Wrong (hardcoded model object)
```sql
select *
from dbt_tutorial_dev.default.stg_sales
```

### Right (ref)
```sql
select *
from {{ ref('stg_sales') }}
```

Why right is better:
- dbt knows DAG dependency
- model rename/refactor is safer

## 7) Minimal source YAML example
```yaml
version: 2

sources:
  - name: source
    database: dbt_tutorial_dev
    schema: source
    tables:
      - name: fact_sales
      - name: fact_returns
      - name: dim_customer
      - name: dim_product
      - name: dim_store
      - name: dim_date
```

Use in SQL:
```sql
select *
from {{ source('source', 'dim_customer') }}
```

## 8) Decision rules (fast)
Use source() when:
- relation exists before dbt model build
- relation is owned by ingestion platform or external pipeline

Use ref() when:
- relation is produced by another dbt model
- you want dependency-managed model chaining

Avoid hardcoded names when:
- writing production dbt models
- building shared team pipelines

Tech note:
- Exception: temporary ad hoc debugging queries outside production DAG models.

## 9) Common learning checks
Q: difference between source and ref?
A: source points to existing raw tables declared in YAML, while ref points to dbt models and builds DAG dependencies.

Q: can ref point to non-dbt external table?
A: no, external/raw tables should be declared as sources and referenced through source().

Q: why avoid hardcoded relation names?
A: they reduce portability, break lineage clarity, and create environment-specific brittle SQL.

Q: where should source metadata live?
A: in source YAML files under models, usually in a dedicated source or sources folder.

## 10) Common beginner mistakes
- using ref for raw ingestion table not modeled in dbt
- using hardcoded catalog.schema.table inside every model
- forgetting to declare source in YAML before calling source()
- mixing source and ref randomly without layer design

Tech note:
- Layer contracts (bronze/silver/gold) help choose source vs ref consistently.

## 11) Layer-wise guidance (medallion)
- Bronze: mostly source() from raw tables
- Silver: ref() from bronze models
- Gold: ref() from silver models

This keeps lineage clean from raw to business marts.

## 12) Validation checklist
1. every raw table used by dbt is declared in source YAML
2. every model-to-model dependency uses ref()
3. no production model contains hardcoded full object names
4. dbt docs lineage clearly shows source nodes and model chain

Tech note:
- Add this checklist to PR review templates to enforce dependency hygiene.

## 13) Template Recap
- Concept: use source() for external raw relations and ref() for dbt-managed model dependencies.
- Tech note: avoiding hardcoded names preserves portability, lineage integrity, and refactor safety.
- Learning takeaway: explain dependency modeling as a maintainability and environment-consistency strategy.
- Quick command/example: `dbt ls --select +my_model`
