# platform-docs

Cross-repo platform documentation for the bankst-os stack.

This repo is the macro view of the system. It is the neutral reference point across:

- Dell ingestion and automation
- Mac runtime and gateway
- public edge / Cloudflare exposure
- cross-repo issues, risks, and active projects

## Primary Docs

- [CONTROL_PLANE.md](./CONTROL_PLANE.md) - explicit definition of the shared operating layer across repos, devices, humans, and agents
- [BOOTSTRAP.md](./BOOTSTRAP.md) - device-neutral startup pointer to the canonical context layer
- [ONBOARDING.md](./ONBOARDING.md) - minimal startup reference for humans and agents
- [CONTEXT_TREE.md](./CONTEXT_TREE.md) - staged reading paths for efficient agent and human navigation
- [INFRASTRUCTURE_MAP.md](./INFRASTRUCTURE_MAP.md) - per-machine operational schematic (services, ports, paths, automation)
- [SYSTEM_MAP.md](./SYSTEM_MAP.md) - current runtime architecture and host responsibilities
- [NAMING.md](./NAMING.md) - canonical project, product, and domain naming
- [OWNERSHIP.md](./OWNERSHIP.md) - minimal source-of-truth and accountability map
- [WORKING_RULES.md](./WORKING_RULES.md) - engineering operating rules for humans and agents
- [CLOUDFLARE_ACCESS.md](./CLOUDFLARE_ACCESS.md) - edge auth configuration, API access, and policy management
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
