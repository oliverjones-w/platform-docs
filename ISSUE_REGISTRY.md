# Issue Registry

Last updated: 2026-04-27

This file is the durable registry for system-level issues across the Dell / Mac / public-edge stack.

Use it for:

- architectural gaps
- live reliability risks
- security holes
- stale-data hazards
- repo drift / branch convergence risks

Do not use it for:

- one-off debugging notes
- temporary console output
- implementation details that belong in code comments or PRs

## Flag System

Every issue should carry all of these fields:

| Field | Meaning |
|---|---|
| `Issue ID` | Stable identifier, e.g. `SYS-001` |
| `Title` | Short problem statement |
| `Class` | `Security`, `Reliability`, `Data`, `Architecture`, `Workflow`, `Tech Debt` |
| `Severity` | `Critical`, `High`, `Medium`, `Low` |
| `Status` | `Open`, `Planned`, `In Progress`, `Blocked`, `Mitigated`, `Closed`, `Watching` |
| `Environment` | `Dell`, `Mac`, `Shared`, `Public Edge` |
| `Owner` | Responsible person or team |
| `Detected In` | Where the issue was observed |
| `Impact` | What can go wrong |
| `Trigger / Failure Mode` | How it manifests |
| `Next Step` | Immediate action to move it forward |
| `Board Project` | Which project board item owns it |

## Status Meanings

| Status | Meaning |
|---|---|
| `Open` | Confirmed issue with no active implementation |
| `Planned` | Accepted and scoped, work not started |
| `In Progress` | Active implementation underway |
| `Blocked` | Work cannot proceed until a dependency resolves |
| `Mitigated` | Risk reduced, but root cause still exists |
| `Closed` | Root cause resolved and verified |
| `Watching` | Not urgent enough to schedule, but should be monitored |

## Active Issues

### SYS-001 — Missing Auth Layer At The Public/Gateway Edge

- `Class:` Security
- `Severity:` Critical
- `Status:` Closed
- `Environment:` Mac, Public Edge
- `Owner:` Unassigned
- `Detected In:` cross-repo architecture review
- `Impact:` Sensitive hedge fund / firm / returns data may be accessible without a proper identity gate.
- `Trigger / Failure Mode:` Public traffic reaches the Mac-hosted application through Cloudflare Tunnel, while the gateway/service layer has no confirmed application-level auth enforcement.
- `Resolution:` Cloudflare Access confirmed live on `bankst.co` + `*.bankst.co` wildcard. All gateway-routed services covered. Email allowlist verified 2026-04-27. See `DECISIONS/ADR-002-auth-model.md` and `CLOUDFLARE_ACCESS.md`.
- `Closed:` 2026-04-27
- `Board Project:` PROJ-001

### SYS-002 — Silent Stale Mapping Data If Dell -> Mac Sync Fails

- `Class:` Reliability, Data
- `Severity:` High
- `Status:` Mitigated
- `Environment:` Dell, Mac, Shared
- `Owner:` Unassigned
- `Detected In:` Dell `sync_and_push.ps1` + `logs/sync.log`
- `Impact:` Mac can continue serving stale HF / IR / BBG mapping data with no obvious user-facing warning.
- `Trigger / Failure Mode:` Windows Task Scheduler or SCP/Tailscale transfer fails; Dell data refreshes locally but Mac runtime copy stops updating.
- `Resolution:` `platform-docs/scripts/health_snapshot.sh` exposes per-DB freshness ages from the Mac side with a 90-min stale threshold. Operators and agents can run it without shell access to Dell logs. Verified 2026-04-27.
- `Next Step:` Optionally surface stale state in the frontend UI (banner/indicator). Not yet implemented.
- `Board Project:` PROJ-002

### SYS-003 — Frontend Repo Drift Between Dell Mirror And Mac Source Of Truth

- `Class:` Workflow, Architecture
- `Severity:` Medium
- `Status:` Watching
- `Environment:` Dell, Mac, Shared
- `Owner:` Unassigned
- `Detected In:` repo audit
- `Impact:` Engineers can make incorrect assumptions from the stale Dell frontend clone and miss live behavior on the Mac.
- `Trigger / Failure Mode:` Dell `unified_css` clone falls behind GitHub/Mac and still contains local modifications.
- `Next Step:` Keep authoritative frontend work on the Mac and use Dell frontend clone only as a non-authoritative reference.
- `Board Project:` PROJ-003

### SYS-004 — Unused Gateway Route `/system -> :9000`

- `Class:` Tech Debt, Architecture
- `Severity:` Low
- `Status:` Watching
- `Environment:` Mac
- `Owner:` Unassigned
- `Detected In:` gateway routing review
- `Impact:` Unused routing creates ambiguity about missing services and intended system shape.
- `Trigger / Failure Mode:` Route remains configured with no backing process or ownership.
- `Next Step:` Either document intended owner/service or remove the dead route.
- `Board Project:` PROJ-004

### SYS-005 — PowerShell `$ErrorActionPreference = Stop` Breaks Sync On Native Command Stderr

- `Class:` Reliability
- `Severity:` High
- `Status:` Closed
- `Environment:` Dell
- `Owner:` Unassigned
- `Detected In:` `mapping_tools/scripts/sync_and_push.ps1` manual run 2026-04-27
- `Impact:` The hourly MappingToolsSync scheduled task silently exits 0 but skips all logging and sync work, leaving Mac serving stale data indefinitely.
- `Trigger / Failure Mode:` `$ErrorActionPreference = "Stop"` at script scope causes PowerShell to treat native command stderr output (e.g. openpyxl `UserWarning`) as a terminating error inside `Invoke-LoggedCommand`. The function throws before checking `$LASTEXITCODE`, even when Python exits 0.
- `Resolution:` `Invoke-LoggedCommand` now sets `$ErrorActionPreference = 'Continue'` locally and explicitly casts `ErrorRecord` objects to strings when logging. Exit code is checked explicitly. Fixed in `sync_and_push.ps1` 2026-04-27. Verified full sync completes cleanly.
- `Closed:` 2026-04-27
- `Board Project:` PROJ-002

## Intake Rules

Add a new issue when all of the following are true:

- the issue affects system behavior, security, data correctness, or delivery workflow
- the issue is likely to persist across sessions unless explicitly tracked
- the issue needs an owner or a decision, not just awareness

## Review Cadence

- Review `Critical` and `High` issues weekly.
- Review `Watching` issues only when architecture or deployment changes.
- When an issue becomes actionable, create or update its board project entry.
