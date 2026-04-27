# gateway

FastAPI reverse proxy for `bankst-os`. Entry point for all inbound traffic from Cloudflare Tunnel.

## What This Repo Owns

- Inbound routing at `:7842`
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

Managed by PM2 in production — `pm2 restart gateway`.

## Common Failure Modes

- 502 on a route → check the backing service is running (`pm2 list`)
- Routing to wrong backend → verify route prefix in `main.py` matches table above
- Cloudflare not reaching gateway → check tunnel is up (`cloudflared tunnel list`)

## Cross-Repo Context

For cross-repo, architectural, or ambiguous tasks only:
- GitHub: https://github.com/oliverjones-w/platform-docs
- Local (Mac): `~/workspace/platform-docs`
- Start at: `agent/ENTRY.md`
