# Infrastructure

## SSH (from Dell)

```
ssh macdev    # dev-server@100.82.94.80  — service work
ssh macmini   # oliverjones@100.82.94.80 — postgres / ops
```
Key: `~/.ssh/id_ed25519`. Standard OpenSSH over Tailscale IP. No Tailscale SSH.

## Mac — Live Services

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

### PM2 Services

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

### Gateway Routing

| Route prefix | Backend | Port | Notes |
|---|---|---|---|
| `/api/core` | core | `8765` | |
| `/api/finra` | finra | `8001` | |
| `/api/mapping` | mapping | `8003` | |
| `/api/encore` | encore | `5050` | |
| `/system` | — | `9000` | Dead route — no backing process (SYS-004) |
| catch-all | frontend | `3000` | |

### Databases

| DB | Engine | Port/Location | Notes |
|---|---|---|---|
| `bankst_os` | PostgreSQL | `127.0.0.1:5432` | Use `127.0.0.1` not `localhost` (Tailscale conflict). Creds in `~/.zshrc` as `PGUSER`/`PGPASSWORD` |
| `hf_map.db` | SQLite | `services/mapping_tools/hf_map.db` | Synced from Dell hourly |
| `ir_map.db` | SQLite | `services/mapping_tools/ir_map.db` | Synced from Dell hourly |
| `bbg_results.db` | SQLite | `services/mapping_tools/bbg_results.db` | Synced from Dell on BBG run |
| `candidate_sync.db` | SQLite | `services/encore_scraper/sync_state/` | Synced from Dell on Encore run |

Each service has its own `.venv`. Activate before running.

## Dell — Ingestion Host

**Dev root:** `C:\dev\`

```
C:\dev\
  tools/
    mapping_tools/    Excel sync + SQLite build + SCP push to Mac
  labs/
    unified_css/      stale frontend clone — non-authoritative
  platform-docs/      this repo
```

**K: drive** — live Excel source files:
- `Hedge Fund Map (K).xlsm` → `hf_map.db`
- `Interest Rates Map (K).xlsm` → `ir_map.db`

### Scheduled Task

| Task | Schedule | Script |
|---|---|---|
| `MappingToolsSync` | Hourly | `mapping_tools/scripts/sync_and_push.ps1` |

Logs: `C:\dev\tools\mapping_tools\logs\sync.log`

## Transport

| Leg | Method | From | To | Schedule |
|---|---|---|---|---|
| HF/IR/BBG DBs | SCP over Tailscale | Dell `mapping_tools/` | Mac `services/mapping_tools/` | Hourly, automated |
| Encore DB | SCP over Tailscale | Dell `labs/encore_scrape/` | Mac `services/encore_scraper/sync_state/` | Manual |
| Public traffic | Cloudflare Tunnel | Mac `:7842` | `bankst.co` | Always-on |

## Public Edge

- Cloudflare Tunnel terminates at Mac gateway `:7842`
- Cloudflare Access enforced on `bankst.co` + `*.bankst.co` (email OTP allowlist)
- See `CLOUDFLARE_ACCESS.md` for policy detail
