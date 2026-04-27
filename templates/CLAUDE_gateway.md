# gateway

FastAPI reverse proxy for `bankst-os`. Entry point for all inbound traffic from Cloudflare Tunnel.

## Macro Context

Part of `bankst-os`. For system context, read platform-docs first:
- GitHub: https://github.com/oliverjones-w/platform-docs
- Local (Mac): ~/workspace/platform-docs
- Start at: `agent/ENTRY.md`

## What This Repo Owns

- Inbound routing from Cloudflare Tunnel (`:7842`)
- Route table mapping `/api/*` prefixes to backend services

## Routing Table

| Route prefix | Backend | Port | Notes |
|---|---|---|---|
| `/api/core` | core | `8765` | |
| `/api/finra` | finra | `8001` | |
| `/api/mapping` | mapping | `8003` | |
| `/api/encore` | encore | `5050` | |
| `/system` | — | `9000` | Dead route — no backing process (SYS-004) |
| catch-all | frontend | `3000` | |

## Running

```bash
source .venv/bin/activate
uvicorn main:app --host 0.0.0.0 --port 7842
```

Managed by PM2 in production — use `pm2 restart gateway`.
