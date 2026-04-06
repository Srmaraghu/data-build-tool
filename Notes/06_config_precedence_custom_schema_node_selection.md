# Config Precedence + Custom Schema + Node Selection


## 1) Config in dbt: where can it be defined?
You saw 3 places:
- project level: dbt_project.yml
- properties level: model properties YAML
- block level: inside model SQL using config()

Tech note:
- Config scope determines both inheritance behavior and override granularity.

## 2) Precedence order (important)
Most specific wins.

Order:
1. block-level config (highest)
2. properties YAML config
3. dbt_project.yml config (lowest)

Learning takeaway:
- If the same config key is set in all three places, dbt uses the closest config to the model.

Tech note:
- This follows specificity-first resolution to minimize accidental global overrides.

## 3) Practical example from your flow
- project-level set bronze models as table
- properties file set specific models (like bronze_date, bronze_product) as view
- block-level config in a model can override both

Result:
- mixed outputs possible (some views, some tables) based on precedence.

## 4) Properties file purpose
A model properties YAML can contain:
- model metadata
- tests
- configs

In practice, this is commonly used for config overrides.

Tech note:
- Properties YAML is also where model docs, tests, and metadata contracts are centralized.

## 5) Common runtime issue you saw
Token expired in Databricks profile.

Fix:
- generate new token in Databricks
- update token in profiles.yml
- rerun dbt command

Tech note:
- Auth expiry is operational, not modeling failure; refresh credentials before debugging SQL.

## 6) Custom schema per layer
Goal:
- bronze models in bronze schema
- silver models in silver schema
- gold models in gold schema

You configured schema in dbt_project.yml by layer.

## 7) Why default schema prefix appears
dbt uses schema generation logic via macro behavior.
If not customized, dbt may append/prefix using default target schema.

Tech note:
- This default behavior prevents collisions across users/environments in shared warehouses.

## 8) Macro used for schema behavior
Key macro concept:
- generate_schema_name controls final schema naming behavior.

You created a macro file and adjusted logic to get exact schema names.

Outcome:
- schemas like bronze/silver/gold created as intended (without unwanted default prefix pattern).

Tech note:
- Override schema-generation macros carefully; this affects all model relation naming.

## 9) Node selection (core concept)
Node selection lets you run only specific parts of the DAG.

Why useful:
- faster dev cycles
- targeted debugging
- avoid full project runs for small changes

Tech note:
- Selection semantics are graph-aware, enabling incremental, dependency-scoped workflows.

## 10) Node selection commands you practiced
Run one model:
```bash
dbt run --select bronze_date
```

Run multiple models:
```bash
dbt run --select "bronze_date bronze_store"
```

Run a folder path:
```bash
dbt run --select models/bronze
```

Tech note:
- Equivalent path/model selectors can be mixed with state/tag selectors for advanced targeting.

## 11) Why folder selection mattered in your demo
Because only bronze models existed at that stage, selecting models/bronze still ran all six.
If silver/gold existed, folder selection would isolate bronze only.

## 12) Practical learning Q&A
Q: How does dbt resolve conflicting config definitions?
A: By specificity: model SQL config first, then properties YAML, then project-level defaults.

Q: How do you place models into different schemas by layer?
A: Set schema per layer in dbt_project.yml and optionally customize generate_schema_name behavior.

Q: What is node selection?
A: A dbt selector mechanism to run targeted models or paths using --select.

## 13) Fast revision bullets
- config precedence: block > properties > project
- schema by layer can be controlled centrally
- generate_schema_name affects final schema naming
- --select supports model-level and path-level scoped runs

Tech note:
- Selector fluency is a major productivity multiplier in medium/large dbt projects.

## 14) Template Recap
- Concept: dbt config resolution and selector syntax control where/how models are built and run.
- Tech note: schema-generation macros and precedence rules strongly influence final relation names.
- Learning takeaway: practice moving from default schema behavior to layer-specific schemas safely.
- Quick command/example: `dbt run --select models/bronze`
