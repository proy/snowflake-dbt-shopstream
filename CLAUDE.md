# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project status

This is a learning project scaffolding a Snowflake + dbt + AWS + Airflow stack. The dbt project
(`shopstream/`) is currently the unmodified dbt starter (`models/example/`) — no real models have
been built against the domain data yet. `sample-data-project/` contains raw CSVs (customers, orders,
order_items, payments, products, inventory, returns, reviews, shipments, stores, suppliers,
employees) that represent the intended source data for this project but are not yet loaded as dbt
seeds or sources. There is no `dags/` folder yet despite Airflow being referenced in `.env.example`
and the devcontainer.

## Development environment

This project is meant to be developed inside the devcontainer (`.devcontainer/`), which builds a
Python 3.12 image with dbt, the Snowflake adapter, AWS CLI v2, and Airflow preinstalled.

- Copy `.env.example` -> `.env` and fill in real Snowflake/AWS/Airflow values (`.env` is gitignored).
- Copy `profiles.yml.example` -> `~/.dbt/profiles.yml` inside the container. Profile name must stay
  `shopstream` to match `profile:` in `shopstream/dbt_project.yml`. All values are pulled from env
  vars — never hardcode credentials into `profiles.yml`.
- `postCreateCommand` installs pre-commit hooks automatically on container creation.

## Common commands

All dbt commands are run from the `shopstream/` directory (that's where `dbt_project.yml` lives):

```bash
cd shopstream
dbt run                        # build all models
dbt run --select my_first_dbt_model   # build a single model
dbt test                       # run all tests
dbt test --select my_first_dbt_model  # run tests for a single model
dbt build                      # run + test in DAG order
dbt clean                      # remove target/ and dbt_packages/
```

Linting (sqlfluff, Snowflake dialect, dbt-Jinja-aware) runs via pre-commit:

```bash
pre-commit run --all-files
pre-commit run sqlfluff-lint --files shopstream/models/example/my_first_dbt_model.sql
```

## Architecture notes

- `shopstream/` is the dbt project root — `model-paths`, `seed-paths`, `macro-paths`, etc. are all
  configured in `shopstream/dbt_project.yml`. Any new dbt resources (models, seeds, snapshots,
  macros, tests, analyses) go under `shopstream/<type>/`.
- Model materialization is configured per-directory in `dbt_project.yml` under `models: shopstream:`
  (currently only `example/` is set, to `view`). Follow this pattern (`+materialized:` per folder)
  rather than setting materialization ad hoc in individual model files.
- `sample-data-project/*.csv` is raw source data, not yet part of the dbt project. When building
  real models, these will likely need to become dbt seeds (moved under `shopstream/seeds/`) or
  external Snowflake sources — check which approach the user wants before assuming.
- sqlfluff is configured for the Snowflake dialect with the dbt templater (see
  `.pre-commit-config.yaml` and the devcontainer's VS Code settings) — SQL must be valid Jinja-dbt
  SQL, not raw SQL, for linting to resolve `ref()`/`source()` calls correctly.
- Secrets detection (`detect-secrets`) and dbt-checkpoint hooks are present in
  `.pre-commit-config.yaml` but currently commented out.
