# Infrastructure Map

Last updated: 2026-04-27

Operational schematic of the bankst-os stack across the Dell XPS-15 (ingestion) and Mac mini (runtime). This is the primary context bridge for operators and agents working across machines.

Related docs:
- `SYSTEM_MAP.md` — architectural overview
- `CLOUDFLARE_ACCESS.md` — edge auth configuration
- `DECISIONS/ADR-002-auth-model.md` — auth model decision

---

## Machine Summary

| Machine | Role | Tailscale IP | User |
|---|---|---|---|
| Dell XPS-15 | Ingestion, automation, dev | `100.125.163.20` | `olive` / `dev-server` (via SSH) |
| Mac mini | Runtime host — all live services | `100.82.94.80` | `dev-server` (services), `oliverjones` (ops/postgres) |

**SSH from Dell to Mac:**
```
ssh macdev      # dev-server@100.82.94.80  (service work)
ssh macmini     # oliverjones@100.82.94.80 (postgres / ops)
```
Both aliases defined in `~/.ssh/config` on Dell. Key: `~/.ssh/id_ed25519`. No Tailscale SSH — standard OpenSSH only (Tailscale SSH disabled on Mac 2026-04-27).

---

## Mac — Runtime Host

**Workspace root:** `~/workspace/`

```
~/workspace/
  apps/
    bankst-os-frontend/     static frontend + core API
    hf_returns_app/         returns app
  services/
    gateway/                FastAPI reverse proxy (entry point)
    mapping_tools/          HF/IR/BBG mapping API + SQLite DBs
    finra_scraper_claude/   FINRA data API
    encore_scraper/         Encore candidate sync API
    bankst-swarm/           swarm / agent layer
    bankst-os/              DB migrations (Alembic)
  common/
  data/
  logs/
  scripts/
```

### Process Manager: PM2

All live services are managed by PM2 via `~/ecosystem.config.js`.

```bash
pm2 list                        # status of all services
pm2 logs [name]                 # tail logs
pm2 restart [name]              # restart one service
pm2 start ecosystem.config.js   # start everything
pm2 save                        # persist process list across reboots
```

### Live Services

| PM2 Name | Port | Bind | Path | Description |
|---|---|---|---|---|
| `gateway` | `7842` | `0.0.0.0` | `services/gateway` | FastAPI reverse proxy — Cloudflare Tunnel entry point |
| `frontend` | `3000` | `0.0.0.0` | `apps/bankst-os-frontend` | Static file server (`python3 -m http.server`) |
| `core` | `8765` | `127.0.0.1` | `apps/bankst-os-frontend` | FastAPI — firms, funds, returns, mandates — PostgreSQL backend |
| `finra` | `8001` | `0.0.0.0` | `services/finra_scraper_claude` | FastAPI + Jinja2 over FINRA SQLite data |
| `mapping` | `8003` | `0.0.0.0` | `services/mapping_tools` | FastAPI — HF/IR/BBG mapping lookup over SQLite |
| `encore` | `5050` | `0.0.0.0` | `services/encore_scraper` | FastAPI — Encore candidate sync state (read-only) |

### Gateway Routing Table

Gateway (`main:app` at `:7842`) routes inbound requests:

| Route prefix | Backend | Port |
|---|---|---|
| `/api/core` | core | `8765` |
| `/api/finra` | finra | `8001` |
| `/api/mapping` | mapping | `8003` |
| `/api/encore` | encore | `5050` |
| `/system` | `:9000` | unused — dead route (see SYS-004) |
| catch-all | frontend | `3000` |

### Database

| DB | Engine | Port | Location |
|---|---|---|---|
| `bankst_os` | PostgreSQL | `5432` | Mac local — models in `apps/hf_returns_app/models.py`, migrations Alembic 0001→0009 |
| `hf_map.db` | SQLite | — | `services/mapping_tools/hf_map.db` — synced from Dell hourly |
| `ir_map.db` | SQLite | — | `services/mapping_tools/ir_map.db` — synced from Dell hourly |
| `bbg_results.db` | SQLite | — | `services/mapping_tools/bbg_results.db` — synced from Dell on BBG run |
| `candidate_sync.db` | SQLite | — | `services/encore_scraper/sync_state/` — synced from Dell on Encore run |

---

## Dell XPS-15 — Ingestion Host

**Dev root:** `C:\dev\`

```
C:\dev\
  tools/
    mapping_tools/          Excel sync + SQLite build + SCP push to Mac
  labs/
    encore_scrape/          Encore candidate scraper + SCP push to Mac
    unified_css/            stale frontend clone (non-authoritative)
  platform-docs/            this repo
```

**K: drive** — network share containing live Excel source files:
- `Hedge Fund Map (K).xlsm` (sheet: Master, header row 2) → `hf_map.db`
- `Interest Rates Map (K).xlsm` (sheet: People Moves, header row 2) → `ir_map.db`

### Scheduled Tasks (Windows Task Scheduler)

| Task Name | Schedule | Script | What it does |
|---|---|---|---|
| `MappingToolsSync` | Hourly | `mapping_tools/scripts/sync_and_push.ps1` | Excel → SQLite → SCP to Mac |

**Logs:** `C:\dev\tools\mapping_tools\logs\sync.log`

### Automation Scripts

| Script | Trigger | What it does |
|---|---|---|
| `mapping_tools/scripts/sync_and_push.ps1` | Task Scheduler (hourly) | Runs `sync_hf_map.py` + `sync_ir_map.py`, then SCPs all three DBs to Mac |
| `encore_scrape/run_sync.ps1` | Manual | Runs Encore probe, SCPs `candidate_sync.db` to Mac |

### SCP Push Targets (Dell → Mac)

| File | Mac destination |
|---|---|
| `hf_map.db` | `macdev:/Users/dev-server/workspace/services/mapping_tools/hf_map.db` |
| `ir_map.db` | `macdev:/Users/dev-server/workspace/services/mapping_tools/ir_map.db` |
| `bbg_results.db` | `macdev:/Users/dev-server/workspace/services/mapping_tools/bbg_results.db` |
| `candidate_sync.db` | `dev-server@100.82.94.80:/Users/dev-server/workspace/services/encore_scraper/sync_state/candidate_sync.db` |

---

## Transport Layer

| Leg | Method | From | To | Notes |
|---|---|---|---|---|
| Mapping DBs | SCP over Tailscale | Dell `C:\dev\tools\mapping_tools\` | Mac `~/workspace/services/mapping_tools/` | Hourly, automated |
| Encore DB | SCP over Tailscale | Dell `C:\dev\labs\encore_scrape\` | Mac `~/workspace/services/encore_scraper/sync_state/` | Manual trigger |
| Public traffic | Cloudflare Tunnel | Mac `:7842` | `bankst.co` | Always-on |

---

## Public Edge

| Layer | Config | Notes |
|---|---|---|
| Cloudflare Tunnel | Mac → `bankst.co` | Terminates at gateway `:7842` |
| Cloudflare Access | `bankst.co` + `*.bankst.co` | Email OTP allowlist — see `CLOUDFLARE_ACCESS.md` |

---

## Known Issues

| Issue | Severity | Status | Doc |
|---|---|---|---|
| No sync freshness signal on Mac | High | Open | `ISSUE_REGISTRY.md` SYS-002 |
| Dead gateway route `/system → :9000` | Low | Watching | `ISSUE_REGISTRY.md` SYS-004 |
