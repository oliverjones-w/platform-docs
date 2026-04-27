# Gotchas

System-specific traps. Read when debugging unexpected behavior or before touching infra.

- **PostgreSQL: use `127.0.0.1` not `localhost`** — Tailscale creates a localhost routing conflict; `127.0.0.1:5432` always works, `localhost` may not
- **Each Mac service has its own `.venv`** — activate the service-specific venv before running or installing anything; the wrong venv will silently use wrong deps
- **DB creds are in `~/.zshrc`** as `PGUSER` / `PGPASSWORD` — not in `.env` files
- **Dell `labs/unified_css` is a stale frontend mirror** — do not use it for frontend work; the Mac `bankst-os-frontend` is authoritative
- **Tailscale SSH is disabled on the Mac** — use standard OpenSSH over the Tailscale IP via `ssh macdev` or `ssh macmini`; Tailscale SSH itself will not connect
- **SQLite DBs on Mac are synced from Dell on a delay** — check `LAST_SNAPSHOT.md` for freshness before trusting HF/IR/BBG data; stale data serves silently with no error
- **`bbg_results.db` is NOT on the hourly schedule** — it syncs only on manual BBG pipeline runs, not with the `MappingToolsSync` task
- **Gateway `/system` route is dead** — no backing process on `:9000`; do not route to it (tracked as SYS-004)
- **`openclaw` and `finra-scraper` are live PM2 services with no documentation** — port and path unknown; do not assume they are inactive
