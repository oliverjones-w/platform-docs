# Issue Registry

Last updated: 2026-04-24

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
- `Status:` Open
- `Environment:` Mac, Public Edge
- `Owner:` Unassigned
- `Detected In:` cross-repo architecture review
- `Impact:` Sensitive hedge fund / firm / returns data may be accessible without a proper identity gate.
- `Trigger / Failure Mode:` Public traffic reaches the Mac-hosted application through Cloudflare Tunnel, while the gateway/service layer has no confirmed application-level auth enforcement.
- `Next Step:` Decide and implement the first-line auth model: Cloudflare Access, gateway auth middleware, or both.
- `Board Project:` PROJ-001

### SYS-002 — Silent Stale Mapping Data If Dell -> Mac Sync Fails

- `Class:` Reliability, Data
- `Severity:` High
- `Status:` Open
- `Environment:` Dell, Mac, Shared
- `Owner:` Unassigned
- `Detected In:` Dell `sync_and_push.ps1` + `logs/sync.log`
- `Impact:` Mac can continue serving stale HF / IR / BBG mapping data with no obvious user-facing warning.
- `Trigger / Failure Mode:` Windows Task Scheduler or SCP/Tailscale transfer fails; Dell data refreshes locally but Mac runtime copy stops updating.
- `Next Step:` Add sync freshness reporting on the Mac side and alerting / UI visibility when data age exceeds threshold.
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

## Intake Rules

Add a new issue when all of the following are true:

- the issue affects system behavior, security, data correctness, or delivery workflow
- the issue is likely to persist across sessions unless explicitly tracked
- the issue needs an owner or a decision, not just awareness

## Review Cadence

- Review `Critical` and `High` issues weekly.
- Review `Watching` issues only when architecture or deployment changes.
- When an issue becomes actionable, create or update its board project entry.
