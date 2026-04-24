# platform-docs

Cross-repo platform documentation for the Bay Street / bankst stack.

This repo is the macro view of the system. It is the neutral reference point across:

- Dell ingestion and automation
- Mac runtime and gateway
- public edge / Cloudflare exposure
- cross-repo issues, risks, and active projects

## Primary Docs

- [SYSTEM_MAP.md](./SYSTEM_MAP.md) - current runtime architecture and host responsibilities
- [ISSUE_REGISTRY.md](./ISSUE_REGISTRY.md) - durable system-level issue registry
- [PROJECT_BOARD.md](./PROJECT_BOARD.md) - live board of active and queued projects

## Supporting Directories

- [DECISIONS](./DECISIONS/README.md) - architectural decisions and ADRs
- [RUNBOOKS](./RUNBOOKS/README.md) - operational runbooks and recovery procedures
- [HANDOFFS](./HANDOFFS/README.md) - environment-specific handoff notes

## Rules

- Product repos own implementation details.
- `platform-docs` owns cross-repo system context.
- GitHub Issues / Projects should be the live execution layer.
- Markdown here should explain the system, not replace the issue tracker.
