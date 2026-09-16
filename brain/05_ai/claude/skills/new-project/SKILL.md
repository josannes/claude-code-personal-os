---
name: new-project
description: Creates a new folder in the user's brain with the right location, CLAUDE.md from a template and a line in LOG.md. Use when the user starts a new course, project, side project, job application, trip or anything else new that should have its own folder.
---

# New folder in the brain

The goal: no loose folders in `~/Downloads`, and every new folder starts with context
instead of a blank page.

**The brain root** is the path in `~/.claude/CLAUDE.md` (the heading "The brain is at").
All paths below are relative to it. Never create anything outside it with this skill.

## Steps

**1. Find out what it is.** Only ask if it does not follow from what the user wrote.

| Type | Location | Template |
|---|---|---|
| Course | `01_studies/<term>/<course>/` | `_templates/course/` |
| Job application | `02_work/applications/<company>-<role>-<YYYY-MM>/` | `_templates/project/` |
| Project, side project, trip | `04_projects/<name>/` | `_templates/project/` |

Term folders are named as `01_studies/CLAUDE.md` says. If the term folder does not exist,
create it. Folder names are short, lowercase or course codes, no spaces.

**2. Read the neighbouring folders before writing anything.** This is the whole point.

- New course: **read `_templates/course/PATTERNS.md` first.** It is experience from earlier
  courses, not a template to pick from: the folder is designed around the new course's exam
  format. Fixed regardless: `_source/`, `_raw/`, `progress.md`, `mistakes.md`. If the course
  continues an earlier one, bring over the lessons from its `mistakes.md`.
  **Never change an old course folder.**
- New application: read `00_me/PROFILE.md`, `02_work/cv/` and earlier applications.
- New project: read `00_me/PROFILE.md`, and `03_money/overview.md` if it exists, so the
  limits in the template can be filled in with real numbers instead of placeholders.

**3. Copy the template and fill it in.** Never leave `<placeholders>` standing. Fill in what
you know from step 2, and ask the user about the rest in one round, not one question at a time.
Anything still unknown after that becomes `TODO`.

**4. Add a line to `LOG.md`** at the top, under the header, with today's date: what was
created and where.

**5. Tell the user where the folder is** and what to do first.

## Rules

- Never copy content from `00_me/documents/` into a new folder.
- If it is unclear whether something is a project or just a task, it is usually not worth
  its own folder. Say so instead of creating it.
- Code does not go in the brain. For a code project, create the project folder here and
  suggest the bridge described in `04_projects/CLAUDE.md`.
