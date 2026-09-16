# Global context

Applies to everything Claude Code does on this machine, also outside the brain.
`install.sh` links this file to `~/.claude/CLAUDE.md`.

## The brain is at `{{BRAIN}}`

Everything lives there: who I am, studies, work, money, projects, the Claude Code setup.

Working in a folder **under** the brain, it loads automatically. Working **outside** it
(for example in a code repo), read `{{BRAIN}}/CLAUDE.md` first, and
`{{BRAIN}}/00_me/PROFILE.md` if the answer depends on who I am. Don't ask me about
things that are written there.

If a repo has a `CLAUDE.local.md` pointing to a project folder in the brain, read that
project's `CLAUDE.md` and `status.md` before doing anything.

If I start something new loosely in `~/Downloads` or on the desktop, say that it belongs
in the brain and offer to run `/new-project`.
