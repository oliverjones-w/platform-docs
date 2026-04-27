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
