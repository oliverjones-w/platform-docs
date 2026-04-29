# Issue Registry

Last updated: 2026-04-29

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
| `Linear Issue` | Which Linear issue owns it (`OS-N`) |

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
- `Status:` Closed
- `Environment:` Dell, Mac, Shared
- `Owner:` Unassigned
- `Detected In:` Dell `sync_and_push.ps1` + `logs/sync.log`
- `Impact:` Mac can continue serving stale HF / IR / BBG mapping data with no obvious user-facing warning.
- `Trigger / Failure Mode:` Windows Task Scheduler or SCP/Tailscale transfer fails; Dell data refreshes locally but Mac runtime copy stops updating.
- `Resolution:` `platform-docs/scripts/health_snapshot.sh` exposes per-DB freshness ages from the Mac side with a 90-min stale threshold. Operators and agents can run it without shell access to Dell logs. Frontend banner added to `bankst-os-frontend` — reads `/api/mapping/freshness` on load and displays a warning if hf_map or ir_map exceeds the 90-min threshold. Verified 2026-04-28.
- `Closed:` 2026-04-28
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

### SYS-006 — MappingToolsSync Terminal Window Steals Focus During Hourly Sync

- `Class:` Workflow, Reliability
- `Severity:` Medium
- `Status:` Closed
- `Environment:` Dell
- `Owner:` Unassigned
- `Detected In:` `MappingToolsSync` scheduled task and `mapping_tools/scripts/register_task.ps1` on 2026-04-29
- `Impact:` The hourly HF / IR map sync could pop a visible terminal window and steal user focus even when no intervention was needed.
- `Trigger / Failure Mode:` Task Scheduler launched PowerShell directly for `sync_and_push.ps1`; `-WindowStyle Hidden` was not sufficient to guarantee a non-disruptive unattended run.
- `Resolution:` Added `mapping_tools/scripts/launch_sync_hidden.vbs` and changed `register_task.ps1` so the scheduled task runs `wscript.exe //B` against that hidden launcher. The launcher runs `sync_and_push.ps1` with window style `0` and waits for completion so Task Scheduler still tracks overlap. Also hardened the sync path by rotating `sync.log`, writing UTF-8 logs, and making Excel read failures raise instead of allowing stale DB pushes. Verified the live scheduled task action points to `wscript.exe`.
- `Closed:` 2026-04-29
- `Linear Issue:` OS-34
- `Board Project:` PROJ-002

### SYS-007 — Obsidian Candidate `raw.md` Duplication Corrupted Active Source History

- `Class:` Reliability, Data, Workflow
- `Severity:` High
- `Status:` Closed
- `Environment:` Dell
- `Owner:` Unassigned
- `Detected In:` `C:\obsidian-vault\work\Candidate Notes\Kai Lu (Barclays)\raw.md` on 2026-04-29
- `Impact:` Candidate source history could inflate into multi-megabyte duplicated files, making profile reprocessing fragile, expensive, and harder to audit.
- `Trigger / Failure Mode:` The old aggregate `raw.md` model used a single file as both durable evidence store and processing source. If repeated raw history entered the inbox or active source path, the processor had no guard against accepting it as new evidence.
- `Resolution:` Replaced the active write model with dated immutable `sources/*.md` files, kept `raw.md` as legacy read-only history, added duplicate/self-append guards, added `audit_raw_duplication.py`, and repaired 10 duplicated legacy raw files with timestamped backups via `repair_raw_duplication.py`.
- `Closed:` 2026-04-29
- `Runbook / Incident Note:` `RUNBOOKS/OBSIDIAN_RAW_DUPLICATION_INCIDENT_2026-04-29.md`
- `Linear Issue:` OS-35 — https://linear.app/bankst-os/issue/OS-35/resolved-obsidian-candidate-rawmd-duplication-incident

## Intake Rules

Add a new issue when all of the following are true:

- the issue affects system behavior, security, data correctness, or delivery workflow
- the issue is likely to persist across sessions unless explicitly tracked
- the issue needs an owner or a decision, not just awareness

## Review Cadence

- Review `Critical` and `High` issues weekly.
- Review `Watching` issues only when architecture or deployment changes.
- When an issue becomes actionable, create or update its board project entry.
