---
name: review-brain
description: Reviews the user's brain for rot and reports what to fix, without changing anything until the user says yes. Finds stale status files, dead pointers, open TODOs, contradictions between CLAUDE.md layers, an inbox that isn't emptied, passed deadlines and health data outside the health folder. Use when the user asks to review, audit, clean up or check the brain, or says something like "is my setup still up to date?".
---

# Review the brain

A brain that looks up to date but isn't is worse than no brain. Keeping it alive is a
habit nothing enforces, so this review is what catches it. **Change nothing until the
user has said yes.**

**The brain root** is the path in `~/.claude/CLAUDE.md` (the heading "The brain is at").
All paths below are relative to it.

## Steps

**1. Read the rules first:** the root `CLAUDE.md`, then every `CLAUDE.md` below it except
under `99_archive/`. Don't read anything in `06_health/` except its `CLAUDE.md`.

**2. Run the mechanical checks.** Use `git log -1 --format=%cs -- <file>` for the date a
file last changed, and fall back to the file's modification time if it isn't in git.

| Check | Report when |
|---|---|
| Stale status | A `status.md` or `progress.md` hasn't changed in 30 days, and its folder isn't marked as finished |
| Stale profile | `00_me/PROFILE.md` hasn't changed in 90 days |
| Quiet log | The newest `LOG.md` entry is more than 30 days old |
| Open TODOs | `TODO` or `UNSURE` in any `CLAUDE.md` or `PROFILE.md`. List file and line |
| Placeholders | `<angle bracket placeholders>` left in a file outside `_templates/` |
| Dead pointers | A path in backticks in a `CLAUDE.md` or `status.md` that doesn't exist |
| Inbox | `inbox.md` has lines older than 7 days |
| Passed deadlines | Lines in a `deadlines.md` with a date before today that aren't ticked off |
| Health leak | `git ls-files 06_health` lists anything other than `06_health/CLAUDE.md` |
| Sensitive files in git | `git ls-files` lists anything under `00_me/documents/`, or files named like `.env` or `*.pem` |
| Empty folders | A folder under `01_studies/`, `02_work/` or `04_projects/` with no `CLAUDE.md` |

**3. Do the judgement checks.** These need reading, not scripts:

- **Contradictions between layers.** A subfolder `CLAUDE.md` that says the opposite of a
  file above it. Quote both lines.
- **Repetition.** A subfolder `CLAUDE.md` that repeats rules already in a parent.
- **Status in rule files.** Progress, next steps or dated numbers inside a `CLAUDE.md`.
  They belong in `status.md` or `progress.md`.
- **Volatile numbers.** Balances, disk space or hour counts written down without a date.
- **Wrong place.** Something general about the user written in a course or project folder
  instead of `00_me/PROFILE.md`.
- **Decisions without a record.** A choice described in a `status.md` or `LOG.md` that
  should be in `DECISIONS.md` so it isn't made again.

**4. Report.** One list, most important first. Three groups:

```
Fix now          (wrong or risky: health or sensitive files in git, contradictions, dead pointers)
Worth doing      (stale status, passed deadlines, old inbox lines, status in rule files)
Can wait         (TODOs, repetition, empty folders)
```

Each item: file and line, what is wrong in one sentence, and the concrete fix. Say what is
fine too, in one line at the end, so the user knows the review actually looked.

**5. Ask which fixes to make.** When the user answers, make exactly those fixes, and add
one line to `LOG.md`: that a review was done and what was fixed.

## Rules

- Never read or quote health data. For a health leak, report the file names only.
- Never delete anything. Old material goes to `99_archive/`, and only when the user says so.
- Don't fix a TODO by guessing. Ask the user, or leave it.
