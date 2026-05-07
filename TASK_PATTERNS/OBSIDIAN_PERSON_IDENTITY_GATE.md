# Obsidian Person Identity Gate

Use this pattern whenever an agent processes Obsidian candidate notes and the notes mention other people.

## Core Rule

No person enters the graph without a human-approved identity.

Agents must not create or preserve a generated `[[Name (Firm)]]` person wikilink unless:

1. the exact candidate profile already exists at `work/Candidate Notes/Name (Firm)/Name (Firm).md`, or
2. the user explicitly approves creating that profile.

## Workflow

1. Preserve raw notes exactly as supplied.
2. Process or reprocess the candidate through the normal vault pipeline.
3. Match mentioned people only to exact approved candidate profile targets.
4. Keep unmatched people as plain text in generated profile bodies.
5. Rebuild the potential-profile queue:

```bash
py scripts/list_potential_profiles.py
```

6. Remove unresolved person-style wikilinks from normal vault markdown so they do not appear as grey graph nodes:

```bash
py scripts/resolve_vault_unresolved_links.py --apply
```

This does not edit `raw.md`. Removed targets are written to `work/_UNRESOLVED_WIKILINK_REVIEW.md` / `.csv`.

7. Rebuild the review queue:

```bash
py scripts/flag_issues.py --quiet
```

8. Check for root ghost notes and invalid profile artifacts:

```bash
py scripts/ghost_notes.py
py scripts/audit_profile_artifacts.py
```

9. If the user approves a new profile, create it through:

```text
work/_inbox/Name (Firm).md
```

Then run:

```bash
py scripts/process_note.py "Name (Firm).md" --no-stream
```

## Do Not Infer Identity From Context

Never infer a mentioned person's current firm from:

- the call subject's current firm
- a historical employer
- a mandate target
- an interview process
- a desk/team being discussed
- nearby firm names in a list

Those contexts are evidence to preserve, not approval to create a profile identity.

## Reports

- `work/_POTENTIAL_PERSON_PROFILES.md` - names that may deserve future profiles, pending human review
- `work/_POTENTIAL_PERSON_PROFILES.csv` - sortable version of the same queue
- `work/_UNRESOLVED_WIKILINK_REVIEW.md` - unresolved person-style wikilinks converted to plain text
- `work/_UNRESOLVED_WIKILINK_REVIEW.csv` - sortable version of the unresolved-link review
- `work/_UNAPPROVED_PERSON_WIKILINKS.md` - generated person links that still point to no approved profile
- `work/_PROFILE_ARTIFACT_AUDIT.md` - root ghosts, missing raw files, short profiles, duplicate profile files
- `work/_REVIEW.md` - overall quality queue

## Incident Example

Gil Song had an approved profile as `Gil Song (Point72 Asset Management)`.

Generated profiles incorrectly inferred:

- `Gil Song (Man Group)` from a historical Man Group team context
- `Gil Song (Jefferies)` from a historical sell-side desk context
- `Gil Song (DLD Asset Management)` from a candidate's current-firm context

The correct behavior is to keep those mentions as plain text or retarget them to the approved `Gil Song (Point72 Asset Management)` profile only when the identity is clear. Do not create ghost profiles or ghost wikilinks.
