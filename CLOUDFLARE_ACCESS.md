# Cloudflare Access

Last updated: 2026-04-26

## What This Is

Cloudflare Access is the authentication gate for all public traffic entering `bankst.co`. It sits in front of the Cloudflare Tunnel, which forwards to the Mac-hosted gateway on `:7842`. No unauthenticated request reaches the Mac.

This is the primary resolution of `SYS-001`. See `DECISIONS/ADR-002-auth-model.md`.

---

## Current Configuration

### Access Application

| Field | Value |
|---|---|
| Name | `bankst-workspace-new` |
| App ID | `c5863640-f2f6-4193-a661-72113894a9b8` |
| Type | `self_hosted` |
| Domains | `bankst.co`, `*.bankst.co` |
| Session duration | 24h |
| Auto-redirect to IdP | No |
| Identity providers | None configured — auth via Cloudflare email OTP |

The wildcard `*.bankst.co` covers all subdomains. All gateway-routed services are within scope.

### Allow Policy

| Field | Value |
|---|---|
| Policy ID | `af9c18dd-66e1-427c-9a0f-350cac550f7f` |
| Decision | `allow` |
| Mechanism | Email allowlist |
| Session duration | 24h |

**Allowed emails:**
- `oliverjones.w@outlook.com`
- `oliver@bankst.co`
- `dev@bankst.co`
- `nicholaslcominos@gmail.com`
- `avazilkha@gmail.com`
- `ghartbsa@gmail.com`

Auth flow: user visits `bankst.co`, enters their email, receives a one-time code, gains a 24h session cookie.

---

## API Access

Credentials are stored in `~/.bash_profile` on Dell:

```bash
CF_API_EMAIL       # dev@bankst.co
CF_GLOBAL_API_KEY  # cfk_... (scoped token, works with X-Auth-Key header)
CF_ACCOUNT_ID      # 5c0f4170bbbfbecbb641a15771038da3
```

Auth headers for all Cloudflare API calls:

```
X-Auth-Email: $CF_API_EMAIL
X-Auth-Key:   $CF_GLOBAL_API_KEY
```

---

## Key API Endpoints

All paths are relative to `https://api.cloudflare.com/client/v4`.

### List Access apps
```bash
curl -s "https://api.cloudflare.com/client/v4/accounts/$CF_ACCOUNT_ID/access/apps" \
  -H "X-Auth-Email: $CF_API_EMAIL" \
  -H "X-Auth-Key: $CF_GLOBAL_API_KEY" | jq .
```

### Get a specific app
```bash
curl -s "https://api.cloudflare.com/client/v4/accounts/$CF_ACCOUNT_ID/access/apps/c5863640-f2f6-4193-a661-72113894a9b8" \
  -H "X-Auth-Email: $CF_API_EMAIL" \
  -H "X-Auth-Key: $CF_GLOBAL_API_KEY" | jq .
```

### List policies on the app
```bash
curl -s "https://api.cloudflare.com/client/v4/accounts/$CF_ACCOUNT_ID/access/apps/c5863640-f2f6-4193-a661-72113894a9b8/policies" \
  -H "X-Auth-Email: $CF_API_EMAIL" \
  -H "X-Auth-Key: $CF_GLOBAL_API_KEY" | jq .
```

### Update the allow policy (e.g. add an email)

Fetch current policy, modify the `include` array, PUT it back:

```bash
curl -s -X PUT \
  "https://api.cloudflare.com/client/v4/accounts/$CF_ACCOUNT_ID/access/apps/c5863640-f2f6-4193-a661-72113894a9b8/policies/af9c18dd-66e1-427c-9a0f-350cac550f7f" \
  -H "X-Auth-Email: $CF_API_EMAIL" \
  -H "X-Auth-Key: $CF_GLOBAL_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Allow emails policy created by onboarding: 3/10/2026",
    "decision": "allow",
    "include": [
      {"email": {"email": "oliverjones.w@outlook.com"}},
      {"email": {"email": "oliver@bankst.co"}},
      {"email": {"email": "dev@bankst.co"}},
      {"email": {"email": "nicholaslcominos@gmail.com"}},
      {"email": {"email": "avazilkha@gmail.com"}},
      {"email": {"email": "ghartbsa@gmail.com"}},
      {"email": {"email": "new@example.com"}}
    ],
    "exclude": [],
    "require": [],
    "session_duration": "24h"
  }' | jq '.success, .errors'
```

---

## Open Questions

- No IdP configured — auth is Cloudflare email OTP only. If SSO (Google Workspace, etc.) is added later, set `auto_redirect_to_identity: true` on the app.
- Verify the `cfk_`-prefixed credential type in the Cloudflare dashboard (API Tokens vs Global API Key). Both work with the same headers currently.
