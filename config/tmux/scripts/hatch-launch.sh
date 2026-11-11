#!/usr/bin/env bash
# ` + i launcher: wraps tmux-claude-hatch's launch.sh (bound in tmux.conf).
# Args: <dir> <origin-window-id>, as hatch's own binding passes them.
#
# Why it exists: tmux-resurrect saves hatch's claude-<hash> sessions with the
# rest, but cannot restart Claude in them, so ` + Ctrl-R brought them back as a
# bare shell. hatch then saw "session exists" and attached to that shell
# instead of starting Claude. A pane hatch created remembers its start command
# (claude ...); a pane resurrect recreated has none. If no pane in the session
# started Claude, it is a leftover: kill it, and let hatch start a fresh one.
# (resurrect-drop-hatch.sh stops new saves carrying them; this handles the
# old saves.)
set -uo pipefail
H="$HOME/.tmux/plugins/tmux-claude-hatch/scripts"

# hatch is a plugin, so this path is its internals: say so if an update moves it,
# rather than ` + i silently doing nothing.
if [ ! -x "$H/launch.sh" ] || [ ! -r "$H/helpers.sh" ]; then
  tmux display-message "hatch-launch: $H/launch.sh not found (hatch updated?)"
  exit 0
fi

. "$H/helpers.sh"
prefix="$(get_tmux_option @claude_session_prefix 'claude-')"
session="${prefix}$(session_hash "${1:-$PWD}")"

if tmux has-session -t "=$session" 2>/dev/null &&
   ! tmux list-panes -s -t "=$session" -F '#{pane_start_command}' | grep -q claude; then
  tmux kill-session -t "=$session"
fi

exec "$H/launch.sh" "$@"
