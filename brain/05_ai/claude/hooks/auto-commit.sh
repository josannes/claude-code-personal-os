#!/bin/bash
# Stop hook. Runs every time Claude finishes a response. Commits everything that changed
# in the brain, and pushes in the background if a remote named origin exists. Silent.
# Does nothing outside the brain. Turn off with BRAIN_AUTOCOMMIT=0.

[ "${BRAIN_AUTOCOMMIT:-1}" = "0" ] && exit 0

ROOT=$(cd "$(dirname "$0")/../../.." 2>/dev/null && pwd -P) || exit 0
CWD=$(python3 -c 'import sys,json; print(json.load(sys.stdin).get("cwd",""))' 2>/dev/null)
[ -z "$CWD" ] && CWD="$PWD"
CWD=$(cd "$CWD" 2>/dev/null && pwd -P) || exit 0
case "$CWD" in "$ROOT"|"$ROOT"/*) ;; *) exit 0 ;; esac

cd "$ROOT" || exit 0
# Only commit if the brain itself is the repository, never a parent repo
top=$(git rev-parse --show-toplevel 2>/dev/null) || exit 0
[ "$(cd "$top" && pwd -P)" = "$ROOT" ] || exit 0
[ -z "$(git status --porcelain 2>/dev/null)" ] && exit 0

rel="${CWD#"$ROOT"}"; rel="${rel#/}"; [ -z "$rel" ] && rel="root"
git add -A >/dev/null 2>&1
git commit -q -m "auto: $(date '+%Y-%m-%d %H:%M') $rel" >/dev/null 2>&1
if git remote get-url origin >/dev/null 2>&1; then
  ( git push -q origin HEAD >/dev/null 2>&1 & )
fi
exit 0
