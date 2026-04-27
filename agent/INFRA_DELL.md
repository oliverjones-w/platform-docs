# Infrastructure — Dell

**Dev root:** `C:\dev\`

```
C:\dev\
  tools/
    mapping_tools/    Excel sync + SQLite build + SCP push to Mac
  labs/
    unified_css/      stale frontend clone — non-authoritative
    encore_scrape/    Encore candidate scraper
    bankst-swarm/     swarm prototype
  platform-docs/      this repo
```

**K: drive** — live Excel source files:
- `Hedge Fund Map (K).xlsm` → `hf_map.db`
- `Interest Rates Map (K).xlsm` → `ir_map.db`

## Scheduled Tasks (Windows Task Scheduler)

| Task | Schedule | Script | Log |
|---|---|---|---|
| `MappingToolsSync` | Hourly | `mapping_tools/scripts/sync_and_push.ps1` | `mapping_tools/logs/sync.log` |

## SCP Push Targets (Dell → Mac)

| File | Mac destination |
|---|---|
| `hf_map.db` | `macdev:/Users/dev-server/workspace/services/mapping_tools/hf_map.db` |
| `ir_map.db` | `macdev:/Users/dev-server/workspace/services/mapping_tools/ir_map.db` |
| `bbg_results.db` | `macdev:/Users/dev-server/workspace/services/mapping_tools/bbg_results.db` |
| `candidate_sync.db` | `dev-server@100.82.94.80:/Users/dev-server/workspace/services/encore_scraper/sync_state/candidate_sync.db` |

## Transport

| Leg | Method | Schedule |
|---|---|---|
| HF/IR/BBG DBs | SCP over Tailscale | Hourly, automated |
| Encore DB | SCP over Tailscale | Manual trigger |
| Public traffic | Cloudflare Tunnel (Mac) | Always-on |
