# dotfiles

macOS config for zsh, Neovim, Vim, tmux, git and kitty. Built around being
fast and small: shell starts in ~90ms, Vim in ~15ms, and nothing is installed
that isn't actually used.

## Install

```sh
git clone https://github.com/majuyi/dotfiles.git ~/dotfiles
cd ~/dotfiles && ./install.sh
```

`install.sh` symlinks everything into place. It's re-runnable, and it moves any
existing file aside as `<name>.backup-<timestamp>` instead of overwriting it.

## Layout

```
home/      -> $HOME              .zshrc .zprofile .vimrc .tmux.conf .gitconfig .fzf.zsh
config/    -> ~/.config          nvim/ kitty/kitty.conf
```

## What's here

**zsh** — no framework. nvm and pyenv are deliberately *not* sourced at startup;
the default node and pyenv shims go on `PATH` directly and the `nvm`/`pyenv`
commands load themselves on first use. That alone was ~550ms of the original
1000ms startup. `compinit` uses a cached dump and only rebuilds once a day.
Git branch and dirty state come from zsh's own `vcs_info`, not a prompt binary.

**nvim** — lazy.nvim. Telescope, treesitter, nvim-tree, undotree, lualine.
LSP via Neovim's native `vim.lsp.config`/`vim.lsp.enable` (not the deprecated
lspconfig framework), with servers enabled only when their binary exists, so a
missing one is silent rather than an error. moonfly loads at startup; the other
six themes are lazy and load on demand from `<leader>cs`.

**vim** — deliberately plugin-free, for quick edits and machines without nvim.
`:find` with `path=.,**` and `:grep` through ripgrep cover file-finding without
a fuzzy finder.

**tmux** — tpm, with yank/resurrect/continuum. Prefix is `` ` ``.

**git** — `push.autoSetupRemote`, `pull.rebase`, `rebase.autosquash`,
`merge.conflictstyle=zdiff3`, delta as pager, and short aliases
(`st co br cm amend lg last unstage`).

## Dependencies

```sh
brew install neovim vim tmux fzf ripgrep fd git-delta zoxide \
             zsh-syntax-highlighting zsh-autosuggestions gh jq
```

Language servers, installed outside nvm so they survive `nvm use`:

```sh
npm install -g --prefix ~/.local typescript@5 typescript-language-server pyright
```

`typescript` is pinned to the 5.x line on purpose — TypeScript 7 dropped
`lib/tsserver.js`, which typescript-language-server needs to start.

clangd comes with the Xcode command line tools. `tmux-256color` is used rather
than `screen-256color` because only the former's terminfo advertises italics.

## Not included

Runtime state — plugin installs, undo history, shada, caches. All regenerates.
