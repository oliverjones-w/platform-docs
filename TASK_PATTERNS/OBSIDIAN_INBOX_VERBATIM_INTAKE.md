# Obsidian Inbox Verbatim Intake

Use this pattern when a user asks an agent to create an Obsidian vault inbox file from call notes, meeting notes, LinkedIn notes, or other raw candidate intelligence.

## Rule

When creating an inbox file from user-supplied notes, paste the user's raw notes verbatim.

Do not summarize, rewrite, normalize, enrich, infer, clean up, or reorder the user's note text before writing the inbox file.

## Workflow

1. Ask the user for the candidate's current firm if it is missing or uncertain.
2. Confirm the firm with the user before using it in the inbox filename.
3. Create the file only after the filename can satisfy the vault contract:

```text
work/_inbox/Name (Firm).md
```

4. Write the user's note body exactly as provided.
5. Add only clearly separated metadata if the user supplied it explicitly, such as `Name:`, `Current firm:`, `LinkedIn:`, or `Call date:`.
6. Do not invent missing metadata. Leave missing values blank or ask the user.

## Rationale

The Obsidian vault processor treats `Name (Firm).md` as an identity and routing contract. A wrong firm in the filename can create an incorrect profile folder, lookup path, and downstream graph edge.

The raw note body is source material. Preserving it verbatim keeps the workflow auditable and prevents agent-introduced phrasing from becoming false source evidence.

## Agent Guardrails

- If the user pastes notes in chat, create the inbox file as a paste-through operation.
- If the firm is not known, do not guess from memory.
- If the user supplies a LinkedIn URL but no firm, ask whether the firm shown on LinkedIn should be used.
- If current firm and historical firm are both present, ask which firm is current before naming the file.
- Never write `Name ().md`.
- Never overwrite `raw.md`; existing profile raw notes remain append-only.
