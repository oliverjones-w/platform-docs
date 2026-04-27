#!/usr/bin/env bash
set -euo pipefail

REPO="${1:-}"
if [[ -z "$REPO" ]]; then
  echo "Usage: ./scripts/seed_github_issues.sh owner/repo"
  exit 1
fi

create_label() {
  local name="$1"
  local color="$2"
  local desc="$3"
  gh label create "$name" --repo "$REPO" --color "$color" --description "$desc" 2>/dev/null || \
  gh label edit "$name" --repo "$REPO" --color "$color" --description "$desc"
}

create_issue() {
  local title="$1"
  local labels="$2"
  local body_file="$3"
  gh issue create --repo "$REPO" --title "$title" --label "$labels" --body-file "$body_file"
}

tmpdir="$(mktemp -d)"
trap 'rm -rf "$tmpdir"' EXIT

echo "Creating labels in $REPO ..."

create_label "type:project"   "5319e7" "Cross-cutting project or epic"
create_label "type:bug"       "d73a4a" "Bug or broken behavior"
create_label "type:risk"      "b60205" "Structural or operational risk"
create_label "type:workflow"  "0e8a16" "Process or workflow issue"

create_label "area:auth"      "1d76db" "Authentication and access control"
create_label "area:gateway"   "0052cc" "Gateway and routing"
create_label "area:mapping"   "fbca04" "Mapping and BBG systems"
create_label "area:frontend"  "c2e0c6" "Frontend and UI"
create_label "area:data-sync" "f9d0c4" "Cross-machine data sync and freshness"
create_label "area:ops"       "bfd4f2" "Operations and reliability"

create_label "severity:critical" "b60205" "Immediate high-impact concern"
create_label "severity:high"     "d93f0b" "High-priority issue"
create_label "severity:medium"   "fbca04" "Medium-priority issue"
create_label "severity:low"      "0e8a16" "Low-priority issue"

create_label "env:mac"         "0366d6" "Mac runtime environment"
create_label "env:dell"        "6f42c1" "Dell ingestion/dev environment"
create_label "env:public-edge" "5319e7" "Public edge / internet-facing environment"

cat > "$tmpdir/proj-001.md" <<'EOF'
## Summary
The platform is publicly served through Cloudflare Tunnel, but the gateway and downstream services do not yet have a clearly enforced authentication layer.

## Why this matters
This system exposes hedge fund, firm, and returns-related data. Public or weakly protected access is the highest structural risk in the stack.

## Scope
- Decide the primary auth model
- Implement the chosen auth layer
- Verify that protected routes cannot be reached anonymously
- Document the access model

## Candidate approaches
- Cloudflare Access at the edge
- Gateway auth middleware
- Defense in depth with both

## Success criteria
- Unauthenticated users cannot access protected routes
- The chosen auth model is documented
- Login/access flow is tested end-to-end

## Related issues
- Route inventory for protected endpoints
- Auth architecture decision
- Implementation of chosen auth model
EOF

cat > "$tmpdir/sys-001a.md" <<'EOF'
## Problem
The system does not yet have a clearly documented and enforced authentication model.

## Decision needed
Choose one of:
- Cloudflare Access as primary gate
- Gateway middleware as primary gate
- Both for defense in depth

## Deliverable
A short written decision covering:
- chosen approach
- why it was chosen
- what routes are protected
- what identity source is used
- how local/dev access should work

## Done when
- decision is documented
- implementation path is clear
- owner is assigned for rollout
EOF

cat > "$tmpdir/sys-001b.md" <<'EOF'
## Problem
We need an explicit inventory of routes that should not be publicly reachable.

## Scope
Audit:
- /api/core
- /api/finra
- /api/mapping
- /api/encore
- any frontend routes exposing sensitive data
- any admin/health/system routes

## Deliverable
A route inventory with:
- route prefix
- backing service
- sensitivity level
- auth required: yes/no
- notes

## Done when
- all gateway-exposed routes are classified
- protected vs public routes are explicitly documented
EOF

cat > "$tmpdir/sys-001c.md" <<'EOF'
## Problem
After the auth decision is made, it must be enforced in runtime.

## Scope
- implement chosen auth mechanism
- verify behavior for anonymous and authenticated users
- document operational setup

## Test cases
- anonymous request to protected route fails
- authenticated request succeeds
- expected public routes still work
- frontend behavior under auth is validated

## Done when
- auth is enforced in live runtime
- tests/manual verification are recorded
- docs are updated
EOF

cat > "$tmpdir/proj-002.md" <<'EOF'
## Summary
Dell rebuilds mapping SQLite DBs and transfers them to the Mac over Tailscale/SSH/SCP. If that transport fails, the Mac can silently serve stale mapping data.

## Why this matters
The transport seam is currently a blind spot. Users and operators need visibility into stale mapping data.

## Scope
- expose sync freshness on the Mac
- make stale data visible operationally
- optionally surface stale state in the frontend

## Success criteria
- current mapping freshness can be checked from the Mac side
- stale data crosses a defined threshold and becomes visible
- operators do not need to inspect Dell logs manually
EOF

cat > "$tmpdir/sys-002a.md" <<'EOF'
## Problem
The Mac runtime does not expose an obvious freshness signal for Dell-synced mapping DBs.

## Scope
Expose a freshness/status endpoint or equivalent signal using one or more of:
- SQLite file modified time
- latest synced_at from history tables
- latest successful transfer timestamp

## Deliverable
A machine-readable status output showing:
- hf_map freshness
- ir_map freshness
- bbg_results freshness
- stale/not stale evaluation

## Done when
- freshness is visible from the Mac side
- stale threshold is defined
- output is documented
EOF

cat > "$tmpdir/sys-002b.md" <<'EOF'
## Problem
Even if freshness exists internally, operators and users need a visible signal when mapping data is stale.

## Scope
Implement one or both:
- operator-facing health output
- frontend stale-data banner or indicator

## Done when
- stale mapping data is visible without shell access
- threshold behavior is documented
- warning clears automatically when data refreshes
EOF

cat > "$tmpdir/sys-002c.md" <<'EOF'
## Problem
The sync leg depends on Windows Task Scheduler, Tailscale auth state, SSH/SCP, and the macdev alias. Failure modes exist but are easy to miss.

## Scope
Document:
- task name and schedule
- SCP target path
- Tailscale re-auth failure mode
- expected recovery steps
- where to verify freshness after recovery

## Done when
- an engineer can diagnose a stale mapping incident from docs
- Dell and Mac verification steps are explicit
EOF

cat > "$tmpdir/proj-003.md" <<'EOF'
## Summary
The Dell frontend clone is stale and has local drift. The authoritative frontend lives on the Mac and is developed via VS Code remote.

## Why this matters
Engineers can draw incorrect conclusions if they inspect the Dell frontend clone and assume it reflects live runtime.

## Scope
- document frontend source of truth
- document expected development workflow
- reduce confusion between Dell mirror and Mac runtime

## Success criteria
- onboarding docs point to the Mac repo/runtime
- Dell clone is clearly marked non-authoritative
- GitHub remains the expected sync layer
EOF

cat > "$tmpdir/sys-003a.md" <<'EOF'
## Problem
The Dell clone of the frontend repo can be mistaken for the live working copy.

## Scope
Update docs to state:
- Mac frontend repo is authoritative
- Dell frontend clone is reference-only
- frontend dev should happen via Mac VS Code remote

## Done when
- architecture docs and handoff docs say this explicitly
- no system doc implies Dell frontend is live
EOF

cat > "$tmpdir/sys-003b.md" <<'EOF'
## Problem
Cross-device work needs a simple branch policy so Dell and Mac usage stays predictable.

## Scope
Define:
- where frontend work starts
- how branches are named
- when GitHub is used as handoff
- how stale local mirrors should be treated

## Done when
- branch policy is documented
- engineers can follow one obvious workflow
EOF

cat > "$tmpdir/proj-004.md" <<'EOF'
## Summary
The gateway routing table includes `/system -> :9000`, but no live backing process is currently known.

## Why this matters
Dead or ownerless routes create architectural ambiguity and reduce trust in the system map.

## Scope
- verify whether :9000 should exist
- identify owner if intended
- remove route if dead

## Success criteria
- gateway routes reflect only live or intentionally documented services
EOF

cat > "$tmpdir/sys-004a.md" <<'EOF'
## Problem
The gateway still advertises `/system -> :9000`, but no confirmed live process backs it.

## Scope
- verify whether a service should be listening on :9000
- identify intended owner
- remove route if unused

## Done when
- route is either documented and owned or removed
- system map reflects the result
EOF

echo "Creating issues in $REPO ..."

create_issue "Platform Auth Hardening" \
  "type:project,area:auth,area:gateway,severity:critical,env:mac,env:public-edge" \
  "$tmpdir/proj-001.md"

create_issue "Decide edge auth model: Cloudflare Access vs gateway middleware" \
  "type:risk,area:auth,area:gateway,severity:critical,env:mac,env:public-edge" \
  "$tmpdir/sys-001a.md"

create_issue "Audit gateway and service routes that must require authentication" \
  "type:risk,area:auth,area:gateway,severity:high,env:mac,env:public-edge" \
  "$tmpdir/sys-001b.md"

create_issue "Implement chosen authentication layer and verify protected access" \
  "type:bug,area:auth,area:gateway,severity:critical,env:mac,env:public-edge" \
  "$tmpdir/sys-001c.md"

create_issue "Mapping Freshness Reliability" \
  "type:project,area:mapping,area:data-sync,severity:high,env:dell,env:mac" \
  "$tmpdir/proj-002.md"

create_issue "Expose mapping sync freshness on the Mac runtime" \
  "type:bug,area:mapping,area:data-sync,severity:high,env:mac" \
  "$tmpdir/sys-002a.md"

create_issue "Surface stale mapping data warning in ops health checks and/or UI" \
  "type:risk,area:mapping,area:ops,severity:high,env:mac" \
  "$tmpdir/sys-002b.md"

create_issue "Document Dell -> Mac mapping transport failure modes" \
  "type:workflow,area:data-sync,area:ops,severity:medium,env:dell,env:mac" \
  "$tmpdir/sys-002c.md"

create_issue "Frontend Source-of-Truth Workflow" \
  "type:project,type:workflow,area:frontend,severity:medium,env:dell,env:mac" \
  "$tmpdir/proj-003.md"

create_issue "Document Mac frontend repo as authoritative and Dell clone as stale mirror" \
  "type:workflow,area:frontend,severity:medium,env:dell,env:mac" \
  "$tmpdir/sys-003a.md"

create_issue "Capture frontend branch/merge policy for cross-device work" \
  "type:workflow,area:frontend,severity:medium,env:dell,env:mac" \
  "$tmpdir/sys-003b.md"

create_issue "Gateway Route Cleanup" \
  "type:project,area:gateway,severity:low,env:mac" \
  "$tmpdir/proj-004.md"

create_issue "Audit and resolve gateway /system -> :9000 route" \
  "type:risk,area:gateway,severity:low,env:mac" \
  "$tmpdir/sys-004a.md"

echo
echo "Done. Issues and labels created in $REPO"
