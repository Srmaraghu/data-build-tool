# dbt Snapshots: SCD Type 2 and History Tracking

## 1) Why snapshots are needed
Concept:
- Source tables often change in place (mutable rows), but analytics needs historical states.

Tech note:
- dbt snapshots capture row-version history over time to implement SCD Type 2 behavior.

Learning takeaway:
- Use snapshots when you must answer "what was true at that time" questions.

Quick command/example:
```bash
dbt snapshot
```

## 2) SCD Type 1 vs Type 2 in practice
Concept:
- Type 1 overwrites old values; Type 2 preserves old and new values with validity windows.

Tech note:
- Snapshot outputs include validity metadata columns (for example dbt valid-from / valid-to fields).

Learning takeaway:
- If history matters, Type 2 is the correct modeling pattern.

Quick command/example:
```text
Type 1: update in place
Type 2: add new version + expire previous version
```

## 3) Current snapshot configuration style
Concept:
- Modern snapshot configuration is written in YAML (newer style), while older SQL-style snapshot syntax is legacy.

Tech note:
- Prefer the current YAML-first style for maintainability and forward compatibility.

Learning takeaway:
- Follow current docs patterns to avoid technical debt from deprecated syntax.

Quick command/example:
```yaml
snapshots:
  - name: gold_items
```

## 4) Recommended source relation for snapshots
Concept:
- Feed snapshots from a cleaned/deduplicated relation, not from raw mutable rows directly.

Tech note:
- A pre-snapshot model can enforce one current row per business key before snapshot processing.

Learning takeaway:
- Dedup-before-snapshot prevents key ambiguity and noisy history.

Quick command/example:
```sql
with dedup as (
  select *,
         row_number() over (partition by id order by updateDate desc) as rn
  from {{ source('source', 'items') }}
)
select id, name, category, updateDate
from dedup
where rn = 1
```

## 5) Snapshot strategy choice
Concept:
- Snapshot strategies decide how dbt detects row changes.

Tech note:
- Timestamp strategy is commonly preferred when a reliable updated-at column exists.

Learning takeaway:
- Use timestamp strategy when source systems provide trustworthy update timestamps.

Quick command/example:
```yaml
config:
  strategy: timestamp
  updated_at: updateDate
```

## 6) Unique key in snapshots
Concept:
- Snapshot requires a stable business key to track row versions.

Tech note:
- The key identifies the entity; updated_at determines when a new version should be created.

Learning takeaway:
- Pick a true business identifier (for example id), not a volatile field.

Quick command/example:
```yaml
config:
  unique_key: id
```

## 7) Valid-to behavior and open records
Concept:
- Active (current) row versions stay open until a change arrives.

Tech note:
- You can keep valid-to as NULL or set a far-future sentinel date using snapshot config.

Learning takeaway:
- Choose one standard and apply it consistently across your reporting layer.

Quick command/example:
```yaml
config:
  dbt_valid_to_current: "to_date('9999-12-31')"
```

## 8) Why dbt snapshot can fail initially
Concept:
- Running snapshot before its upstream model/relation exists can fail.

Tech note:
- Snapshot command only runs snapshot nodes; it does not auto-build missing model dependencies.

Learning takeaway:
- Ensure dependencies exist first, or run build for full DAG orchestration.

Quick command/example:
```bash
dbt build
```

## 9) dbt build as orchestration command
Concept:
- dbt build runs models, seeds, snapshots, and tests in dependency order.

Tech note:
- It is the most practical command for end-to-end validation in development and CI.

Learning takeaway:
- Prefer build when validating full pipeline behavior, not isolated node behavior.

Quick command/example:
```bash
dbt build
```

## 10) How to validate SCD Type 2 output
Concept:
- After source changes, snapshot should contain both old and new versions for the same key.

Tech note:
- Previous version gets closed (valid-to set), new version becomes current (open valid-to pattern).

Learning takeaway:
- Always test snapshots by simulating updates on existing keys.

Quick command/example:
```sql
select id, name, dbt_valid_from, dbt_valid_to
from {{ ref('gold_items') }}
order by id, dbt_valid_from
```

## 11) Typical quality checks for snapshot tables
Concept:
- Snapshot quality should be validated with structural and temporal checks.

Tech note:
- Common checks: unique current row per key, no overlapping validity windows, valid-from <= valid-to.

Learning takeaway:
- History tables need temporal correctness, not only null/unique checks.

## 12) Common mistakes to avoid
- Using unstable keys as unique_key.
- Using low-quality timestamps with timezone/precision drift.
- Running snapshots without building required upstream models.
- Assuming snapshot alone replaces all dimensional modeling practices.

Tech note:
- Snapshot captures row history; downstream marts still need business modeling decisions.

## 13) Fast revision bullets
- Snapshots implement SCD Type 2 in dbt.
- Use a clean, deduped relation as snapshot input.
- Prefer timestamp strategy with reliable updated-at columns.
- Configure unique key and valid-to policy deliberately.
- Validate results by updating source records and rerunning build/snapshot.

## 14) Template Recap
- Concept: snapshot modeling preserves history for mutable entities and enables point-in-time analytics.
- Tech note: strategy, unique key, and validity-window behavior define correctness.
- Learning takeaway: treat snapshots as a first-class historical data contract, not just a feature toggle.
- Quick command/example: `dbt build`
