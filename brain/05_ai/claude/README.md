# The Claude Code setup

Everything Claude Code specific that is not a `CLAUDE.md` file lives here, so it is
versioned with the rest of the brain. `~/.claude/` only holds pointers here, set up by
`install.sh`.

| Here | In `~/.claude/` | What |
|---|---|---|
| `global-CLAUDE.md` | `CLAUDE.md` (symlink) | The global layer, works everywhere on the machine |
| `skills/<name>/` | `skills/<name>` (symlink) | One folder per skill |
| `hooks/` | entries in `settings.json` with full paths | See `HANDBOOK.md` |

## Adding a skill

Create `skills/<name>/SKILL.md`, then link it:

```bash
ln -s "$PWD/skills/<name>" ~/.claude/skills/<name>
```

## Why not `<brain>/.claude/`

Hooks, skills and `.claude/rules/` are not inherited from parent folders. In `<brain>/.claude/`
they would only work when a session starts in the root itself, not in a course folder.
