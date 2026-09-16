#!/bin/bash
# SessionStart hook. Writes a short banner to Claude's context when a session starts
# inside the brain. Does nothing outside it. Only ages, counts and upcoming deadlines.

ROOT=$(cd "$(dirname "$0")/../../.." 2>/dev/null && pwd -P) || exit 0
CWD=$(python3 -c 'import sys,json; print(json.load(sys.stdin).get("cwd",""))' 2>/dev/null)
[ -z "$CWD" ] && CWD="$PWD"
CWD=$(cd "$CWD" 2>/dev/null && pwd -P) || exit 0
case "$CWD" in "$ROOT"|"$ROOT"/*) ;; *) exit 0 ;; esac

# Which CLAUDE.md files are in the chain from the root down to cwd
chain=""
[ -f "$ROOT/CLAUDE.md" ] && chain="root"
rel="${CWD#"$ROOT"}"
dir="$ROOT"
IFS='/' read -ra parts <<< "${rel#/}"
for p in "${parts[@]}"; do
  [ -z "$p" ] && continue
  dir="$dir/$p"
  [ -f "$dir/CLAUDE.md" ] && chain="$chain + $p"
done

# Modification time, GNU stat first, then BSD/macOS
mtime() { stat -c %Y "$1" 2>/dev/null || stat -f %m "$1" 2>/dev/null; }

now=$(date +%s)
pm=$(mtime "$ROOT/00_me/PROFILE.md"); pm=${pm:-$now}
pdays=$(( (now - pm) / 86400 ))
logdate=$(grep -m1 -oE '^## [0-9]{4}-[0-9]{2}-[0-9]{2}' "$ROOT/LOG.md" 2>/dev/null | cut -c4-)
inbox=$(grep -c '^- ' "$ROOT/inbox.md" 2>/dev/null); inbox=${inbox:-0}
unc=$(git -C "$ROOT" status --porcelain 2>/dev/null | wc -l | tr -d ' ')
todos=$(grep -c 'TODO' "$ROOT/CLAUDE.md" "$ROOT/00_me/PROFILE.md" 2>/dev/null | awk -F: '{s+=$2} END {print s+0}')

# Deadlines in the next 14 days, from every deadlines.md in the brain.
# Health, archive, templates and school material are never scanned.
deadlines=$(python3 - "$ROOT" <<'PY2'
import os, re, sys, datetime
root = sys.argv[1]
skip = {"06_health", "99_archive", "_templates", "_source", "_raw", "node_modules"}
line_re = re.compile(r"^- (?:\[ \] )?(\d{4}-\d{2}-\d{2}):?\s*(.+)$")
today = datetime.date.today()
found = []
for dirpath, dirnames, filenames in os.walk(root):
    dirnames[:] = [d for d in dirnames if d not in skip and not d.startswith(".")]
    if dirpath[len(root):].count(os.sep) > 4:
        dirnames[:] = []
    if "deadlines.md" not in filenames:
        continue
    where = os.path.relpath(dirpath, root)
    with open(os.path.join(dirpath, "deadlines.md"), encoding="utf-8", errors="ignore") as f:
        for line in f:
            m = line_re.match(line.strip())
            if not m:
                continue
            try:
                d = datetime.date.fromisoformat(m.group(1))
            except ValueError:
                continue
            days = (d - today).days
            if 0 <= days <= 14:
                found.append((d, days, m.group(2), "" if where == "." else f" [{where}]"))
for d, days, text, where in sorted(found)[:10]:
    when = "today" if days == 0 else "tomorrow" if days == 1 else f"in {days} days"
    print(f"  {d} ({when}): {text}{where}")
PY2
)

# iCloud placeholders: files evicted from the local disk that Claude cannot read
icloud=$(find "$CWD" -maxdepth 6 -name '*.icloud' 2>/dev/null | head -100 | wc -l | tr -d ' ')

echo "Brain loaded: $chain"
echo "PROFILE.md last changed $pdays days ago. Last LOG entry: ${logdate:-none}. Inbox: $inbox lines. Uncommitted: $unc files."
if [ "$CWD" = "$ROOT" ] && [ "$inbox" != "0" ]; then
  echo "The inbox has content. Offer to sort it."
fi
if [ "$todos" != "0" ]; then
  echo "$todos TODOs left in the root CLAUDE.md and PROFILE.md. If the user's message answers one, fill it in."
fi
if [ -n "$deadlines" ]; then
  echo "Deadlines in the next 14 days:"
  echo "$deadlines"
fi
if [ "$icloud" != "0" ]; then
  echo "WARNING: $icloud files under this folder are only in iCloud and cannot be read. Ask the user to set the folder to Keep Downloaded."
fi
exit 0
