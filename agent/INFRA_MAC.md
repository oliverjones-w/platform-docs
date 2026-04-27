# Infrastructure — Mac

**Workspace root:** `~/workspace/`

```
~/workspace/
  apps/
    bankst-os-frontend/     static frontend + core API
    hf_returns_app/         returns app
  services/
    gateway/                FastAPI reverse proxy
    mapping_tools/          HF/IR/BBG mapping API + SQLite DBs
    finra_scraper_claude/   FINRA data API
    encore_scraper/         Encore candidate sync API
    bankst-swarm/           swarm / agent layer
    bankst-os/              DB migrations (Alembic)
  data/
  logs/
  scripts/
```

## SSH (from Dell)

```
ssh macdev    # dev-server@100.82.94.80  — service work
ssh macmini   # oliverjones@100.82.94.80 — postgres / ops
```
Key: `~/.ssh/id_ed25519`. Standard OpenSSH over Tailscale IP.

## PM2

```bash
pm2 list                       # status
pm2 logs [name]                # tail logs
pm2 restart [name]             # restart one
pm2 start ecosystem.config.js  # start all
```

| PM2 name | Port | Bind | Path |
|---|---|---|---|
| `gateway` | `7842` | `0.0.0.0` | `services/gateway` |
| `frontend` | `3000` | `0.0.0.0` | `apps/bankst-os-frontend` |
| `core` | `8765` | `127.0.0.1` | `apps/bankst-os-frontend` |
| `finra` | `8001` | `0.0.0.0` | `services/finra_scraper_claude` |
| `mapping` | `8003` | `0.0.0.0` | `services/mapping_tools` |
| `encore` | `5050` | `0.0.0.0` | `services/encore_scraper` |
| `openclaw` | `?` | `?` | live but undocumented — needs entry |
| `finra-scraper` | `?` | `?` | live but undocumented — needs entry |

## Gateway Routing

| Route prefix | Backend | Port | Notes |
|---|---|---|---|
| `/api/core` | core | `8765` | |
| `/api/finra` | finra | `8001` | |
| `/api/mapping` | mapping | `8003` | |
| `/api/encore` | encore | `5050` | |
| `/system` | — | `9000` | Dead route — SYS-004 |
| catch-all | frontend | `3000` | |

## Databases

| DB | Engine | Location | Notes |
|---|---|---|---|
| `bankst_os` | PostgreSQL | `127.0.0.1:5432` | Use `127.0.0.1` not `localhost`. Creds in `~/.zshrc` as `PGUSER`/`PGPASSWORD` |
| `hf_map.db` | SQLite | `services/mapping_tools/hf_map.db` | Synced from Dell hourly |
| `ir_map.db` | SQLite | `services/mapping_tools/ir_map.db` | Synced from Dell hourly |
| `bbg_results.db` | SQLite | `services/mapping_tools/bbg_results.db` | Synced on BBG run only |
| `candidate_sync.db` | SQLite | `services/encore_scraper/sync_state/` | Synced on Encore run |

## Public Edge

- Cloudflare Tunnel → Mac gateway `:7842` → `bankst.co`
- Cloudflare Access on `bankst.co` + `*.bankst.co` (email OTP allowlist)
- See `CLOUDFLARE_ACCESS.md` for policy detail
