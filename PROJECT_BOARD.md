# Project Board

Last updated: 2026-04-24

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
| `PROJ-001` | Edge Auth And Gateway Identity | Queued | P0 | Unassigned | `SYS-001` | `bankst.co` is not publicly reachable without enforced identity checks |
| `PROJ-002` | Mapping Sync Freshness And Alerting | Queued | P0 | Unassigned | `SYS-002` | Users and operators can see when Dell -> Mac mapping data is stale |
| `PROJ-003` | Frontend Source-Of-Truth Workflow | Ready | P1 | Unassigned | `SYS-003` | Engineers consistently work from the Mac frontend repo without Dell clone confusion |
| `PROJ-004` | Gateway Route Cleanup | Queued | P2 | Unassigned | `SYS-004` | Gateway routing table reflects only live or intentionally documented services |

## Project Briefs

### PROJ-001 — Edge Auth And Gateway Identity

- `Why:` This is the largest structural security gap in the system.
- `Scope:`
  - decide primary auth layer
  - implement identity check at the edge and/or gateway
  - document who can access which environment
- `Decision Needed:`
  - Cloudflare Access only
  - gateway middleware only
  - defense in depth with both
- `Done When:`
  - unauthenticated requests cannot reach protected routes
  - the chosen auth model is documented in system docs
  - operational login flow is tested end-to-end

### PROJ-002 — Mapping Sync Freshness And Alerting

- `Why:` Current transport failures can leave Mac serving stale data silently.
- `Scope:`
  - expose last successful Dell -> Mac sync age
  - surface stale state in operator-facing health checks
  - optionally surface stale state in the UI
- `Done When:`
  - stale mapping data is detectable on the Mac
  - freshness threshold is defined
  - failure is visible without reading Dell logs manually

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

1. Assign owners for `PROJ-001` and `PROJ-002`.
2. Decide the auth pattern for `PROJ-001`.
3. Decide the minimum acceptable freshness signal for `PROJ-002`.
