# Closing Report Template

Use this format when calling `board.sh done <issue> --report <file>`.
Save as a temp file (e.g. `report.md`), then run:

```bash
bash scripts/board.sh done 123 --report report.md
```

---

## Agent Completion Report

### Changed
- list files or systems modified

### Tests
- what was verified and how

### Reusable Lesson
- one or two sentences on what was non-obvious or surprising
- leave blank if nothing is worth promoting

### Possible Context Update
- [ ] GOTCHAS.md
- [ ] DECISIONS/
- [ ] product CLAUDE.md
- [ ] TASK_PATTERNS/

### Risk / Follow-up
- anything that wasn't resolved, or that could break under different conditions
