# Obsidian Call Note Command Intake

Use this pattern when a user pastes call notes that mix raw candidate intelligence with instructions to the agent.

This is broader than plain inbox intake. The user may paste a single messy note containing candidate facts, LinkedIn URLs, profile context, relationship-management commands, research questions, reminders, and corrections.

## Core Rule

Preserve the complete user paste first. Then route commands by system of record.

Do not collapse the paste into only a cleaned profile note. The raw context is source evidence and must remain auditable.

Person identity is human-gated. Agents may surface mentioned people and suggest new profiles, but they must not create or preserve `[[Name (Firm)]]` person wikilinks unless the exact candidate profile already exists or the user explicitly approves creating it.

## Systems Of Record

- Raw call context: `work/_staging/call_context/YYYY-MM-DD/`
- Candidate profile input: `work/_inbox/Name (Firm).md`, then `work/Candidate Notes/Name (Firm)/raw.md`
- Relationship management: `work/Operations/ops.db` table `pipeline`
- Research tasks: `work/Operations/ops.db` table `research_tasks`
- Generated profile: `work/Candidate Notes/Name (Firm)/Name (Firm).md`
- Potential profile queue: `work/_POTENTIAL_PERSON_PROFILES.md` and `.csv`

## Workflow

1. Save the full pasted call note exactly as provided under:

```text
work/_staging/call_context/YYYY-MM-DD/Name (Firm) - raw context.md
```

2. Identify the current candidate and current firm. If the firm is missing or ambiguous, ask before creating the inbox file.

3. Create the processing input only after the filename can satisfy the vault contract:

```text
work/_inbox/Name (Firm).md
```

4. Paste the note body verbatim into the inbox file. Do not summarize, reorder, infer, or clean it before processing.

5. Extract commands and route them separately:

- Relationship-management commands go to `pipeline`.
- Open-ended investigation commands go to `research_tasks`.
- Profile facts remain in the candidate raw/profile flow.
- Ambiguous commands should be preserved in raw context and surfaced in the response.

6. Run profile processing:

```bash
py scripts/process_note.py "Name (Firm).md" --no-stream
```

7. Rebuild human-review queues:

```bash
py scripts/list_potential_profiles.py
py scripts/resolve_vault_unresolved_links.py --apply
py scripts/flag_issues.py --quiet
py scripts/ghost_notes.py
py scripts/audit_profile_artifacts.py
```

8. After processing, return a receipt that includes:

- raw-context path
- profile path
- pipeline changes
- research task changes
- potential-profile queue status
- open ambiguities or manual follow-ups

## Routing Rules

### Pipeline

Use `pipeline` for relationship state and concrete communication actions.

Examples:

- send a text or email
- set up a text thread
- schedule coffee
- arrange an in-person meeting
- send a template or follow-up material
- update contact status after a call
- record that someone responded, passed, or is in process

Pipeline rows are keyed by relationship context. Do not create research tasks for ordinary relationship follow-up.

### Research Tasks

Use `research_tasks` for open-ended investigation work.

Examples:

- identify an unknown person from a phonetic hint
- confirm who reports to whom
- figure out which trader left a firm
- research a desk, pod, or team structure
- verify a firm-level policy change
- resolve a source-data mismatch

Research tasks are usually firm/topic-level, not organized around the person whose call generated the task. The call source belongs in `source_file` and `source_excerpt`.

### Profile Facts

Use the normal profile flow for facts about the candidate:

- role, seat, strategy, asset class
- performance, capital, risk, PnL, Sharpe
- openness, motivation, timing, non-compete
- named people mentioned on the call
- LinkedIn URL

Do not treat the generated profile's `Next Steps` section as the durable operations queue. Durable actions belong in `pipeline` or `research_tasks`.

### Mentioned People And Wikilinks

Use this workflow for every person mentioned in raw notes:

1. Preserve the person's name in raw notes exactly as supplied.
2. Match the name to an existing approved candidate profile only when the identity is clear.
3. If the exact approved profile exists, generated profile bodies may use that existing `[[Name (Firm)]]` wikilink.
4. If no exact approved profile exists, keep the mention as plain text in generated profile bodies.
5. Add or refresh the name in `work/_POTENTIAL_PERSON_PROFILES.md` / `.csv`.
6. Convert unresolved person-style wikilinks outside `raw.md` to plain text using `py scripts/resolve_vault_unresolved_links.py --apply`.
7. Suggest creating a new profile only as a human review action. Do not create one silently.
8. If the user approves creation, stage `work/_inbox/Name (Firm).md` and run `py scripts/process_note.py` so the profile receives `raw.md`, YAML frontmatter, `vault_id`, lookup status, and processing manifests.
9. If the user does not approve creation, the mention remains plain text and the original raw note remains unchanged.

Never infer a person's current firm from:

- the candidate's current firm
- a prior employer mentioned in the note
- a mandate or interview target
- a desk/team being discussed
- nearby firm names in an execution list

This prevents ghost identities such as `[[Gil Song (Man Group)]]` when the approved profile is `[[Gil Song (Point72 Asset Management)]]` and the note only discussed a historical Man Group team context.

## Clarifications After Processing

If the user clarifies the meaning of a phrase after the profile has been generated:

1. Save a separate clarification note under `work/_staging/call_context/YYYY-MM-DD/`.
2. Append a dated clarification to the candidate's `raw.md` without deleting or rewriting earlier text.
3. Reprocess the profile:

```bash
py scripts/process_note.py "Name (Firm)" --reprocess --no-stream
```

4. If the model keeps a completed action as a generated checkbox, remove that checkbox from the generated profile after verifying the durable queue already has the action.
5. Rebuild `work/_POTENTIAL_PERSON_PROFILES.md`, `work/_UNRESOLVED_WIKILINK_REVIEW.md`, and `work/_REVIEW.md`.

## Examples

### Relationship command

User note:

```text
REMINDER - add this to pipeline - need to set up a text thread and potentially get coffee; soft yes on phone
```

Route:

- Update `pipeline` with status/contact/action/notes.
- Do not create a research task.

### Research command

User note:

```text
Team in Geneva - bond guy - name sounds like Chiltern - find out who this is
```

Route:

- Add `research_tasks` row tied to the firm/topic.
- Preserve source file and source excerpt.
- Do not organize the task around the candidate unless the candidate is the subject of the research.

### Clarified candidate context

User clarification:

```text
That was a question Allen asked me, not my action item.
```

Route:

- Append clarification to `raw.md`.
- Reprocess the profile.
- Remove any mistaken generated action item after verification.
