# Project Board

Last updated: 2026-04-27

This file is the live board of necessary projects. It converts registry issues into concrete work.

## How To Use This Board

- Keep projects outcome-based, not task-dump based.
- Each project should have one owner.
- Each project should map back to one or more issue IDs.
- Close a project only after the system behavior is verified, not just after code lands.

## Status Legend

| Status | Meaning |
|---|---|
| `Queued` | Important, accepted, not started |
| `Ready` | Scoped and ready for implementation |
| `Active` | In progress |
| `Blocked` | Waiting on a decision or dependency |
| `Review` | Implemented, needs verification |
| `Done` | Verified and complete |

## Live Board

| Project ID | Project | Status | Priority | Owner | Linked Issues | Target Outcome |
|---|---|---|---|---|---|---|
| `PROJ-001` | Edge Auth And Gateway Identity | Done | P0 | Unassigned | `SYS-001` | `bankst.co` is not publicly reachable without enforced identity checks |
| `PROJ-002` | Mapping Sync Freshness And Alerting | Review | P0 | Unassigned | `SYS-002`, `SYS-005` | Users and operators can see when Dell -> Mac mapping data is stale |
| `PROJ-003` | Frontend Source-Of-Truth Workflow | Ready | P1 | Unassigned | `SYS-003` | Engineers consistently work from the Mac frontend repo without Dell clone confusion |
| `PROJ-004` | Gateway Route Cleanup | Queued | P2 | Unassigned | `SYS-004` | Gateway routing table reflects only live or intentionally documented services |

## Project Briefs

### PROJ-001 — Edge Auth And Gateway Identity

- `Status:` Done — 2026-04-27
- `Resolution:` Cloudflare Access confirmed live on `bankst.co` + `*.bankst.co`. Wildcard policy covers all gateway-routed services. Email allowlist verified via API. Auth model documented in `DECISIONS/ADR-002-auth-model.md` and `CLOUDFLARE_ACCESS.md`. Tailscale SSH disabled on Mac; key-based SSH over Tailscale IP operational for all Dell→Mac automation.

### PROJ-002 — Mapping Sync Freshness And Alerting

- `Why:` Current transport failures can leave Mac serving stale data silently.
- `Scope:`
  - ~~expose last successful Dell -> Mac sync age~~ — done via `health_snapshot.sh`
  - ~~surface stale state in operator-facing health checks~~ — done, 90-min threshold
  - ~~fix PowerShell sync bug (SYS-005)~~ — done, verified clean run 2026-04-27
  - optionally surface stale state in the UI — not yet implemented
- `Done When:`
  - stale mapping data is detectable on the Mac ✓
  - freshness threshold is defined ✓ (90 min)
  - failure is visible without reading Dell logs manually ✓
  - _(stretch)_ stale state visible in frontend UI

### PROJ-003 — Frontend Source-Of-Truth Workflow

- `Why:` The Dell frontend clone is stale and can mislead implementation work.
- `Scope:`
  - document Mac repo as authoritative frontend source
  - document Dell clone as non-authoritative
  - document expected GitHub / VS Code remote workflow
- `Done When:`
  - engineer onboarding docs no longer imply Dell frontend is live
  - architecture docs point to the Mac frontend as source of truth

### PROJ-004 — Gateway Route Cleanup

- `Why:` Dead or ownerless routes create ambiguity and weaken trust in the system map.
- `Scope:`
  - audit `/system -> :9000`
  - either remove it or assign/document its intended service owner
- `Done When:`
  - gateway routes match live services or explicitly documented future services

## Next Review

At the next architecture review:

1. Verify PROJ-002 stretch goal — frontend stale-data indicator.
2. Assign owners across all open projects.
3. Assess PROJ-003 (frontend source-of-truth) and PROJ-004 (dead gateway route) for prioritisation.
