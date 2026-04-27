# File-Native Intelligence System

Last updated: 2026-04-27

Purpose: define the current architecture philosophy for `bankst-os`.

## Core Position

`bankst-os` is not primarily an app. It is a file-native, agent-operated intelligence system.

For the current phase:

- Obsidian is the default human interface.
- Files are the canonical system state.
- Agents are the primary operators.
- APIs, databases, dashboards, and frontends are optional support layers.

The previous frontend/API work remains valuable, but it is no longer the architectural center. It can return later as a visualization, distribution, or workflow layer.

## Source Of Truth

The canonical intelligence layer lives in the Obsidian vault:

- candidate profiles
- firm profiles
- strategy notes
- relationship edges
- raw notes
- review queues
- local config registries
- generated-but-inspectable YAML

Everything important should be visible, inspectable, and editable as files.

## Operating Pattern

```text
external signal
  -> ingestion script / API / scraper
  -> agent or deterministic processor
  -> file update in Obsidian
  -> human review when ambiguous
  -> derived index / API / dashboard if useful
```

Examples:

- FINRA scraper -> CSV/export -> profile YAML `finra_id`
- call notes -> `raw.md` -> generated candidate profile
- firm alias edit -> firm hub note sync
- news ingestion -> candidate/firm/source notes and review queue

## Canonical Vs Derived

Canonical:

- Markdown notes
- YAML frontmatter in notes
- append-only `raw.md`
- firm and strategy hub notes
- review queues where human decisions are made
- local config JSON when it defines identity, taxonomy, or mapping rules

Derived:

- SQLite databases
- Postgres tables
- API responses
- dashboards
- search indexes
- generated reports
- frontend views

Derived layers may be operationally important, but they do not silently supersede vault files.

## Agents As Operators

Agents should operate the system by:

- reading files
- interpreting new information
- updating YAML and markdown
- maintaining graph structure
- creating review queues for ambiguity
- preserving provenance and source timestamps

Agents should not:

- hide important state in a database only
- overwrite human-authored raw notes
- resolve identity conflicts silently
- create parallel source-of-truth systems

## YAML To Postgres Position

Postgres is useful as a projection of vault data.

The preferred model is:

```text
Obsidian YAML / markdown
  -> deterministic sync/indexer
  -> Postgres tables
  -> fast query, analytics, APIs, optional frontend
```

Postgres should store structured projections of YAML so the system can query efficiently without agents manually reading every file each time.

However, Postgres should not become a second hidden source of truth. Writes should normally flow:

```text
agent/human intent -> file update -> sync to Postgres
```

Direct Postgres writes are acceptable only for derived state or when a reverse-sync path writes the change back to files with clear conflict handling.

## Sync Rules

Any YAML -> Postgres sync should be:

- deterministic
- idempotent
- rebuildable from files
- explicit about canonical fields
- explicit about derived fields
- able to report parse errors and conflicts into a vault review queue

Minimum metadata for projected records:

- source file path
- source content hash
- parsed timestamp
- schema version
- sync status
- last error, if any

## Design Bias

Prefer:

- files over hidden state
- scripts over services
- deterministic processors over complex abstractions
- review queues over silent guesses
- rebuildable indexes over hand-maintained databases

Avoid:

- frontend-first workflow design
- API contracts before file contracts
- manual database maintenance
- opaque sync behavior
- premature multi-user product assumptions

## Current Priority

The near-term work is to strengthen the file-native layer:

1. Stabilize profile and firm YAML schemas.
2. Define derived index rules.
3. Create reliable YAML -> Postgres projection if query speed or analytics require it.
4. Keep ingestion APIs and scrapers as sensors feeding files.
5. Use frontends only where they reduce friction without becoming canonical.
