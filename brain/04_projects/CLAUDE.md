# Projects

Applies to everything under `04_projects/`. Inherits the root `CLAUDE.md`.

Everything in progress that is not school or paid work: side projects, trips, ideas that
have moved past the idea stage.

## Structure

One folder per project, made with `/new-project`. Each folder has at least:

- `CLAUDE.md`: what the project is, goals, limits, decisions
- `status.md`: where it stands and the next step, updated when something changes

## Code does not live here

Code repos have their own git history and thousands of files. Keep them outside the brain,
for example in `~/code/<repo>`, and give the project folder here the same name. The folder
here holds context, decisions and documents, and points to the repo.

**The bridge**, so a session started in the repo still has context:

1. `CLAUDE.local.md` in the repo root, pointing here:

   ```markdown
   Private context for this repo: <brain>/04_projects/<repo>/CLAUDE.md and status.md.
   Read both before doing anything. Update status.md when something changes.
   ```

2. Read access to the brain in the repo's `.claude/settings.local.json`:

   ```json
   { "permissions": { "additionalDirectories": ["<brain>"] } }
   ```

Both files must be gitignored in the repo. Nothing personal goes into a public repo.
