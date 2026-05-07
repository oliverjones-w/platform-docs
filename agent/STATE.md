# System State

## Authoritative Sources

| What | Where |
|---|---|
| Live issues and work items | Linear — `linear.app/bankst-os` |
| Planning and board | Linear OS team — `linear.app/bankst-os/team/OS` |
| Runtime health | `LAST_SNAPSHOT.md` — check `Generated:` timestamp before acting on it |

GitHub is code-only. Do not look there for issue or project status.

## Board Operations

For write discipline, staging artifact rules, and write-back protocol: see `agent/LINEAR.md`.

**Primary path — Linear MCP (prefer this):**

When the MCP is active, use the Linear MCP tools directly for all board operations.

- Team: `OS` — workspace: `bankst-os`
- States: Todo, In Progress, In Review, Blocked, Done
- Labels: `area:*`, `type:*`, `env:*`

**Fallback path — GraphQL API (MCP unavailable):**

Use PowerShell `Invoke-RestMethod` to `POST https://api.linear.app/graphql`.

**This only works outside sandbox.** Sandbox HTTPS fails with TLS errors that surface as auth errors — they are not auth errors. Do not rotate or distrust the key based on sandbox failures. If sandbox HTTPS fails, escalate to non-sandbox and retest.

Auth: `Authorization: $env:LINEAR_API_KEY` (raw key — no `Bearer` prefix required).

Team ID: `f1d8c5f5-56f6-4379-bf28-73d356b3e355`

### GraphQL Operating Rules

**Preflight — run before any write:**
1. Viewer query — if `data.viewer.id` is returned, auth and connectivity are confirmed.
2. Search issues by title, projects by name — stop if a matching active tracker already exists.

**Creating projects and issues:**
- Omit `labelIds` from all create mutations. It is present in the schema but rejected by this workspace. Labels are not a blocker — create without them.
- If labels are needed, apply them in a separate mutation after the entity exists. If that also fails, leave the entity label-free and record the failure as a follow-up. Do not delete a successfully created entity because labels failed.
- Always check the `errors` field in the GraphQL response. A response with `data: null` and no printed errors is a silent failure — the error detail is in the response body.

**Schema constraints (confirmed for this workspace):**
- `ProjectFilter.description` — unsupported. Search projects by `name` only.
- `IssueFilter.title` and `IssueFilter.description` — both supported.
- Multiple `__type` fields in a single introspection query require aliases.
- When a mutation field is uncertain, introspect `ProjectCreateInput` / `IssueCreateInput` before sending.

**Partial success and write-back:**
- If a project was created but issue creation failed, reuse the created project — do not re-create it.
- After any successful create, query by exact name/title to capture the URL and identifier.
- Write the Linear URL back to the local staging note.

**Failure diagnosis order:**
1. Sandbox TLS / auth-looking error → escalate to non-sandbox, retest with viewer query first.
2. Auth error outside sandbox → run viewer query; if viewer succeeds, the key is valid.
3. Mutation returns `null` → print the full response and read the `errors` array.
4. Label rejection → remove `labelIds`, re-run the mutation without labels.

## Refresh Runtime Snapshot

Run from Mac:

```bash
bash scripts/health_snapshot.sh --write
```
