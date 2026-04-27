# ADR-001: Source Of Truth Boundaries

Last updated: 2026-04-27
Status: Draft

## Context

This project spans multiple repos and multiple machines. Confusion about source-of-truth boundaries creates execution risk.

## Current Working Boundaries

- `platform-docs` = macro system context
- `C:\obsidian-vault` = canonical intelligence files and human-readable system state
- Linear = live work tracking (`linear.app/bankst-os/team/OS`)
- Mac `bankst-os-frontend` = optional frontend runtime/source
- Dell `mapping_tools` = authoritative mapping ingestion automation/source
- Postgres / SQLite / APIs / dashboards = derived indexes, sensors, or distribution layers unless explicitly promoted

## Decision

Draft only. Current working assumption is that the boundaries above should be treated as canonical unless explicitly revised.

For the current phase, files are the system: Obsidian is the default interface, YAML/markdown are canonical state, and agents are system operators. Databases may project file state for efficient query, but they should be rebuildable from files and should not become a hidden parallel source of truth.

## Not Decided Yet

- whether additional repos need formal canonical-owner status
- whether any runtime ownership should move
- whether this ADR should be split into multiple narrower ADRs
- whether YAML -> Postgres sync should be implemented now or after the vault schema stabilizes

## Next Step

- review and explicitly ratify or revise these boundaries
