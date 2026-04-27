# System State

## Authoritative Sources

| What | Where |
|---|---|
| Live issues and work items | Linear — `linear.app/bankst-os` |
| Planning and board | Linear OS team — `linear.app/bankst-os/team/OS` |
| Runtime health | `LAST_SNAPSHOT.md` — check `Generated:` timestamp before acting on it |

GitHub is code-only. Do not look there for issue or project status.

## Board Operations

The Linear MCP is active in this Claude Code session. When the user says "add this to the board", "mark that in progress", or "log this on the board":

- Use the Linear MCP tools directly (create issue, update status, etc.)
- Team: `OS` — workspace: `bankst-os`
- States: Todo, In Progress, In Review, Blocked, Done
- Labels: `area:*`, `type:*`, `env:*`

If the MCP is unavailable, fall back to the Linear GraphQL API directly with the key in `~/.zshrc` (`$LINEAR_API_KEY`). Team ID: `f1d8c5f5-56f6-4379-bf28-73d356b3e355`.

## Refresh Runtime Snapshot

Run from Mac:

```bash
bash scripts/health_snapshot.sh --write
```
