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

### Mac frontend runtime

- Canonical repo/runtime: `bankst-os-frontend`
- Owns: frontend runtime behavior

### Dell mapping environment

- Canonical repo/runtime: `mapping_tools`
- Owns: mapping ingestion automation and Dell-side SQLite generation

## Issue Ownership Convention

- Linear issue assignee = accountable human owner
- Agents may execute work, but are not the canonical assignee

## Open Items

- Placeholder: subsystem-by-subsystem ownership map not yet expanded
- Placeholder: backup owner model not yet defined
