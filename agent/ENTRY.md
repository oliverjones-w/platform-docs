# Agent Entry

## System

- Name: `bankst-os`
- Public domain: `bankst.co`
- Frontend repo: `bankst-os-frontend`

## Machines

| Machine | Role | Tailscale IP | Primary user |
|---|---|---|---|
| Dell XPS-15 | Ingestion, automation | `100.125.163.20` | `olive` |
| Mac mini | All live services, runtime | `100.82.94.80` | `dev-server` (services), `oliverjones` (postgres/ops) |

## Source of Truth

| Domain | Authoritative source | GitHub |
|---|---|---|
| Frontend runtime | Mac `~/workspace/apps/bankst-os-frontend` | `oliverjones-w/bankst-os-frontend` |
| Mapping ingestion | Dell `C:\dev\tools\mapping_tools` | `oliverjones-w/mapping_tools` |
| Macro system context | `platform-docs` (this repo) | `oliverjones-w/platform-docs` |
| Live work | GitHub Issues + `bankst-os Platform Board` | — |
| Auth/edge config | `DECISIONS/ADR-002-auth-model.md` + `CLOUDFLARE_ACCESS.md` | — |
| DB schema/migrations | Mac `~/workspace/apps/hf_returns_app/models.py`, Alembic 0001→0009 | — |
| Swarm / agent layer | Mac `~/workspace/services/bankst-swarm` | `oliverjones-w/bankst-swarm` |
| Encore scraper | Mac `~/workspace/services/encore_scraper` | `oliverjones-w/encore_scraper` |

Dell `labs/unified_css` is a stale frontend mirror. It is not authoritative.

## Task Routing

| Task type | Go to |
|---|---|
| Frontend / UI | Mac `~/workspace/apps/bankst-os-frontend` |
| Mapping / HF / IR / BBG | Dell `C:\dev\tools\mapping_tools` |
| Cross-repo or architectural | Read `agent/INFRA.md`, check GitHub board |
| Auth or edge (Cloudflare) | `DECISIONS/ADR-002-auth-model.md` → `CLOUDFLARE_ACCESS.md` |
| Database / Alembic | Mac `~/workspace/apps/hf_returns_app/`, `~/workspace/services/bankst-os/` |
| Ops / incident | `agent/STATE.md` → `RUNBOOKS/` |
| Active project or issue | GitHub board → GitHub issue |

## Agent Files

Read only what the task needs. Stop as soon as you have enough context.

| File | When to read |
|---|---|
| `agent/INFRA.md` | Task touches a specific service, port, DB, SSH target, or machine path |
| `agent/STATE.md` | Task is operational, cross-repo, or references active issues/projects |
| `agent/RULES.md` | Uncertain about agent behavior or ownership boundaries |
| `DECISIONS/` | Task requires understanding why an architectural choice was made |
| `RUNBOOKS/` | Incident response or known failure recovery |
| `CLOUDFLARE_ACCESS.md` | Auth, edge policy, or Cloudflare-specific config |
