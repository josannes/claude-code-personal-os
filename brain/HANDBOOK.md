# HANDBOOK: how the system works

Read `CLAUDE.md` for the rules, this file for the understanding.

---

## The idea in one sentence

Everything you use Claude Code for lives under one root, and because Claude Code loads
`CLAUDE.md` from the folder you start in **and every parent folder above it**, every
project inherits context automatically without anyone doing anything.

That is the whole trick. The rest follows from it.

---

## The mechanism

Start a session in a course folder, and Claude Code loads these before you type a word:

```
~/.claude/CLAUDE.md                        points to the brain, works EVERYWHERE on the machine
<brain>/CLAUDE.md                          who you are, rules, map
<brain>/01_studies/CLAUDE.md               rules shared by all courses
<brain>/01_studies/<term>/CLAUDE.md        the active term (optional)
<brain>/01_studies/<term>/<course>/CLAUDE.md   this exact course
```

Each layer is narrower than the one above. **A layer never repeats what is written further
up.** If two layers contradict each other, the nearest one wins.

`~/.claude/CLAUDE.md` is the only layer that works outside the root. It says where the
brain is, so a session in a code repo somewhere else can still find its way here.

**What is not inherited upwards:** hooks, skills and `.claude/rules/` are only read from
the folder you start in and from `~/.claude/`. That is why `install.sh` registers them in
`~/.claude/`, while the files themselves live in `05_ai/claude/`, inside the brain, where
they are versioned with everything else.

---

## Rules and status are two different things

This is the principle that keeps the brain from rotting.

- **Rules** live in `CLAUDE.md` files and stay true for six months: who you are, how you
  want to work, where things are.
- **Status** lives in `progress.md` (courses) or `status.md` (projects, jobs), dated,
  newest first: how far something has come, what is missing, next step.

Mix them, and the rule files start lying within a week. Volatile numbers (disk space,
balances, hours) are not written down at all. Write where they are checked. And when
Claude finds something that is wrong, the file is fixed in the same session.

---

## Workflow

### Starting something new

Run **`/new-project`**. It finds the right place, reads the neighbouring folders, copies
the right template, fills it in with what it finds, and adds a line to `LOG.md`.

The point is not to save you a `mkdir`. The point is that it **reads first**: lessons from
old courses before a new course, your profile and earlier applications before a new
application. A folder made by hand starts blank.

### Working in something that exists

Just start a session there. Inheritance happens by itself. No startup routine.

### A new course

1. `/new-project` and say which course
2. The first task in the course is reading the course description and the exam format
3. The folder is designed around the exam, with `_templates/course/PATTERNS.md` as
   experience, not a blueprint
4. Fill in exam date, allowed aids and your goal

### Deadlines

Say "the exam is on 12 December" in any session, and Claude adds `- 2026-12-12: exam` to
the nearest `deadlines.md`. Every session in the brain starts with what is due in the next
14 days, so nothing sneaks up on you.

### Keeping it alive

Once a month, or when something feels off, run **`/review-brain`**. It finds stale status
files, dead pointers, open TODOs, contradictions between layers and passed deadlines, and
proposes fixes. It changes nothing until you say which ones to make.

### Health

`06_health/` is the one folder whose content never enters git: only its `CLAUDE.md` is
tracked. Start a session there with a health question. The rules put urgency first, never
give doses from memory, and log every question so the next doctor visit starts prepared.
Fill in the sources and emergency numbers for your country before relying on it, and
remember that what Claude reads is still sent to Anthropic.

### The inbox

`inbox.md` is where loose things land: an idea, something to remember to ask, a file you
don't know where to put. Say "add to inbox: ..." in any session. When you start a session
in the root, Claude offers to sort the inbox and empty it.

---

## The hooks

A hook is a script Claude Code runs automatically at a fixed moment. Both hooks find the
brain from their own location, and do nothing when a session runs outside the brain.

| Hook | When | What |
|---|---|---|
| `session-start.sh` | Session start | A short banner in Claude's context: which `CLAUDE.md` files are loaded, age of `PROFILE.md`, last LOG date, inbox lines, uncommitted files, open TODOs, and deadlines in the next 14 days. Warns about files that are only in iCloud |
| `auto-commit.sh` | Every time Claude finishes a response | Commits everything that changed in the brain. Pushes in the background if a remote named `origin` exists |

Turn auto-commit off for a session with `BRAIN_AUTOCOMMIT=0`. Test a hook by hand:

```bash
echo '{"cwd":"'"$PWD"'"}' | 05_ai/claude/hooks/session-start.sh
```

---

## Why it is built this way

**A hook after every response, not at session end.** In the desktop app, sessions are
rarely ended explicitly, so a session-end hook almost never runs. Committing after every
response is the only thing that works without you thinking about git.

**Git outside cloud sync.** iCloud, Dropbox and friends write to the same thousands of
small files as git, which is a known way to corrupt history. If your brain lives in a
synced folder, install with `--git-dir` so the history lives outside it.

**The setup lives in the brain, not in `~/.claude/`.** `~/.claude/` is not versioned or
backed up. `install.sh` only puts symlinks and hook entries there. `settings.json` is
edited in place rather than symlinked, because Claude Code writes to it itself and can
replace a symlink with a plain file.

**Health outside git, not just private.** Auto-commit pushes after every response, and git
history never forgets. Health notes have no place in it. A separate top-level folder also
means a school or work session never loads health data by accident.

**A short identity block in the root, the full profile on demand.** Irrelevant facts in
every session are noise. Relevant facts should be easy to find, not always loaded.

**Code lives outside the brain.** Code repos have thousands of files and their own git
history. A project folder in `04_projects/` holds context and decisions and points to the
repo. See `04_projects/CLAUDE.md` for the bridge.

**Old course folders are experience, not blueprints.** Every course is designed around its
own exam. What carried over is written down in `_templates/course/PATTERNS.md`.

---

## Sessions

Each session is tied to the folder it started in, and the app shows history per folder.
Rename a folder, and the old sessions no longer show under the new name. Simple rule:
**term and course folders never get renamed.**

---

## Tips

**Check that inheritance works.** Start a session in a new folder under the root and ask
"what do you know about me?". An empty answer means the folder is outside the root, or a
cloud service has evicted the local copy (in iCloud, set the folder to "Keep Downloaded").

**Disconnecting.** `uninstall.sh` in the template repository removes the links and hooks
from `~/.claude/` and restores the global `CLAUDE.md` you had before. The brain stays.

**`TODO` and `UNSURE` in files are on purpose.** The system should never guess about you.
See a `TODO` you can answer? Answer it, and it disappears.
