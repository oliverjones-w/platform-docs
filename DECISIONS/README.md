# Decisions

Use this directory for architectural decision records (ADRs).

## Purpose

An ADR is for a decision that is:

- cross-repo
- architectural
- likely to affect future work
- worth preserving as reference

Use ADRs to record decisions such as:

- source-of-truth boundaries
- auth model choices
- transport architecture choices
- gateway ownership/routing decisions

Do not use ADRs for:

- implementation notes
- temporary experiments
- unresolved brainstorming without a decision

## Numbering Rules

- Every ADR number must be unique.
- Numbers are chronological and should not be reused.
- Once referenced, an ADR number should remain stable.
- If a draft ADR already exists, the next ADR gets the next available number.

Examples:

- `ADR-001-source-of-truth.md`
- `ADR-002-auth-model.md`

## Minimal ADR Structure

Suggested sections:

- context
- decision
- alternatives considered
- consequences
- related issues / projects

## Current ADR Index

- `ADR-001` - Source Of Truth Boundaries
- `ADR-002` - Auth Model: Cloudflare Access At The Public Edge
