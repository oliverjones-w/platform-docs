# ADR-001: Source Of Truth Boundaries

Last updated: 2026-04-27
Status: Draft

## Context

This project spans multiple repos and multiple machines. Confusion about source-of-truth boundaries creates execution risk.

## Current Working Boundaries

- `platform-docs` = macro system context
- GitHub board/issues = live work tracking
- Mac `bankst-os-frontend` = authoritative frontend runtime/source
- Dell `mapping_tools` = authoritative mapping ingestion automation/source

## Decision

Draft only. Current working assumption is that the boundaries above should be treated as canonical unless explicitly revised.

## Not Decided Yet

- whether additional repos need formal canonical-owner status
- whether any runtime ownership should move
- whether this ADR should be split into multiple narrower ADRs

## Next Step

- review and explicitly ratify or revise these boundaries
