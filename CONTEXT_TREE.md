# Context Tree

Last updated: 2026-04-27

Purpose: define the shortest safe reading path for humans and agents so context is loaded in layers, not all at once.

## Core Principle

Do not read the whole repo by default.

Load only the smallest layer needed for the task:

1. bootstrap
2. operating context
3. system shape
4. live work
5. decision / recovery detail

Stop reading as soon as the task has enough context.

## Layer 0 - Bootstrap

Read these first on any new session:

1. [ONBOARDING.md](./ONBOARDING.md)
2. [NAMING.md](./NAMING.md)

What you get:

- what `bankst-os` is
- what to call things
- where the source of truth lives
- where live work is tracked

When to stop:

- stop here if the task is trivial and repo-local
- continue if the task is cross-repo, architectural, operational, or ambiguous

## Layer 1 - Operating Context

Read when you need to know how to behave in the system:

1. [OWNERSHIP.md](./OWNERSHIP.md)
2. [WORKING_RULES.md](./WORKING_RULES.md)

What you get:

- source-of-truth boundaries
- accountability model
- rules for issues, board usage, and execution

When to stop:

- stop here if the task is about process, ownership, or repo authority
- continue if the task touches runtime architecture or machine boundaries

## Layer 2 - System Shape

Read when the task touches runtime, infrastructure, or host boundaries:

1. [SYSTEM_MAP.md](./SYSTEM_MAP.md)
2. [INFRASTRUCTURE_MAP.md](./INFRASTRUCTURE_MAP.md)

What you get:

- Dell vs Mac responsibilities
- runtime services, ports, and transport
- public edge exposure path

When to stop:

- stop here if you now understand where the task lives
- continue if the task is part of an active tracked initiative

## Layer 3 - Live Work

Read when the task is tied to current execution:

1. Linear issue (`linear.app/bankst-os/team/OS`)
2. [ISSUE_REGISTRY.md](./ISSUE_REGISTRY.md) if needed
3. [PROJECT_BOARD.md](./PROJECT_BOARD.md) as reference only

What you get:

- active priority
- owner
- current status
- linked work items

When to stop:

- stop here if the issue fully defines the task
- continue if you need historical reasoning or recovery behavior

## Layer 4 - Decision / Recovery Detail

Read only when relevant:

- [DECISIONS](./DECISIONS/README.md)
- [RUNBOOKS](./RUNBOOKS/README.md)
- [HANDOFFS](./HANDOFFS/README.md)

What you get:

- why a decision exists
- how to recover from known failures
- environment-specific notes

## Task-Based Reading Paths

### If the task is frontend-only

Read:

1. `ONBOARDING.md`
2. `NAMING.md`
3. `OWNERSHIP.md`

Then go to the authoritative frontend repo/runtime.

### If the task is mapping ingestion-only

Read:

1. `ONBOARDING.md`
2. `OWNERSHIP.md`
3. `SYSTEM_MAP.md`

Then go to the Dell `mapping_tools` repo.

### If the task is cross-repo

Read:

1. `ONBOARDING.md`
2. `NAMING.md`
3. `OWNERSHIP.md`
4. `WORKING_RULES.md`
5. `SYSTEM_MAP.md`
6. relevant Linear issue/board item

### If the task is auth/security

Read:

1. `ONBOARDING.md`
2. `OWNERSHIP.md`
3. `SYSTEM_MAP.md`
4. relevant Linear auth issue
5. relevant ADR in `DECISIONS/`

### If the task is runtime/ops

Read:

1. `ONBOARDING.md`
2. `OWNERSHIP.md`
3. `SYSTEM_MAP.md`
4. `INFRASTRUCTURE_MAP.md`
5. relevant runbook in `RUNBOOKS/`

### If the task is incident response

Read:

1. `ONBOARDING.md`
2. `SYSTEM_MAP.md`
3. relevant runbook
4. relevant Linear issue if follow-through is needed

## Token Preservation Rules

- Always start with Layer 0.
- Do not load Layer 2 unless the task touches architecture, runtime, or machine boundaries.
- Do not load ADRs or runbooks unless the task specifically needs decision or recovery context.
- Do not read the entire repo when one branch of the tree is enough.
- Prefer the issue and owning repo after the correct branch has been identified.

## Canonical Short Path

If uncertain, the shortest safe sequence is:

1. [ONBOARDING.md](./ONBOARDING.md)
2. [NAMING.md](./NAMING.md)
3. [OWNERSHIP.md](./OWNERSHIP.md)
4. [SYSTEM_MAP.md](./SYSTEM_MAP.md)

Then stop and decide whether more context is actually needed.

## Agent Bootstrap

Agents use `agent/ENTRY.md` as the primary entry point. CLAUDE.md handles auto-loading. The `agent/` directory is the agent-optimized reading path — agents do not need to follow this context tree.
