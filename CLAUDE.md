# platform-docs — Agent Bootstrap

This repo is the macro context layer for `bankst-os`.

## When to load agent/ context

**Single-repo task** → the product repo CLAUDE.md is sufficient. Do not load agent/ files.

**Cross-repo, cross-machine, ambiguous ownership, infra/service routing, or architectural task** → read `agent/ENTRY.md`, then stop unless the task needs more.

## Task routing

| Task | Read |
|---|---|
| Frontend / UI | `agent/ENTRY.md` → Mac `~/workspace/apps/bankst-os-frontend` |
| Mapping / HF / IR / BBG | `agent/ENTRY.md` → Dell `C:\dev\tools\mapping_tools` |
| Mac services / ports / DBs | `agent/INFRA_MAC.md` |
| Dell sync / automation / paths | `agent/INFRA_DELL.md` |
| Auth / Cloudflare edge | `DECISIONS/ADR-002-auth-model.md` → `CLOUDFLARE_ACCESS.md` |
| DB / Alembic migrations | `agent/INFRA_MAC.md` → Mac `~/workspace/apps/hf_returns_app/` |
| Ops / incident | `agent/STATE.md` → `RUNBOOKS/` |
| Active project or issue | Linear — `linear.app/bankst-os/team/OS` |
| Unexpected behavior / debugging | `agent/GOTCHAS.md` |
| Architecture decisions | `DECISIONS/` |

## Agent files

| File | Contents |
|---|---|
| `agent/ENTRY.md` | Canonical names, machines, source-of-truth table — cross-repo orientation |
| `agent/INFRA_MAC.md` | Mac services, ports, DBs, SSH — Mac-side tasks |
| `agent/INFRA_DELL.md` | Dell paths, sync, automation — Dell-side tasks |
| `agent/STATE.md` | Pointers to Linear board and runtime health snapshot |
| `agent/GOTCHAS.md` | System-specific traps — read when debugging unexpected behavior |

## Human reference

Root-level markdown files (SYSTEM_MAP.md, WORKING_RULES.md, ONBOARDING.md, etc.) are the human reference layer. Agents do not need them for most tasks.
