# ADR-002 — Auth Model: Cloudflare Access At The Public Edge

- `Date:` 2026-04-26
- `Status:` Decided
- `Related Issues:` SYS-001
- `Related Projects:` PROJ-001

## Context

`bankst.co` is served publicly via Cloudflare Tunnel from the Mac runtime host. The gateway and downstream services (mapping, core, FINRA, BBG) expose sensitive hedge fund and firm data. An enforced identity gate was needed before this surface could be considered secured.

Three approaches were considered:
1. Cloudflare Access at the public edge
2. Auth middleware inside the gateway (`:7842`)
3. Both (defense in depth)

## Decision

**Cloudflare Access** is the primary authentication layer.

All traffic entering through the Cloudflare Tunnel must clear an Access policy before reaching any backend service. The gateway and downstream services operate behind that gate and do not implement their own redundant auth layer.

## Alternatives Considered

- **Gateway middleware only:** Would require engineering effort and would not protect against traffic that bypasses the gateway. Cloudflare Access is simpler and enforced upstream.
- **Defense in depth (both):** Valid long-term posture, but gateway middleware is lower priority once the edge gate is in place. Can be revisited if internal Tailscale access needs scoping.

## Consequences

- Unauthenticated public requests are blocked at Cloudflare before reaching the Mac.
- Local / Tailscale access to the Mac bypasses Cloudflare Access — treat that network as trusted.
- If the Cloudflare Tunnel is misconfigured or bypassed, no fallback auth exists at the gateway layer.
- The Access policy must be kept current as protected routes change.

## Open Questions

- Are all current gateway routes (core, finra, mapping, encore) confirmed under the Access policy scope?
- Should the unused `/system -> :9000` route be removed before or after policy scope is finalized? (See SYS-004.)
