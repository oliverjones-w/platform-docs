# Working Rules

Last updated: 2026-04-27

This file defines how work should be run across `bankst-os`.

The goal is simple: every engineer, on every device, should be able to see what matters, what is being worked on, who owns it, and where the truth lives.

## Core Principle

The company should operate from shared systems, not private memory.

That means:

- cross-repo context belongs in `platform-docs`
- live work belongs in Linear
- implementation details belong in the relevant product repo

## Canonical Tools

### 1. `platform-docs`

Use `platform-docs` for:

- system architecture
- naming conventions
- operating rules
- issue registry
- project board reference
- runbooks
- ADRs / decisions
- handoff notes

Do not use it as a substitute for execution tracking.

### 2. Linear

Use Linear for:

- bugs
- projects / epics
- risks
- workflow improvements
- operational incidents that need follow-through

If work matters, it should have a Linear issue. Board: `linear.app/bankst-os/team/OS`

## Ground Rules

### Rule 1: No important work without a tracked issue

If it is:

- security-sensitive
- reliability-sensitive
- cross-repo
- user-visible
- likely to take more than a quick isolated change

then it should exist as a Linear issue.

### Rule 2: Cross-repo work starts from the board

If work spans:

- Dell and Mac
- frontend and backend
- transport and runtime
- docs and implementation

start from the Linear board, not from ad hoc repo-local notes.

### Rule 3: Every issue needs an owner and a next step

An issue without an owner becomes background noise.
An issue without a next step becomes a diary entry.

Minimum issue hygiene:

- owner
- status
- priority
- one concrete next step

## Ownership Convention

Current team model:

- one human is the accountable owner
- numerous agents act as execution resources

This means:

- Linear issue assignee = accountable human owner
- agents may investigate, implement, review, or document
- agents do not replace the accountable owner field

### Canonical Ownership Rule

- Every meaningful issue should be assigned to the accountable human.
- The accountable human is responsible for priority, scope, acceptance, and closure.
- Agents can execute work, but they are not the canonical owner in the issue tracker.

### Execution Modes

Use one of these execution modes in issue bodies or comments when useful:

- `human-only`
- `agent-assisted`
- `agent-led`

Meaning:

- `human-only` = human performs the work directly
- `agent-assisted` = human owns and drives, agents help
- `agent-led` = human owns, agents perform most execution

### Current Default

Until the human team expands:

- assign all active work to `oliverjones-w`
- treat that assignee as the single accountable owner
- use comments, labels, or issue body notes to describe agent involvement when relevant

### Rule 4: Product repos own implementation; `platform-docs` owns system context

Use product repos for:

- code changes
- repo-local docs
- feature-level implementation notes

Use `platform-docs` for:

- cross-repo architecture
- operating model
- company-level engineering rules
- neutral system reference

### Rule 5: Update the board when work starts and when work stops

At minimum:

- move to `In Progress` when active work begins
- move to `Blocked` when waiting
- move to `Review` when implementation is done and needs validation
- move to `Done` only after verification

### Rule 6: Link work together

Whenever possible:

- PR links issue
- issue links project/epic
- docs link issue
- incident links runbook

This is what makes the system navigable.

### Rule 7: The board is the live view; markdown is the reference layer

Markdown explains the system.
Linear shows what is happening now.

Do not let markdown become a second unofficial issue tracker.

### Rule 8: Use canonical naming

Follow [NAMING.md](./NAMING.md):

- `bankst-os` = platform/system
- `bankst.co` = public frontend/app domain
- `bankst-os-frontend` = frontend repo/runtime

### Rule 9: Respect source-of-truth boundaries

Current known source-of-truth boundaries:

- Mac frontend repo/runtime is authoritative for frontend work
- Dell mapping environment is authoritative for mapping ingestion automation
- `platform-docs` is authoritative for macro system context

### Rule 10: Surface risk early

If you notice:

- missing auth
- stale data risk
- broken transport seams
- repo drift
- dead routes
- hidden coupling

file or update an issue immediately.

## Rules For Agents

Agents should:

- check `platform-docs` first for system context
- use Linear when the task is cross-repo or system-level
- avoid inventing alternate naming or alternate tracking systems
- update docs only where they are the correct source of truth

Agents should not:

- treat stale local mirrors as authoritative
- create shadow project plans outside Linear without a reason
- bury system risks in code comments or chat only

## Recommended Operating Rhythm

### Weekly

- review P0 / P1 items
- review security and reliability issues
- confirm owners for all active work

### During active work

- move issue to `In Progress`
- keep the board current
- add notes or links when the plan changes

### After major system changes

- update `SYSTEM_MAP.md` if architecture changed
- update `NAMING.md` if naming changed
- update runbooks if recovery or ops behavior changed

## Minimum Standard For A Healthy Team Workflow

At any time, another engineer should be able to answer:

1. What are the top priorities?
2. What is blocked?
3. Who owns each important issue?
4. Which repo is authoritative for this part of the system?
5. Where is the architecture documented?

If those answers are not obvious, the system needs cleanup.
