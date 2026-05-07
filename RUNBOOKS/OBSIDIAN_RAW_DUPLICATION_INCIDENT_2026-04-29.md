# Obsidian Raw Duplication Incident - 2026-04-29

## Summary

On 2026-04-29, the Obsidian vault candidate-note pipeline was found to have severe legacy `raw.md` duplication. The worst case was `Kai Lu (Barclays)`, where the same raw content had been repeated 1,457 times, creating a ~20 MB active source file with more than 3 million words. `Pratul Agarwal (Brevan Howard Asset Management)` had the same failure pattern at smaller scale, with 1,409 repeated entries.

The issue has been resolved in the vault. The old aggregate-append model has been replaced with dated immutable source files under each candidate folder.

Linear: OS-35 — https://linear.app/bankst-os/issue/OS-35/resolved-obsidian-candidate-rawmd-duplication-incident

## Impact

- Candidate source history became massively inflated for affected profiles.
- Reprocessing could send duplicated evidence to the model, increasing cost and making profile generation fragile.
- A single aggregate `raw.md` was both the durable evidence store and the processing source, so retry or bad-input failures could grow the active source of truth.
- The issue created a serious data-integrity concern even though the duplicated content itself was not new or contradictory.

## Root Cause

The old pipeline design used one aggregate `raw.md` per candidate. New context was appended into that file, and profile regeneration read the whole file back.

This made the system vulnerable to self-append and repeated-history inputs:

- if a source/inbox note already contained prior raw history, the processor had no structural way to distinguish new context from accumulated context;
- if duplicated blocks reached the inbox, the processor accepted them as real source history;
- failed polling and retry behavior increased exposure because files could remain active until a later successful processing run;
- there was no preflight duplicate-block guard before model submission or raw write.

## Resolution

The vault was repaired and the source model was changed.

Implemented controls:

- New context is stored as dated `sources/*.md` files inside each candidate folder.
- `raw.md` is now treated as legacy read-only evidence, not the write target for new context.
- `process_note.py` reads all source files and legacy `raw.md` only for backward-compatible profile generation.
- Duplicate guards reject repeated raw-history input, exact self-appends, and duplicate source files before any model call or source write.
- `audit_raw_duplication.py` detects oversized or repeated legacy `raw.md` files.
- `repair_raw_duplication.py` backs up duplicated `raw.md`, writes deduped evidence into `sources/`, and replaces `raw.md` with a small migration pointer.

Repair performed:

- Batch: `20260429-182926`
- Backup root: `C:\obsidian-vault\work\_raw_repair_backups\20260429-182926`
- Repair report: `C:\obsidian-vault\work\_RAW_DUPLICATION_REPAIR.md`
- Post-repair audit: `py scripts\audit_raw_duplication.py` reported `flagged files: 0`.

Affected files repaired:

| Candidate | Entries Before | Unique Preserved | Duplicate Entries Removed |
|---|---:|---:|---:|
| Kai Lu (Barclays) | 1,457 | 1 | 1,456 |
| Pratul Agarwal (Brevan Howard Asset Management) | 1,409 | 1 | 1,408 |
| Jason Goldsmith (Brevan Howard Asset Management) | 2 | 1 | 1 |
| Adam Madievsky (Citadel) | 2 | 1 | 1 |
| Patrick Limerick (Goldman Sachs Asset Management) | 28 | 14 | 14 |
| Simon Ribas (Citi) | 2 | 1 | 1 |
| Spencer Galishoff (Bank of America) | 2 | 1 | 1 |
| Josh Brodie (Bridgewater Associates) | 3 | 1 | 2 |
| Robert Blank (Goldman Sachs) | 3 | 2 | 1 |
| Brandon Shih (Brevan Howard Asset Management) | 2 | 1 | 1 |

## Follow-Up Hardening

- Keep `sources/*.md` as the only accepted write path for new candidate evidence.
- Keep `raw.md` read-only and legacy-only.
- Add raw/source integrity checks to any regular vault health command.
- Quarantine suspicious inbox files instead of repeatedly retrying them.
- Add source-history size and token thresholds before model calls.
- Require timestamped backups and reports for any future evidence repair.

## Operator Rule

For Obsidian candidate profiles, generated profiles are rebuildable. Source evidence is not. Preserve raw user evidence as small, dated, immutable files and rebuild the profile from those files.
