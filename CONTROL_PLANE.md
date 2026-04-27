# Control Plane

Last updated: 2026-04-27

Purpose: define the shared operating layer for `bankst-os`.

The control plane is the small set of systems that tell humans and agents:

- what the project is
- where truth lives
- what is being worked on
- who owns it
- how to navigate into the right repo or machine

It is not a product repo and it is not a runtime service.

## Control Plane Components

| Component | Role | Canonical home |
|---|---|---|
| `platform-docs` | macro system context | `oliverjones-w/platform-docs` |
| Obsidian vault | canonical intelligence interface and file state | `C:\obsidian-vault` |
| Linear | work items, risks, projects, incidents | `linear.app/bankst-os/team/OS` |
| ADRs | durable architecture decisions | `platform-docs/DECISIONS/` |
| Runbooks | recovery / operator procedures | `platform-docs/RUNBOOKS/` |
| Agent bootstrap | shortest context path for agents | `platform-docs/agent/` |

## What The Control Plane Owns

- naming conventions
- source-of-truth boundaries
- file-native system philosophy
- system maps
- issue / board operating rules
- architectural decision memory
- runbooks and handoffs
- agent startup and task routing

## What The Control Plane Does Not Own

- implementation details inside product repos
- repo-local feature docs
- runtime service configuration that belongs only to one product repo
- code changes themselves

## Entry Paths

### Human

1. `README.md`
2. `BOOTSTRAP.md`
3. `ONBOARDING.md`
4. `CONTEXT_TREE.md`

### Agent

1. `CLAUDE.md`
2. `agent/ENTRY.md`
3. only the next file required by the task

## Operating Loop

1. System context comes from `platform-docs`
2. Canonical intelligence state lives in Obsidian files
3. Active work is selected from Linear
4. Implementation happens in the owning repo or vault automation layer
5. If architecture or process changed, update the control plane

## Source Of Truth Rules

- `platform-docs` is the source of truth for macro context
- `C:\obsidian-vault` is the source of truth for intelligence objects, relationships, raw notes, and human-readable system state
- Linear is the source of truth for active work
- product repos are the source of truth for implementation
- databases, APIs, dashboards, and frontends are derived or optional layers unless explicitly documented otherwise

If two places disagree:

1. trust the owning layer
2. fix the stale layer

## Minimum Healthy State

The control plane is healthy when:

- every important work item has a Linear issue
- the board reflects current priorities
- source-of-truth boundaries are explicit
- files remain canonical where the system is representing intelligence
- agents can route themselves to the right repo with minimal context load
- stale local mirrors do not masquerade as authoritative repos

## Current Shape

- docs hub: in place
- agent bootstrap: in place
- board / issue system: in place
- source-of-truth boundaries: in place
- repo-local pointer docs: partial, expanding

## Next Expansions

- stronger subsystem ownership map
- repo-local pointer coverage across all important repos
- issue templates / operating templates
- more runbooks for recurring failures
