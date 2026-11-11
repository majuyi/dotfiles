#!/usr/bin/env bash
# tmux-resurrect post-save-layout hook (set in tmux.conf). Arg: the save file.
# Drops hatch's claude-* sessions from the save: resurrect cannot restart
# Claude in them, so restoring them only leaves empty shells that hatch then
# attaches to instead of starting Claude (see hatch-launch.sh).
set -uo pipefail
f="$1"
[ -f "$f" ] || exit 0
tmp="$f.tmp.$$"
# pane/window lines for a claude-* session go; so does the state line (which
# session the client was on) when it names one, since that session won't exist.
awk -F'\t' '
  ($1 == "pane" || $1 == "window") && $2 ~ /^claude-/ { next }
  $1 == "state" && ($2 ~ /^claude-/ || $3 ~ /^claude-/) { next }
  { print }' "$f" > "$tmp" && mv "$tmp" "$f"
