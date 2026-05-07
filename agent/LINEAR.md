# Linear Protocol

## Pre-Write: Durable Local Artifact Required

Every Linear write (create project, create issue, update status) must be backed by a durable local artifact before the API call is made.

### What counts as a durable artifact

Any of the following satisfies the requirement:

- An entry in `ISSUE_REGISTRY.md`
- An ADR in `DECISIONS/`
- A task-pattern note in `TASK_PATTERNS/`
- A section added to a repo doc (`CLAUDE.md`, `AGENTS.md`, or equivalent)
- A staging note at `work/_staging/linear/YYYY-MM-DD-<slug>.md`

### When to create a staging note

**If a durable artifact already exists** — it satisfies the requirement. Do not create a redundant staging note.

**If no durable artifact exists** — create `work/_staging/linear/YYYY-MM-DD-<slug>.md` before the Linear write. Minimum content: title, intent, and acceptance criteria.

The purpose of this rule is write discipline, not paperwork. Work already captured in a canonical doc is the artifact.

## Write-Back

After any successful Linear create:

- Query by exact project name or issue title to retrieve the Linear URL and identifier.
- Patch the local artifact (staging note, registry entry, or repo doc section) with the Linear URL and identifier.

## Operational Reference

Transport, auth, GraphQL preflight sequence, schema constraints, sandbox behavior, and failure handling: see `agent/STATE.md` — Board Operations section.
