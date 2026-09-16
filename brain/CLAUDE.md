# CLAUDE.md: your brain

This file is loaded automatically in **all** work under this folder. It is the root of the
system. How the system works and why: `HANDBOOK.md`.

Claude Code loads `CLAUDE.md` from the folder a session starts in **and every parent folder
above it**. Every subfolder therefore inherits this file. A subfolder never repeats what is
written further up. If two layers contradict each other, the nearest one wins, and the
contradiction is reported to the user.

---

## Who I am

<!-- Keep this short: ten lines at most. It is loaded in every session.
     Everything else goes in 00_me/PROFILE.md. Delete this comment when done. -->

- Name: TODO
- Where I live: TODO
- What I do (study, work): TODO
- What I use Claude Code for: TODO
- How I like answers: TODO (for example: one concrete recommendation, not a list of options)

Everything else (background, skills, history, what works for me when learning) is in
**`00_me/PROFILE.md`**. Read it when the answer depends on it: applications, CVs, money,
study choices, "is this relevant for me". Not otherwise.

---

## Map

| Folder | What | When |
|---|---|---|
| `00_me/` | Profile, personal documents | Anything about who I am |
| `01_studies/` | One folder per term, one subfolder per course | Courses, exams, assignments |
| `02_work/` | Current job, job search, CVs, applications | Anything paid |
| `03_money/` | Budget, fixed costs, overview | Money |
| `04_projects/` | Side projects, trips, anything else in progress | Projects |
| `05_ai/` | The Claude Code setup: hooks, skills, global `CLAUDE.md` | Changing how Claude works |
| `_templates/` | Templates for a new course and a new project | When something new starts |
| `99_archive/` | Deactivated, not deleted. Never a source of truth | Rarely |

Delete the folders you will never use. Root files: `inbox.md` (loose things not sorted
yet), `LOG.md` (what happens, chronologically) and `DECISIONS.md` (choices made, with
reasons). LOG and DECISIONS are **append-only**: never rewrite old entries, add new ones.

---

## Rules

**Rules and status are kept apart.** A `CLAUDE.md` only contains what stays true for six
months: who, how, where. Anything that changes more often (how far something has come,
what is missing, next step) goes in `progress.md` or `status.md`, dated, newest first.
No "last updated" lines in files: git knows.

**Don't write down volatile numbers.** Free disk space, hours, account balances. Write
where the number is checked instead. A number that needs a date to be true gets a date.

**Whoever finds an error fixes it.** If a file does not match reality (a dead pointer, an
outdated fact, a status that has passed), fix the file in the same session and say so.
Don't work around it.

**Keep the brain alive.** When something lasting changes (new job, new term, new budget),
update `00_me/PROFILE.md` and add a line to `LOG.md`. Say that you did.

**Never invent facts about me.** If something is uncertain, the file says `TODO` or
`UNSURE`. Ask rather than guess. Wrong context is worse than no context.

**The inbox.** When I say "add to inbox", add a dated line to `inbox.md` in this root.
When a session starts in the root and the inbox has content, offer to move each line to
where it belongs and empty the file. The inbox should always be close to empty.

**Context is written where it belongs.** Something general about me learned while working
in a course folder goes in `00_me/PROFILE.md`, not in the course's `CLAUDE.md`. Course
details don't go up to the root.

**New folders are made from templates** with `/new-project`. Don't improvise structure.

**Sensitive files.** `00_me/documents/` holds contracts, IDs and similar. It is gitignored,
and its content is never copied into a file that ends up in git, an application, or an
answer that gets shared.

**Look in the neighbouring folders.** New course: read `_templates/course/PATTERNS.md` and
look at earlier course folders for inspiration, not as a blueprint. New application: read
`00_me/PROFILE.md` and earlier applications. The system is built for you to look things up
yourself.

---

## Language

- Content language: **English**.

Write all content in this brain, and answer me, in the content language above. Folder
names, file names and structural keywords (`status`, `progress`, `decisions`) stay in
English, so tools and templates keep working.
