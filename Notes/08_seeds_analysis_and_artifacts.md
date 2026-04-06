# Seeds + Analysis + Artifacts

## 1) Seeds in dbt
Concept:
- Seeds are CSV files versioned in your dbt project and loaded as warehouse tables.

Tech note:
- Seed tables are deterministic and ideal for small, stable lookup/mapping datasets.

Learning takeaway:
- Explain seeds as code-managed reference data, not primary ingestion pipelines.

Quick command/example:
```bash
dbt seed
```

## 2) Where seeds are configured
Concept:
- You can set seed behavior in `dbt_project.yml` (for example schema placement).

Tech note:
- Project-level seed config keeps behavior consistent and avoids repeated per-file settings.

Learning takeaway:
- Mention that seed schema can be separated by layer/environment for cleaner governance.

Quick command/example:
```yaml
seeds:
  start_dbt:
    +schema: bronze
```

## 3) Using seeds in models
Concept:
- Once loaded, seeds are referenced like other dbt relations via `ref()`.

Tech note:
- `ref('lookup')` keeps dependency graph explicit and environment-safe.

Learning takeaway:
- Prefer `ref()` over hardcoded names even for seed tables.

Quick command/example:
```sql
select *
from {{ ref('lookup') }}
```

## 4) Analysis folder purpose
Concept:
- `analyses/` holds exploratory SQL you want to keep, but not materialize as models.

Tech note:
- Analysis queries are useful for diagnostics/ad hoc validation without polluting production DAG.

Learning takeaway:
- Distinguish exploratory analysis SQL from production transformation models.

Quick command/example:
```sql
-- analyses/explore.sql
select * from {{ ref('lookup') }}
```

## 5) Generated artifacts visibility
Concept:
- dbt writes generated outputs (compiled SQL and run/test/seed artifacts) into `target/`.

Tech note:
- Artifacts are the source of truth for what dbt actually executed after Jinja compilation.

Learning takeaway:
- Use `target/` inspection to debug model/test behavior and SQL compilation surprises.

Quick command/example:
```bash
dbt run
# inspect target/run/ and target/manifest.json
```

## 6) Tests + seeds + models in one workflow
Concept:
- You can run seeds, models, and tests as part of a consistent quality flow.

Tech note:
- In mature projects, seed refresh + model build + tests are often orchestrated in CI/CD.

Learning takeaway:
- Show that quality checks are integrated with build flow, not an afterthought.

Quick command/example:
```bash
dbt seed
dbt run
dbt test
```

## 7) Commit discipline for dbt projects
Concept:
- You committed completed work before starting the next major topic.

Tech note:
- Small logical commits improve rollback safety and review clarity.

Learning takeaway:
- Mention branch-based workflow and incremental commits for production-grade collaboration.

Quick command/example:
```bash
git add .
git commit -m "seeds and tests"
```

## 8) Jinja + macros readiness
Concept:
- After seeds, analysis, and artifacts, the next high-value concept is Jinja and macros.

Tech note:
- Jinja is the templating layer that turns repetitive static SQL into programmable SQL patterns.

Learning takeaway:
- Frame Jinja/macros as maintainability and scalability tools for transformation codebases.

Quick command/example:
```text
Next focus: Jinja variables, loops, conditions, macros
```

## 9) Template Recap
- Concept: you established seed-based lookup workflow, analysis-query usage, and artifact-aware debugging habits.
- Tech note: this setup creates a strong base before entering Jinja/macro abstraction patterns.
- Learning takeaway: describe this as the shift from basic modeling to maintainable engineering workflows.
- Quick command/example: `dbt seed && dbt test`
