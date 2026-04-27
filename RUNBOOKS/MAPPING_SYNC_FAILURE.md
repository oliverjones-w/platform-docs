# Mapping Sync Failure

Last updated: 2026-04-27

Purpose: minimal runbook skeleton for Dell -> Mac mapping sync failures.

## Scope

This runbook applies when Dell-generated mapping DBs are not reaching the Mac runtime correctly.

## Current Known Transport

- Dell sync source: `mapping_tools`
- Transport: Tailscale + SSH/SCP
- Target path uses the `macdev` SSH alias

## Known Failure Mode

- Tailscale re-auth can interrupt the Dell -> Mac transport leg
- Result: Mac may continue serving stale mapping data

## Minimum Checks

1. Check Dell task execution/logs
2. Check transport/auth state
3. Check Mac-side data freshness

## Not Yet Documented

- exact Dell recovery steps
- exact Mac verification commands
- stale-data threshold
- alerting path

## Next Step

- expand this runbook only after the team agrees on the desired recovery/verification workflow
