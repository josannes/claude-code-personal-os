#!/bin/bash
# Smoke test. Installs into a throwaway HOME, so your real ~/.claude is never touched,
# then runs both hooks with fake input. Usage: tests/smoke.sh

set -uo pipefail

REPO="$(cd "$(dirname "$0")/.." && pwd -P)"
TMP=$(cd "$(mktemp -d)" && pwd -P)
trap 'rm -rf "$TMP"' EXIT

export HOME="$TMP/home"
export GIT_CONFIG_GLOBAL="$TMP/gitconfig"
mkdir -p "$HOME/.claude"
git config --global user.name "Test User"
git config --global user.email "test@example.com"

pass=0; fail=0
check() {
  if eval "$2"; then pass=$((pass+1)); echo "  ok    $1"
  else fail=$((fail+1)); echo "  FAIL  $1"; fi
}

# An existing settings.json that must survive the merge
echo '{"theme": "dark", "hooks": {"Stop": [{"hooks": [{"type": "command", "command": "echo mine"}]}]}}' > "$HOME/.claude/settings.json"

# A path with spaces, like iCloud Drive, and git history outside it
BRAIN="$TMP/home/Cloud Drive/my brain"
echo "Install"
out=$("$REPO/install.sh" "$BRAIN" --lang Norwegian --git-dir "$HOME/.brain.git" </dev/null 2>&1); rc=$?
check "install exits 0" '[ $rc -eq 0 ]' || echo "$out"
check "template copied" '[ -f "$BRAIN/CLAUDE.md" ] && [ -f "$BRAIN/00_me/PROFILE.md" ]'
check "gitignore copied" '[ -f "$BRAIN/.gitignore" ]'
check "language set" 'grep -q "Content language: \*\*Norwegian\*\*" "$BRAIN/CLAUDE.md"'
check "brain path filled in" '! grep -q "{{BRAIN}}" "$BRAIN/05_ai/claude/global-CLAUDE.md" && grep -q "$BRAIN" "$BRAIN/05_ai/claude/global-CLAUDE.md"'
check "git dir outside brain" '[ -f "$BRAIN/.git" ] && [ -d "$HOME/.brain.git" ]'
check "first commit" '[ "$(git -C "$BRAIN" rev-list --count HEAD 2>/dev/null)" = "1" ]'
check "LOG entry" 'grep -q "Brain created" "$BRAIN/LOG.md"'
check "global CLAUDE.md linked" '[ "$(readlink "$HOME/.claude/CLAUDE.md")" = "$BRAIN/05_ai/claude/global-CLAUDE.md" ]'
check "skill linked" '[ -f "$HOME/.claude/skills/new-project/SKILL.md" ]'
check "settings kept" 'python3 -c "import json,sys; s=json.load(open(sys.argv[1])); assert s[\"theme\"]==\"dark\"; assert any(h[\"command\"]==\"echo mine\" for g in s[\"hooks\"][\"Stop\"] for h in g[\"hooks\"])" "$HOME/.claude/settings.json"'
check "hooks registered" 'grep -q "session-start.sh" "$HOME/.claude/settings.json" && grep -q "auto-commit.sh" "$HOME/.claude/settings.json"'
check "settings backed up" 'ls "$HOME/.claude/" | grep -q "settings.json.backup-"'
check "refuses non-empty target" '! "$REPO/install.sh" "$BRAIN" --lang English </dev/null >/dev/null 2>&1'

# Run a hook the way settings.json does: the command string through a shell
hook() { local cmd; cmd=$(python3 -c "import json,sys; s=json.load(open(sys.argv[1])); print([h['command'] for g in s['hooks'][sys.argv[2]] for h in g['hooks'] if sys.argv[3] in h['command']][0])" "$HOME/.claude/settings.json" "$1" "$2"); echo "{\"cwd\": \"$3\"}" | sh -c "$cmd"; }

echo "session-start.sh"
echo "- $(date +%F) test line" >> "$BRAIN/inbox.md"
mkdir -p "$BRAIN/04_projects/demo" && echo "# demo" > "$BRAIN/04_projects/demo/CLAUDE.md"
out=$(hook SessionStart session-start "$BRAIN")
check "banner in root" 'echo "$out" | grep -q "^Brain loaded: root$"'
check "inbox counted and offered" 'echo "$out" | grep -q "Inbox: 1 lines" && echo "$out" | grep -q "Offer to sort it"'
check "TODOs counted" 'echo "$out" | grep -qE "^[0-9]+ TODOs left"'
out=$(hook SessionStart session-start "$BRAIN/04_projects/demo")
check "chain in subfolder" 'echo "$out" | grep -q "^Brain loaded: root + 04_projects + demo$"'
check "no inbox offer in subfolder" '! echo "$out" | grep -q "Offer to sort it"'
out=$(hook SessionStart session-start "$TMP")
check "silent outside brain" '[ -z "$out" ]'

echo "auto-commit.sh"
hook Stop auto-commit "$BRAIN/04_projects/demo"
check "commits changes" '[ "$(git -C "$BRAIN" rev-list --count HEAD)" = "2" ] && [ -z "$(git -C "$BRAIN" status --porcelain)" ]'
check "message names folder" 'git -C "$BRAIN" log -1 --format=%s | grep -q "04_projects/demo$"'
echo "change" >> "$BRAIN/inbox.md"
hook Stop auto-commit "$TMP"
check "does nothing outside brain" '[ "$(git -C "$BRAIN" rev-list --count HEAD)" = "2" ]'
BRAIN_AUTOCOMMIT=0 hook Stop auto-commit "$BRAIN"
check "can be turned off" '[ "$(git -C "$BRAIN" rev-list --count HEAD)" = "2" ]'
hook Stop auto-commit "$BRAIN"
check "commits from root" '[ "$(git -C "$BRAIN" rev-list --count HEAD)" = "3" ]'
check "sensitive folder ignored" 'echo x > "$BRAIN/00_me/documents/id.txt" && [ -z "$(git -C "$BRAIN" status --porcelain)" ]'

echo
echo "$pass passed, $fail failed"
[ "$fail" -eq 0 ]
