# dbt Deployment, Environments, Lineage, and Git Workflow

## 1) Why deployment discipline matters
Concept:
- Building models locally is not enough; value comes when pipelines are reproducible in target environments.

Tech note:
- Deployment quality depends on environment configuration, dependency correctness, and automated validation.

Learning takeaway:
- Treat deployment as part of data modeling, not a separate afterthought.

Quick command/example:
```bash
dbt build
```

## 2) Environment separation in dbt
Concept:
- Use distinct environments (for example dev and prod) with separate catalogs/schemas and controlled access.

Tech note:
- Keeping environments separate prevents accidental production impact during development.

Learning takeaway:
- Always design dbt projects with environment boundaries from day one.

Quick command/example:
```text
dev catalog -> development objects
prod catalog -> production objects
```

## 3) profiles.yml as environment connection layer
Concept:
- `profiles.yml` stores warehouse connection details and target definitions used by dbt Core.

Tech note:
- Multiple targets in one profile allow switching execution contexts without changing model SQL.

Learning takeaway:
- Understand target profiles deeply; they are central to safe deployment.

Quick command/example:
```bash
dbt debug
```

## 4) Target variables for dynamic deployment
Concept:
- dbt target context values (like catalog/schema) let SQL and YAML adapt by environment.

Tech note:
- Parameterization avoids hardcoded environment values and keeps one codebase deployable everywhere.

Learning takeaway:
- Prefer dynamic target references over manual per-environment code edits.

Quick command/example:
```jinja
{{ target.catalog }}
```

## 5) Parameterizing source and snapshot configs
Concept:
- Source database/catalog and snapshot database settings should be environment-aware.

Tech note:
- Hardcoded catalog names are a common migration blocker from dev to prod.

Learning takeaway:
- Audit configs for hardcoded identifiers before production rollout.

Quick command/example:
```yaml
database: "{{ target.catalog }}"
```

## 6) Full pipeline deployment command
Concept:
- `dbt build` runs models, tests, seeds, and snapshots in dependency order.

Tech note:
- This command provides the best end-to-end confidence before release.

Learning takeaway:
- Use targeted commands for dev iteration; use build for pre-release confidence.

Quick command/example:
```bash
dbt build --target prod
```

## 7) Common target-switching mistakes
Concept:
- Execution can fail when target names in commands do not match profile target entries.

Tech note:
- Typo-level mistakes in target names can break otherwise-correct deployment workflows.

Learning takeaway:
- Validate target names early with debug before running long builds.

Quick command/example:
```bash
dbt debug --target prod
```

## 9) Lineage for operational visibility
Concept:
- Lineage graph shows upstream/downstream dependencies and helps explain impact of changes.

Tech note:
- Dependency expansion in lineage is essential for root-cause analysis and release-risk evaluation.

Learning takeaway:
- Use lineage before and after release to verify expected dependency behavior.

Quick command/example:
```bash
dbt docs generate
```

## 10) Artifact awareness in deployment
Concept:
- `target/` artifacts expose compiled SQL and execution metadata.

Tech note:
- Artifacts are critical for debugging environment-specific behavior and release regressions.

Learning takeaway:
- In failures, inspect compiled artifacts first before guessing logic errors.

Quick command/example:
```text
Inspect: target/compiled and target/run
```

## 11) Production readiness checklist
- Profile has valid prod target and credentials.
- Environment-specific values are parameterized.
- `dbt build --target prod` succeeds.
- Tests pass on production-like data.
- Lineage and artifacts are reviewed.
- Changes are committed, reviewed, and pushed.

Tech note:
- A checklist-based release gate reduces avoidable production incidents.

## 12) Final Recap
- Concept: reliable dbt delivery combines environment design, parameterization, validation, lineage visibility, and Git workflow discipline.
- Tech note: target-aware configuration plus full build validation is the backbone of safe releases.
- Learning takeaway: production success in dbt is mostly repeatability and control, not only SQL skill.
- Quick command/example: `dbt build --target prod`
