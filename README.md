# Claude Code Personal OS

A template for using Claude Code as an operating system for your life, not just your code.
Every session starts with context instead of a blank page.

## What it is

Claude Code loads `CLAUDE.md` from the folder you start in and from every parent folder
above it. Put your whole life under one root folder, and every course, job and project
inherits who you are and how you like to work, without you explaining it again.

This template gives you:

- **A root `CLAUDE.md`** with a short "who I am" block and rules that keep context from
  rotting: rules and status live in different files, volatile numbers are never written
  down, and Claude writes `TODO` instead of guessing about you.
- **Folders for studies, work, money, projects and health**, each with its own `CLAUDE.md`.
- **Health that never enters git.** Only the rules are tracked. They put urgency first,
  never give doses from memory, and log every question so doctor visits start prepared.
- **Two hooks.** At session start, Claude gets a short banner: which `CLAUDE.md` files are
  loaded, what is due in the next 14 days, how many lines are waiting in the inbox, when
  the log was last updated. After every response, everything that changed is committed to
  git, so you never have to think about it.
- **An inbox, an append-only log and a decisions file**, so loose ideas get sorted and
  rejected ideas don't come back.
- **Templates** for a new course (designed around the exam format) and a new project.
- **Two skills.** `/new-project` reads the neighbouring folders before it creates anything.
  `/review-brain` finds stale status files, dead pointers and contradictions, and fixes
  only what you approve.
- **Any language.** The template is in English, but you choose the language Claude writes
  and answers in when you install.

## Who it's for

Students and anyone else who uses Claude Code for more than code, and is tired of starting
every session by explaining themselves.

## Getting started

Requirements: macOS or Linux, git, python3, and [Claude Code](https://claude.com/claude-code).

```bash
git clone https://github.com/josannes/claude-code-personal-os
cd claude-code-personal-os
./install.sh ~/brain
```

The installer asks which language to use (or pass `--lang Spanish`). It copies the
template to `~/brain`, creates a git repository there, and connects it to Claude Code:

- `~/.claude/CLAUDE.md` becomes a link to the brain's global file. An existing one is
  moved to a backup first, so copy anything you want to keep into the new file.
- The skills are linked into `~/.claude/skills/`.
- The hooks are added to `~/.claude/settings.json`, after a backup. Your other settings stay.

Then:

1. Fill in the `TODO`s in `~/brain/CLAUDE.md` and `~/brain/00_me/PROFILE.md`.
2. Start a Claude Code session in `~/brain` and ask "what do you know about me?".
3. Run `/new-project` for your first course or project.

**Changed your mind?** `./uninstall.sh` removes the links and hooks and restores the global
`CLAUDE.md` you had before. Your brain folder is left alone.

**Using iCloud Drive or Dropbox?** Git and file sync fight over the same small files.
Keep the history outside the synced folder:

```bash
./install.sh "~/Library/Mobile Documents/com~apple~CloudDocs/brain" --git-dir ~/.brain.git
```

**Want a backup?** Create a **private** repository and add it as `origin`. Auto-commit
pushes once a remote exists. Your brain will hold your life, so never make it public.

```bash
git -C ~/brain remote add origin <your-private-repo-url>
```

## How it works

`brain/HANDBOOK.md` explains the inheritance chain, why hooks and skills are registered in
`~/.claude/` instead of the brain, why git lives outside cloud sync, and why rules and
status are kept apart. It is copied into your brain, so Claude can read it too.

```
brain/
├── CLAUDE.md          who you are, the map, the rules
├── HANDBOOK.md        how it works and why
├── inbox.md           loose things, sorted later
├── deadlines.md       dates that matter, shown at session start
├── LOG.md             what happened, newest first
├── DECISIONS.md       choices made, and why
├── 00_me/             your profile
├── 01_studies/        one folder per term, one per course
├── 02_work/           job, applications, CV
├── 03_money/          budget and overview
├── 04_projects/       everything else in progress
├── 05_ai/claude/      hooks, skills, global CLAUDE.md
├── 06_health/         health, only the rules are in git
└── _templates/        course and project templates
```

Delete the folders you will never use.

## Testing

```bash
tests/smoke.sh
```

Installs into a throwaway home folder, so your real `~/.claude` is never touched, runs both
hooks with fake input, and uninstalls again.

## Why I built it

I use Claude Code for school, work, money and side projects. Every new session started
from zero, and I kept explaining the same things. So I put everything under one root and
let the folders carry the context. I use my own version every day, and this repo is that
setup turned into a template anyone can fill with their own life.

## Built with Claude Code

I owned the idea, the spec, testing and priorities. Claude Code wrote the code. That's how
I build.

## Status

v0.1. Planned next: a style guard hook that blocks phrases you never want in text you hand
in, a skill that connects a code repo to its project folder, adding to the inbox from your
phone, and a fictional example brain.

## License

MIT
