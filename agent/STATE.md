# System State

## Authoritative Sources

| What | Where |
|---|---|
| Live issues and work items | GitHub Issues — `github.com/oliverjones-w` repos |
| Planning and board | `bankst-os Platform Board` — GitHub Project |
| Runtime health | `LAST_SNAPSHOT.md` — check `Generated:` timestamp before acting on it |

Do not treat this file as a board mirror. For current issue or project status, go to GitHub directly.

## Board Operations

Use `scripts/board.sh` from the `platform-docs` root to add and move tasks:

```bash
bash scripts/board.sh add "Task title"        # create issue, add to board as Todo
bash scripts/board.sh start <issue-number>    # move to In Progress
bash scripts/board.sh done <issue-number>     # move to Done, close issue
bash scripts/board.sh list                    # print current board state
```

When the user says "add this to the board", "mark that in progress", or "log this on the platform board" — use these commands. The board is `oliverjones-w/projects/2`.

## Refresh Runtime Snapshot

Run from Mac:

```bash
bash scripts/health_snapshot.sh --write
```
