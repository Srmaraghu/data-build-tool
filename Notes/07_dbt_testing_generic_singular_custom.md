# dbt Testing: Generic + Singular + Custom Generic

## 1) Why dbt tests matter
In real data engineering, transformation is not enough. You must validate quality.

Tech note:
- In production, test failures are often the earliest signal of upstream contract drift.

Typical risks:
- duplicate keys
- nulls in mandatory columns
- invalid domain values
- business-rule violations

Learning takeaway:
- dbt tests convert data quality expectations into executable checks.

## 2) Main test categories
You covered:
- generic tests
- singular tests
- custom generic tests
- test severity control (error vs warn)

## 3) Generic tests (built-in)
Most used built-in generic tests:
- not_null
- unique
- accepted_values
- relationships

Where defined:
- in model properties YAML at column level

Example idea from your flow:
- primary key columns like sales_id/store_sk should be unique + not_null.

Tech note:
- Apply built-in tests first on key columns before writing any advanced custom checks.

## 4) accepted_values pattern
Use accepted_values when a column must be from a fixed set.

Example use case:
- store_name or country must match known allowed values.

Important update you saw:
- accepted_values may require arguments.values style in newer syntax patterns.

Tech note:
- accepted_values is best for stable domains; avoid strict lists for highly dynamic source fields.

## 5) Running tests
Core command:
```bash
dbt test
```

Behavior:
- each test is evaluated
- failing tests are reported with detail
- pass/warn/error summary is printed


## 6) Test severity control
Sometimes failure should not block the pipeline.

You applied config severity to treat a failing test as warning.

Practical meaning:
- hard rule -> error
- soft quality expectation -> warn

Tech note:
- Track warn tests in backlog; warn should be temporary, not permanent policy.

## 7) Singular tests
Singular test = custom SQL assertion.

Rule of singular tests:
- your SQL should return zero rows to pass
- if rows are returned, test fails

Practical pattern:
- validate numeric fields are non-negative
- e.g. gross_amount < 0 or net_amount < 0 should return no rows

Tech note:
- Singular tests are ideal for business logic that spans multiple columns/tables.

## 8) Using ref inside singular tests
Instead of hardcoding relation names, use ref for model references.

Benefit:
- lineage-safe dependency handling
- environment-safe object resolution

Tech note:
- A singular test that uses ref is more portable across dev/stage/prod targets.

## 9) Custom generic tests
You also built a reusable custom generic test.

Concept:
- write a generic test template with parameters (model, column_name)
- reuse across multiple models/columns

Why this is powerful:
- one test logic reused everywhere
- cleaner maintenance than repeating many singular tests

Tech note:
- If identical validation appears in 3+ places, convert to custom generic test.

## 10) Where tests live
- generic built-in configs: model properties YAML
- singular tests: tests folder SQL files
- custom generic tests: generic test definition files + YAML usage


## 11) Typical debugging you saw
A failing accepted_values test can be due to:
- spelling mismatch
- case mismatch
- hidden whitespace
- wrong expected list

Debug approach:
1. inspect actual values in source/model
2. compare against accepted list
3. decide error vs warn based on business criticality

Tech note:
- Add normalization in Silver layer (trim/case standardization) before strict domain tests.

## 12) Common Questions
Q: Difference between generic and singular tests?
A: Generic tests are reusable built-in patterns configured in YAML; singular tests are custom SQL assertions that pass when zero rows are returned.

Q: When should you use warn severity?
A: For non-critical quality checks that should be visible but not block deployments.

Q: Why custom generic tests?
A: To standardize recurring custom validation logic and apply it across many models.


## 13) Fast revision bullets
- dbt test is first-class quality gate
- built-in generic tests cover common constraints
- singular tests cover business-specific logic
- custom generic tests scale reusable custom checks
- severity lets you balance strictness and operational flexibility


## 14) Technical depth add-on
### How dbt executes tests under the hood
- Generic tests compile into SQL queries generated from test macros.
- Singular tests execute your SQL file directly as a test node.
- Pass condition for both styles is effectively the same: query returns zero failing rows.
- If rows are returned, dbt treats them as failures and reports count/details.

### Generic test internals
- not_null checks column is never null.
- unique checks grouped duplicates for a column.
- accepted_values checks column domain membership against allowed list.
- relationships checks referential integrity between child and parent keys.

### Severity behavior
- severity: error makes CI/build fail on test failure.
- severity: warn surfaces quality issue without hard fail.
- Good production strategy: keep business-critical integrity as error, use warn temporarily during source cleanup/migrations.

### Singular vs custom generic design choice
- Singular test is best when validation is one-off and query-heavy.
- Custom generic test is best when same rule repeats across many models/columns.
- If you copy-paste the same singular logic multiple times, convert it to custom generic.

### Performance and operational notes
- Running dbt test for entire project can be expensive at scale.
- Prefer scoped runs during development:
	- dbt test --select model_name
	- dbt test --select path:models/bronze
- On large models, test query patterns should avoid unnecessary full scans where possible.

### Practical quality layering pattern
- Bronze: basic structural checks (not_null, unique on expected keys, accepted_values where stable).
- Silver: business conformance checks, relationships, dedup assumptions.
- Gold: KPI and reporting-level contract checks (nullability, grain uniqueness, business rules).

### Common production mistakes to avoid
- Treating all tests as warn forever (quality debt accumulates).
- Overusing accepted_values on highly dynamic source fields.
- Writing singular tests without clear grain assumption.
- Forgetting to document why a test is warn instead of error.

## 15) 20-second technical summary
This note covers dbt data quality checks using built-in generic tests, singular SQL tests for business logic validation, severity control for fail vs warn behavior, and reusable custom generic test patterns for scalable quality enforcement across models.
