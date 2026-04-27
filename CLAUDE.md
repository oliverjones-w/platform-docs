# platform-docs — Agent Bootstrap

This repo is the macro context layer for `bankst-os`.

## Start Here

Read `agent/ENTRY.md`. It contains canonical naming, machine roles, source-of-truth boundaries, and task routing.

Stop after ENTRY.md unless the task needs deeper context. ENTRY.md tells you exactly which file to read next.

## Agent Files

```
agent/
  ENTRY.md    canonical naming, machines, source-of-truth, task routing
  INFRA.md    services, ports, DBs, SSH, SCP, transport — read when task touches infra
  STATE.md    open issues, project board, last sync snapshot — read when task is operational
  RULES.md    agent behavioral rules — read when uncertain about ownership or boundaries
```

## Human Reference

The root-level markdown files (SYSTEM_MAP.md, WORKING_RULES.md, ONBOARDING.md, etc.) are the human reference layer. Agents do not need to read them for most tasks.

## Mac Runtime Note

- PostgreSQL: always `127.0.0.1:5432`, never `localhost` (Tailscale conflict)
- Creds: `~/.zshrc` as `PGUSER` / `PGPASSWORD`
- Each service has its own `.venv` — activate before running
- Full port map and workspace layout: `agent/INFRA.md`
