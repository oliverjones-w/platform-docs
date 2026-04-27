# System State

> Issues and board below are manually maintained — update when status changes.
> Health snapshot is time-stamped — check `LAST_SNAPSHOT.md` for generated date before trusting it.
> To refresh: `bash scripts/health_snapshot.sh --write` (run from Mac).

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

## Health Snapshot

See `LAST_SNAPSHOT.md` for current service status and DB freshness ages.
Check the `Generated:` timestamp at the top before acting on the data — it may be stale.
