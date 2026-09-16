#!/usr/bin/env bash
# Symlink the tracked configs into place.
#
# Safe to re-run. Anything already pointing at this repo is left alone; any
# real file in the way is moved to <name>.backup-<timestamp> rather than
# overwritten, so nothing is ever lost silently.

set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
STAMP="$(date +%Y%m%d%H%M%S)"

link() {
    local src="$1" dest="$2"

    if [ ! -e "$src" ]; then
        printf '  skip    %s (not in repo)\n' "$dest"
        return
    fi

    # Already linked where we want it: nothing to do.
    if [ -L "$dest" ] && [ "$(readlink "$dest")" = "$src" ]; then
        printf '  ok      %s\n' "${dest/#$HOME/\~}"
        return
    fi

    mkdir -p "$(dirname "$dest")"

    # Something real is in the way — keep it.
    if [ -e "$dest" ] || [ -L "$dest" ]; then
        mv "$dest" "$dest.backup-$STAMP"
        printf '  backup  %s -> %s\n' "${dest/#$HOME/\~}" "$(basename "$dest").backup-$STAMP"
    fi

    ln -s "$src" "$dest"
    printf '  link    %s\n' "${dest/#$HOME/\~}"
}

echo "Linking dotfiles from $DOTFILES"

# $HOME-level files
for f in "$DOTFILES"/home/.*; do
    name="$(basename "$f")"
    [ "$name" = "." ] || [ "$name" = ".." ] && continue
    link "$f" "$HOME/$name"
done

# ~/.config — nvim is linked as a whole directory, kitty per-file so that
# anything else you keep in ~/.config/kitty stays untouched.
link "$DOTFILES/config/nvim" "$CONFIG_HOME/nvim"
link "$DOTFILES/config/kitty/kitty.conf" "$CONFIG_HOME/kitty/kitty.conf"
link "$DOTFILES/config/kitty/solarized-osaka-dark.conf" "$CONFIG_HOME/kitty/solarized-osaka-dark.conf"

echo
echo "Done. Open a new shell to pick up the zsh config."
