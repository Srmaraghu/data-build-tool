# dbt + Databricks Learning Project

Hands-on dbt project for building a Medallion-style pipeline on Databricks, with practical notes and transcript-driven checkpoints.

This repository includes:
- a working dbt project in start_dbt
- bronze, silver, and gold model layers
- generic and singular tests
- seeds, macros, analyses, and snapshots
- learning notes and transcript artifacts

## Project Goals

- Build a clear Bronze -> Silver -> Gold data workflow.
- Practice dbt source config, refs, testing, snapshots, and macros.
- Capture technical learning in concise notes for revision/interview prep.

## Repository Layout

```text
.
|-- start_dbt/
|   |-- dbt_project.yml
|   |-- models/
|   |   |-- source/
|   |   |-- bronze/
|   |   |-- silver/
|   |   `-- gold/
|   |-- tests/
|   |-- snapshots/
|   |-- seeds/
|   |-- macros/
|   `-- analyses/
|-- Notes/
|-- transcripts/
|-- scripts/
|-- pyproject.toml
`-- main.py
```

## Data Modeling Structure

### Source Layer
- Declared in start_dbt/models/source/sources.yml.
- Uses target-aware catalog selection with {{ target.catalog }}.

### Bronze Layer
- Staging-like models over source tables.
- Includes baseline quality checks such as:
	- not_null
	- unique
	- accepted_values
	- custom generic non-negative test

### Silver Layer
- Business-friendly transformed models.
- Current examples include:
	- silver_returns: cleaned and aggregated returns metrics
	- silver_salesinfo: enriched sales view with customer/product context

### Gold Layer
- Consumption-ready model for latest item state:
	- source_gold_items

## Snapshots

- Snapshot config is in start_dbt/snapshots/gold_items.yml.
- Uses timestamp strategy on updateDate for SCD2-style history tracking.
- Catalog is environment-aware via {{ target.catalog }}.

## Tests

### Generic tests
- Configured in model properties files.
- Built-in tests and accepted_values are used across key fields.

### Custom generic test
- Defined in start_dbt/tests/generic/test_generic_non_negative.sql.
- Reused as test_generic_non_negative.

### Singular test
- start_dbt/tests/test_non_negative_values_fact_sales.sql
- Returns failing rows when gross_amount or net_amount is negative.

## Macros

- start_dbt/macros/multiply.sql
	- utility macro for expression reuse
- start_dbt/macros/generate_schema.sql
	- custom schema naming behavior

## Seeds

- start_dbt/seeds/mapping.csv
- Seed schema is configured under seeds in dbt_project.yml.

## Requirements

- Python 3.13+
- dbt-core >= 1.11.6
- dbt-databricks >= 1.11.6
- Access to Databricks SQL Warehouse

Dependencies are listed in pyproject.toml.

## Setup

From repository root:

```bash
python -m venv .venv
source .venv/bin/activate
pip install -e .
```

If you already use uv:

```bash
uv sync
source .venv/bin/activate
```

## Profile Configuration

The project profile name is start_dbt.

Recommended:
- keep credentials in ~/.dbt/profiles.yml
- avoid storing Databricks tokens in tracked repository files

## Common dbt Commands

Run these from start_dbt:

```bash
dbt debug
dbt seed
dbt run
dbt test
dbt snapshot
dbt docs generate
dbt docs serve
```

Targeted examples:

```bash
dbt run --select models/bronze
dbt run --select models/silver
dbt test --select silver_returns
```

## Learning Assets

- notes/: compact module-style notes from setup to deployment workflow

## Deployment and Git Workflow

Typical flow used in this repo:

1. Make model/test changes.
2. Run dbt run + dbt test locally.
3. Stage only intended files.
4. Use clear commit messages (feature/docs split when useful).
5. Push to origin/main.

## Troubleshooting

- If dbt debug fails on project path, ensure commands run inside start_dbt.
- If test failures occur on accepted_values, inspect casing and whitespace.
- If source references fail, verify catalog/schema/table names in sources.yml.

## License

This project is open source under the MIT License. See the LICENSE file for details.

