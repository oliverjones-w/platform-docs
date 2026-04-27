# scripts

Purpose: cross-repo, cross-machine utilities that support the `bankst-os` platform operating layer.

This directory is for scripts that help with:

- system visibility
- platform health checks
- documentation/bootstrap workflows
- platform tooling and maintenance

## What Belongs Here

- scripts that operate across Dell and Mac
- scripts that support `platform-docs`
- scripts that help maintain the shared engineering operating system

## What Does Not Belong Here

- product implementation logic
- repo-local business logic
- subsystem-specific runtime code that belongs in an owning repo
- personal experiments that are not intentionally promoted into the platform layer

## Current Scripts

- `health_snapshot.sh` - cross-machine health snapshot for the live stack
- `board.sh` - deprecated; was GitHub Projects interface (now replaced by Linear MCP)
- `seed_github_issues.sh` - deprecated; was GitHub issue bootstrapper
