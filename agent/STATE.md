# System State

Refresh: `bash scripts/health_snapshot.sh --write` (run from Mac)

## Open Issues

| ID | Title | Class | Severity | Status |
|---|---|---|---|---|
| SYS-002 | Silent stale mapping data if Dell→Mac sync fails | Reliability, Data | High | Mitigated — health_snapshot.sh covers detection; UI stale indicator not yet built |
| SYS-003 | Frontend repo drift (Dell mirror vs Mac source of truth) | Workflow | Medium | Watching |
| SYS-004 | Dead gateway route `/system → :9000` | Tech Debt | Low | Watching |

## Project Board

| ID | Project | Status | Priority |
|---|---|---|---|
| PROJ-001 | Edge Auth And Gateway Identity | Done | P0 |
| PROJ-002 | Mapping Sync Freshness And Alerting | Review | P0 |
| PROJ-003 | Frontend Source-Of-Truth Workflow | Ready | P1 |
| PROJ-004 | Gateway Route Cleanup | Queued | P2 |

PROJ-002 stretch goal outstanding: surface stale state in frontend UI.

## Last Health Snapshot

Generated: 2026-04-27 00:50:50

| DB | Age | Status |
|---|---|---|
| hf_map | 56h 24m | STALE |
| ir_map | 56h 24m | STALE |
| bbg_results | 56h 24m | STALE |
| candidate_sync | 135h 32m | STALE |

Last Dell sync completed: 2026-04-24 16:26:21
Last error: 2026-04-26 23:29:20 — SCP hf_map.db failed (exit 255)

Run `bash scripts/health_snapshot.sh --write` to update this file with current Mac state.
