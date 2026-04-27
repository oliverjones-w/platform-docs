# Ownership

Last updated: 2026-04-27

Purpose: minimal source-of-truth and accountability map.

## Accountability Model

- Current accountable human owner: `oliverjones-w`
- Current execution model: human-owned, agent-assisted

## Canonical Ownership Boundaries

### `platform-docs`

- Owns: macro system context, operating rules, onboarding, runbooks, ADRs
- Does not own: implementation details inside product repos

### Obsidian vault

- Canonical repo/runtime: `C:\obsidian-vault`
- Owns: candidate profiles, firm profiles, strategy notes, raw notes, review queues, relationship-bearing YAML, and local intelligence automation conventions
- Does not own: derived database projections, external API availability, or productized frontend behavior

### Derived data stores

- Canonical repo/runtime: owning sync/indexer repo or service
- Owns: efficient query, analytics, API serving, search, and optional visualization
- Does not own: canonical identity or intelligence facts unless changes are written back to files with explicit conflict handling

### Mac frontend runtime

- Canonical repo/runtime: `bankst-os-frontend`
- Owns: optional frontend runtime behavior and visualization

### Dell mapping environment

- Canonical repo/runtime: `mapping_tools`
- Owns: mapping ingestion automation and Dell-side SQLite generation

## Issue Ownership Convention

- Linear issue assignee = accountable human owner
- Agents may execute work, but are not the canonical assignee

## Open Items

- Placeholder: subsystem-by-subsystem ownership map not yet expanded
- Placeholder: backup owner model not yet defined
