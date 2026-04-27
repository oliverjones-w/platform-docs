# Agent Rules

## Do

- Read `agent/ENTRY.md` first. Stop as soon as you have enough context.
- Use GitHub Issues and the `bankst-os Platform Board` for cross-repo or system-level work.
- Use canonical naming: `bankst-os`, `bankst.co`, `bankst-os-frontend`.
- Treat the Mac `bankst-os-frontend` repo as authoritative for frontend work.
- Treat Dell `mapping_tools` as authoritative for mapping ingestion.
- Surface system risks (broken transport, stale data, missing auth, dead routes) by filing or updating an issue.
- Update docs only in the repo that owns that context.

## Do Not

- Invent alternate naming or alternate tracking systems outside GitHub.
- Treat Dell `unified_css` as an authoritative frontend source — it is a stale mirror.
- Create shadow project plans outside the GitHub board.
- Assume a local clone is current — verify against GitHub or the Mac runtime.
- Bury system risks in code comments or chat only.

## Ownership

- Accountable human owner: `oliverjones-w`
- GitHub issue assignee = accountable human owner
- Agents execute; agents are not the canonical issue assignee
- Execution modes: `human-only` / `agent-assisted` / `agent-led`
