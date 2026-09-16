#!/bin/bash
# Disconnects a brain from Claude Code. Removes the links and hooks install.sh added to
# ~/.claude/, and restores the global CLAUDE.md you had before. Never deletes the brain.
#
# Usage: ./uninstall.sh [brain]
#   brain   the brain folder (default: read from the ~/.claude/CLAUDE.md link)

set -euo pipefail

die() { echo "error: $*" >&2; exit 1; }
if [ "${1:-}" = "-h" ] || [ "${1:-}" = "--help" ]; then
  sed -n '2,6p' "$0" | sed 's/^# \{0,1\}//'; exit 0
fi
command -v python3 >/dev/null || die "python3 is required"

CLAUDE_HOME="${CLAUDE_CONFIG_DIR:-$HOME/.claude}"
global="$CLAUDE_HOME/CLAUDE.md"
link_target=""
[ -L "$global" ] && link_target=$(readlink "$global")

if [ -n "${1:-}" ]; then
  case "$1" in "~") BRAIN="$HOME" ;; "~/"*) BRAIN="$HOME/${1#\~/}" ;; *) BRAIN="$1" ;; esac
  BRAIN=$(cd "$BRAIN" 2>/dev/null && pwd -P) || die "$1 does not exist"
else
  case "$link_target" in
    */05_ai/claude/global-CLAUDE.md) BRAIN="${link_target%/05_ai/claude/global-CLAUDE.md}" ;;
    *) die "could not find the brain from ~/.claude/CLAUDE.md, pass the brain folder" ;;
  esac
fi
SETUP="$BRAIN/05_ai/claude"

# 1. Global CLAUDE.md: remove our link, restore the newest backup
if [ "$link_target" = "$SETUP/global-CLAUDE.md" ]; then
  rm "$global"
  echo "Removed the ~/.claude/CLAUDE.md link"
  backup=$(ls -1 "$global".backup-* 2>/dev/null | sort | tail -1 || true)
  if [ -n "$backup" ]; then
    mv "$backup" "$global"
    echo "Restored your earlier ~/.claude/CLAUDE.md from $(basename "$backup")"
  fi
fi

# 2. Skills that link into this brain
for link in "$CLAUDE_HOME"/skills/*; do
  [ -L "$link" ] || continue
  case "$(readlink "$link")" in
    "$SETUP"/skills/*) rm "$link"; echo "Removed skill /$(basename "$link")" ;;
  esac
done

# 3. Hook entries that point into this brain. Everything else in settings.json stays.
if [ -f "$CLAUDE_HOME/settings.json" ]; then
  python3 - "$CLAUDE_HOME/settings.json" "$SETUP/hooks/" <<'PY'
import sys, json, pathlib
path, prefix = pathlib.Path(sys.argv[1]), sys.argv[2]
try:
    settings = json.loads(path.read_text() or "{}")
except json.JSONDecodeError:
    sys.exit(f"error: {path} is not valid JSON, hooks not removed")
hooks = settings.get("hooks", {})
removed = 0
for event in list(hooks):
    groups = []
    for group in hooks[event]:
        kept = [h for h in group.get("hooks", []) if not h.get("command", "").strip('"').startswith(prefix)]
        removed += len(group.get("hooks", [])) - len(kept)
        if kept:
            groups.append({**group, "hooks": kept})
    if groups:
        hooks[event] = groups
    else:
        del hooks[event]
if "hooks" in settings and not hooks:
    del settings["hooks"]
if removed:
    path.write_text(json.dumps(settings, indent=2) + "\n")
    print(f"Removed {removed} hooks from ~/.claude/settings.json")
PY
fi

cat <<EOF

Done. Claude Code is no longer connected to $BRAIN
The brain itself is untouched. Delete the folder yourself if you want it gone.
EOF
