#!/bin/bash
# Installs the brain template: copies brain/ to a folder of your choice, sets the content
# language, creates a git repository, and connects the brain to Claude Code in ~/.claude/.
#
# Usage: ./install.sh [target] [--lang <language>] [--git-dir <dir>]
#   target      where your brain goes (default: ~/brain)
#   --lang      language Claude writes and answers in (default: asks, or English)
#   --git-dir   keep git history outside the brain, recommended for iCloud or Dropbox

set -euo pipefail

SRC="$(cd "$(dirname "$0")" && pwd -P)/brain"
TARGET=""
LANG_CHOICE=""
GIT_DIR=""

die() { echo "error: $*" >&2; exit 1; }

while [ $# -gt 0 ]; do
  case "$1" in
    --lang) [ $# -ge 2 ] || die "--lang needs a value"; LANG_CHOICE="$2"; shift 2 ;;
    --git-dir) [ $# -ge 2 ] || die "--git-dir needs a value"; GIT_DIR="$2"; shift 2 ;;
    -h|--help) sed -n '2,9p' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
    -*) die "unknown option $1" ;;
    *) [ -z "$TARGET" ] || die "only one target folder"; TARGET="$1"; shift ;;
  esac
done

command -v git >/dev/null || die "git is required"
command -v python3 >/dev/null || die "python3 is required"
[ -d "$SRC" ] || die "brain/ template not found next to install.sh"

expand() { case "$1" in "~") echo "$HOME" ;; "~/"*) echo "$HOME/${1#\~/}" ;; *) echo "$1" ;; esac; }

TARGET=$(expand "${TARGET:-~/brain}")
if [ -e "$TARGET" ] && [ -n "$(ls -A "$TARGET" 2>/dev/null)" ]; then
  die "$TARGET already exists and is not empty"
fi

if [ -z "$LANG_CHOICE" ]; then
  if [ -t 0 ]; then
    read -r -p "Which language should Claude write and answer in? [English] " LANG_CHOICE
  fi
  LANG_CHOICE="${LANG_CHOICE:-English}"
fi

# 1. Copy the template
mkdir -p "$TARGET"
TARGET=$(cd "$TARGET" && pwd -P)
cp -R "$SRC"/. "$TARGET"/
mkdir -p "$TARGET/00_me/documents" "$TARGET/99_archive"
chmod +x "$TARGET"/05_ai/claude/hooks/*.sh
echo "Copied the template to $TARGET"

# 2. Fill in the brain path and the language
python3 - "$TARGET" "$LANG_CHOICE" <<'PY'
import sys, pathlib
root, lang = pathlib.Path(sys.argv[1]), sys.argv[2]
g = root / "05_ai/claude/global-CLAUDE.md"
g.write_text(g.read_text().replace("{{BRAIN}}", str(root)))
c = root / "CLAUDE.md"
c.write_text(c.read_text().replace("- Content language: **English**.", f"- Content language: **{lang}**."))
PY
echo "Content language: $LANG_CHOICE"

# 3. Git
if [ -n "$GIT_DIR" ]; then
  GIT_DIR=$(expand "$GIT_DIR")
  [ -e "$GIT_DIR" ] && die "$GIT_DIR already exists"
  git init -q -b main --separate-git-dir "$GIT_DIR" "$TARGET"
  echo "Git history in $GIT_DIR"
else
  git init -q -b main "$TARGET"
fi
today=$(date +%Y-%m-%d)
python3 - "$TARGET/LOG.md" "$today" <<'PY'
import sys, pathlib
p, today = pathlib.Path(sys.argv[1]), sys.argv[2]
p.write_text(p.read_text().rstrip("\n") + f"\n\n## {today}: Brain created\nInstalled from the claude-code-personal-os template.\n")
PY
git -C "$TARGET" add -A
if git -C "$TARGET" commit -q -m "Create brain from template" 2>/dev/null; then
  echo "First commit made"
else
  echo "note: no commit made. Set git user.name and user.email, or auto-commit will not work either."
fi

# 4. Connect to Claude Code
CLAUDE_HOME="$HOME/.claude"
stamp=$(date +%Y%m%d-%H%M%S)
mkdir -p "$CLAUDE_HOME/skills"

global="$CLAUDE_HOME/CLAUDE.md"
if [ -e "$global" ] || [ -L "$global" ]; then
  mv "$global" "$global.backup-$stamp"
  echo "Moved your existing ~/.claude/CLAUDE.md to CLAUDE.md.backup-$stamp"
fi
ln -s "$TARGET/05_ai/claude/global-CLAUDE.md" "$global"
echo "Linked ~/.claude/CLAUDE.md"

for skill in "$TARGET"/05_ai/claude/skills/*/; do
  name=$(basename "$skill")
  link="$CLAUDE_HOME/skills/$name"
  if [ -e "$link" ] || [ -L "$link" ]; then
    echo "note: skipped skill $name, ~/.claude/skills/$name already exists"
  else
    ln -s "${skill%/}" "$link"
    echo "Linked skill /$name"
  fi
done

python3 - "$CLAUDE_HOME/settings.json" "$TARGET/05_ai/claude/hooks" "$stamp" <<'PY'
import sys, json, pathlib, shutil
path, hooks, stamp = pathlib.Path(sys.argv[1]), sys.argv[2], sys.argv[3]
settings = {}
if path.exists():
    text = path.read_text().strip()
    try:
        settings = json.loads(text) if text else {}
    except json.JSONDecodeError:
        sys.exit(f"error: {path} is not valid JSON, hooks not added")
    shutil.copy2(path, f"{path}.backup-{stamp}")
wanted = {
    "SessionStart": ("session-start.sh", 20),
    "Stop": ("auto-commit.sh", 30),
}
all_hooks = settings.setdefault("hooks", {})
for event, (script, timeout) in wanted.items():
    command = f'"{hooks}/{script}"'
    groups = all_hooks.setdefault(event, [])
    if any(h.get("command") == command for g in groups for h in g.get("hooks", [])):
        continue
    groups.append({"hooks": [{"type": "command", "command": command, "timeout": timeout}]})
path.write_text(json.dumps(settings, indent=2) + "\n")
print("Added hooks to ~/.claude/settings.json")
PY

cat <<EOF

Done. Your brain is at $TARGET

Next:
  1. Fill in the TODOs in $TARGET/CLAUDE.md and $TARGET/00_me/PROFILE.md
  2. Start a Claude Code session in $TARGET and ask: what do you know about me?
  3. Run /new-project for your first course or project

Backup: create a PRIVATE repository and add it as origin. Auto-commit pushes once it exists.
  git -C "$TARGET" remote add origin <url>
EOF
