# bankst-os

- Public domain: `bankst.co`
- Frontend repo: `bankst-os-frontend`

## Machines

| Machine | Role | Tailscale IP | User |
|---|---|---|---|
| Dell XPS-15 | Ingestion | `100.125.163.20` | `olive` |
| Mac mini | Runtime — all live services | `100.82.94.80` | `dev-server` (services), `oliverjones` (postgres/ops) |

## Source of Truth

| Domain | Path | GitHub |
|---|---|---|
| Frontend runtime | Mac `~/workspace/apps/bankst-os-frontend` | `oliverjones-w/bankst-os-frontend` |
| Mapping ingestion | Dell `C:\dev\tools\mapping_tools` | `oliverjones-w/mapping_tools` |
| Macro context | `platform-docs` | `oliverjones-w/platform-docs` |
| Live work | Linear — `linear.app/bankst-os/team/OS` | — |
| Auth / edge | `DECISIONS/ADR-002` + `CLOUDFLARE_ACCESS.md` | — |
| DB schema / migrations | Mac `~/workspace/apps/hf_returns_app/models.py`, Alembic 0001→0009 | — |
| Swarm / agent layer | Mac `~/workspace/services/bankst-swarm` | `oliverjones-w/bankst-swarm` |
| Encore scraper | Mac `~/workspace/services/encore_scraper` | `oliverjones-w/encore_scraper` |

Dell `labs/unified_css` is a stale mirror. Not authoritative.

## Task Routing

Load only what the task needs. Stop as soon as you have enough.

| Task type | Load next | Skip |
|---|---|---|
| Dell sync / automation / paths | `INFRA_DELL.md` | INFRA_MAC, STATE |
| Mac services / ports / DBs / SSH | `INFRA_MAC.md` | INFRA_DELL, STATE |
| Candidate / Encore data | `INFRA_MAC.md` + product path below | INFRA_DELL, STATE |
| Mapping / HF / IR / BBG data | `INFRA_DELL.md` + `INFRA_MAC.md` | STATE |
| Board / Linear / active work | `STATE.md` | INFRA_* |
| Debugging unexpected behavior | `GOTCHAS.md` — load this whenever something seems off | — |
| Auth / Cloudflare edge | `../DECISIONS/ADR-002-auth-model.md` | INFRA_* |

## Product CLAUDE.md Paths

Go directly to these when the task is repo-specific:

| Repo | Local path |
|---|---|
| Obsidian vault | Dell `C:\obsidian-vault\CLAUDE.md` |
| Encore scraper | Dell `C:\dev\labs\encore_scrape\CLAUDE.md` |
| Mapping tools | Dell `C:\dev\tools\mapping_tools\CLAUDE.md` |
| Frontend | Mac `~/workspace/apps/bankst-os-frontend/CLAUDE.md` |
| Gateway | Mac `~/workspace/apps/gateway/CLAUDE.md` |
| Swarm | Mac `~/workspace/services/bankst-swarm/CLAUDE.md` |
