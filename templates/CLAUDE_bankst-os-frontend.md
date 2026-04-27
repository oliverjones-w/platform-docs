# bankst-os-frontend

Authoritative frontend runtime for `bankst-os`. Serves `bankst.co` via Cloudflare Tunnel.

## Macro Context

Part of `bankst-os`. For system context, read platform-docs first:
- GitHub: https://github.com/oliverjones-w/platform-docs
- Local (Mac): ~/workspace/platform-docs
- Start at: `agent/ENTRY.md`

## What This Repo Owns

- Static frontend served at `:3000`
- Core FastAPI (`core`) served at `:8765` — firms, funds, returns, mandates
- PostgreSQL backend via `hf_returns_app/models.py`

## What This Repo Does Not Own

- Mapping / HF / IR / BBG data (Dell `mapping_tools` + Mac `services/mapping_tools`)
- Gateway routing (Mac `services/gateway`)
- Cross-repo system context (platform-docs)

## Running

```bash
# frontend (static file server)
python3 -m http.server 3000

# core API
source .venv/bin/activate
uvicorn main:app --host 127.0.0.1 --port 8765
```

Both are managed by PM2 in production — use `pm2 restart frontend` / `pm2 restart core`.

## Database

- Engine: PostgreSQL
- Host: `127.0.0.1:5432` — always use `127.0.0.1`, never `localhost` (Tailscale conflict)
- DB: `bankst_os`
- Creds: `~/.zshrc` as `PGUSER` / `PGPASSWORD`
- Models: `apps/hf_returns_app/models.py`
- Migrations: Alembic — `~/workspace/services/bankst-os/`, 0001→0009
