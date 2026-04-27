# platform-docs — Claude Bootstrap

This repo is the macro context layer for `bankst-os`. Start here before touching any product repo.

## Read First

1. [BOOTSTRAP.md](./BOOTSTRAP.md) — device-neutral startup pointer
2. [CONTEXT_TREE.md](./CONTEXT_TREE.md) — layered reading path (load only what the task needs)

Shortest safe sequence if uncertain:

1. `ONBOARDING.md`
2. `NAMING.md`
3. `OWNERSHIP.md`
4. `SYSTEM_MAP.md`

Then stop and decide whether more context is needed.

## What This Repo Is

- `platform-docs` = macro context (decisions, runbooks, system shape, naming)
- GitHub Issues + `bankst-os Platform Board` = live work
- Product repos = implementation detail

Do not treat a product repo as the source of system truth. Come here first for cross-repo or architectural tasks.

## Mac Runtime (dev-server)

When working on the Mac, the full dev environment is at `~/workspace`. Key facts:

- DB: `127.0.0.1:5432` db `bankst_os` — always use `127.0.0.1`, never `localhost` (Tailscale conflict)
- Credentials in `~/.zshrc` as `PGUSER` / `PGPASSWORD`
- Frontend served live from `apps/bankst-os-frontend/` via `python -m http.server 3000`
- API on port `8765`, gateway on `7842`
- Each service has its own `.venv`; activate before running

See `workspace/CLAUDE.md` for the full port map and project layout.
