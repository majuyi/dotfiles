# ~/.zshrc — interactive zsh
#
# This started life as a Kali Linux zshrc. Every /usr/share and /etc branch in
# it tested a path that does not exist on macOS, so those blocks were dead —
# they have been removed or repointed at Homebrew.

# ---------------------------------------------------------------------------
# PATH
# ---------------------------------------------------------------------------
# -U keeps these arrays deduplicated, which is what stops the same entry being
# prepended once by .zprofile and again here.
typeset -U path PATH fpath

# .zprofile already runs `brew shellenv`, so /opt/homebrew/bin is present.
path=("$HOME/.local/bin" "$HOME/.antigravity/antigravity/bin" $path)

# ---------------------------------------------------------------------------
# Shell options
# ---------------------------------------------------------------------------
setopt autocd              # change directory just by typing its name
setopt interactivecomments # allow comments in interactive mode
setopt magicequalsubst     # filename expansion for anything=expression
setopt nonomatch           # no error when a glob matches nothing
setopt notify              # report background job status immediately
setopt numericglobsort     # sort filenames numerically when it makes sense
setopt promptsubst         # command substitution in the prompt

WORDCHARS=${WORDCHARS//\/} # don't treat / as part of a word

# ---------------------------------------------------------------------------
# Key bindings
# ---------------------------------------------------------------------------
bindkey -e                                        # emacs key bindings
bindkey ' ' magic-space                           # history expansion on space
bindkey '^U' backward-kill-line                   # ctrl + U
bindkey '^[[3;5~' kill-word                       # ctrl + del
bindkey '^[[3~' delete-char                       # delete
bindkey '^[[1;5C' forward-word                    # ctrl + ->
bindkey '^[[1;5D' backward-word                   # ctrl + <-
bindkey '^[[5~' beginning-of-buffer-or-history    # page up
bindkey '^[[6~' end-of-buffer-or-history          # page down
bindkey '^[[H' beginning-of-line                  # home
bindkey '^[[F' end-of-line                        # end
bindkey '^[[Z' undo                               # shift + tab

# ---------------------------------------------------------------------------
# Completion
# ---------------------------------------------------------------------------
# compinit rebuilds its dump and runs a security audit on every start, which is
# expensive. Do the full run at most once a day; otherwise trust the cache (-C).
autoload -Uz compinit
() {
    setopt local_options extended_glob
    local zcd="$HOME/.cache/zcompdump"
    [[ -d "$HOME/.cache" ]] || mkdir -p "$HOME/.cache"
    if [[ -n ${zcd}(#qN.mh+24) ]]; then
        compinit -d "$zcd"      # dump older than 24h — regenerate
    else
        compinit -C -d "$zcd"   # fresh — skip the audit and the rebuild
    fi
}

zstyle ':completion:*:*:*:*:*' menu select
zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' rehash true
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

# ---------------------------------------------------------------------------
# History
# ---------------------------------------------------------------------------
# SAVEHIST is the one that controls the *file*. It was never set, so it sat at
# the default of 1000 and silently truncated everything beyond that, no matter
# how large HISTSIZE was. (HISTFILESIZE and HISTTIMEFORMAT are bash variables
# and did nothing here at all.)
HISTFILE="$HOME/.zsh_history"
HISTSIZE=1000000    # events kept in memory for this session
SAVEHIST=1000000    # events written to HISTFILE

setopt EXTENDED_HISTORY          # record timestamp and duration
setopt INC_APPEND_HISTORY        # write as you go, not just at exit
setopt SHARE_HISTORY             # share between running sessions
setopt HIST_EXPIRE_DUPS_FIRST    # drop duplicates first when trimming
setopt HIST_IGNORE_DUPS          # don't record an immediate repeat
setopt HIST_IGNORE_ALL_DUPS      # keep only the newest copy of a command
setopt HIST_FIND_NO_DUPS         # don't show duplicates when searching
setopt HIST_IGNORE_SPACE         # skip commands typed with a leading space
setopt HIST_VERIFY               # expand ! but let you confirm before running
setopt HIST_REDUCE_BLANKS        # tidy up whitespace
setopt APPEND_HISTORY
setopt HIST_SAVE_NO_DUPS         # no duplicates in the file
setopt HIST_BEEP                 # beep when a history search fails

HISTORY_IGNORE="(ls|cd|pwd|exit|clear|history|fg)"

alias history="history 0"        # show the whole history, not the last 16

# ---------------------------------------------------------------------------
# Prompt
# ---------------------------------------------------------------------------
# The old file built a prompt here and then overwrote it at the bottom with a
# hardcoded `export PS1`, which made the toggle below dead on arrival. The
# hardcoded version is now the twoline case, so ^P actually works — and PS1 is
# no longer exported, which it never should have been.
TIMEFMT=$'\nreal\t%E\nuser\t%U\nsys\t%S\ncpu\t%P'

# Git branch and working-tree state in the prompt, via zsh's own vcs_info —
# no external prompt binary. `*` means unstaged changes, `+` means staged.
autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git

# check-for-changes is what produces `*`/`+`, and it costs a diff against the
# index on every prompt. Invisible in small repos, a real stall in large ones.
# `vcs-dirty off` drops it for the session (branch name stays); `vcs-dirty on`
# restores it. To kill it permanently for known-huge trees, uncomment and edit:
# zstyle ':vcs_info:*' disable-patterns "$HOME/some/monorepo(|/*)"
VCS_DIRTY_CHECK=${VCS_DIRTY_CHECK:-true}
vcs-dirty() {
    case "$1" in
        on|true)   VCS_DIRTY_CHECK=true  ;;
        off|false) VCS_DIRTY_CHECK=false ;;
        "")        print -r -- "vcs-dirty: $VCS_DIRTY_CHECK"; return 0 ;;
        *)         print -ru2 -- "usage: vcs-dirty [on|off]"; return 1 ;;
    esac
    zstyle ':vcs_info:git:*' check-for-changes "$VCS_DIRTY_CHECK"
}
zstyle ':vcs_info:git:*' check-for-changes "$VCS_DIRTY_CHECK"

zstyle ':vcs_info:git:*' unstagedstr '*'
zstyle ':vcs_info:git:*' stagedstr '+'
# The `─(...)` wrapper and colour live here, not in PROMPT. Wrapping them in a
# ${vcs_info_msg_0_:+...} block instead silently ate the branch name: zsh pairs
# the `{` of a `%F{...}` inside the :+ body with the `}` of the nested
# ${vcs_info_msg_0_}, truncating the colour escape and leaking a stray `}`.
# formats only emit when inside a repo, so the conditional was never needed.
zstyle ':vcs_info:git:*' formats       '─(%F{yellow}%b%u%c%f)'
zstyle ':vcs_info:git:*' actionformats '─(%F{yellow}%b|%a%u%c%f)'

configure_prompt() {
    case "$PROMPT_ALTERNATIVE" in
        twoline)
            PROMPT=$'%F{%(#.blue.green)}┌──${VIRTUAL_ENV:+($(basename $VIRTUAL_ENV))─}(%B%F{%(#.red.blue)}Ave Majuyi%b%F{%(#.blue.green)})-[%B%F{reset}%(6~.%-1~/…/%4~.%5~)%b%F{%(#.blue.green)}]${vcs_info_msg_0_}%F{%(#.blue.green)}\n└─%(?..%B%F{red}[%?]%b%F{%(#.blue.green)} )%B%(#.%F{red}#.%F{blue}$)%b%F{reset} '
            RPROMPT=
            ;;
        oneline)
            PROMPT=$'${VIRTUAL_ENV:+($(basename $VIRTUAL_ENV))}%B%F{%(#.red.blue)}%n@%m%b%F{reset}:%B%F{%(#.blue.green)}%~%b%F{reset}%(?.. %B%F{red}[%?]%b%F{reset})%(#.#.$) '
            RPROMPT=
            ;;
    esac
}

PROMPT_ALTERNATIVE=twoline
NEWLINE_BEFORE_PROMPT=yes
VIRTUAL_ENV_DISABLE_PROMPT=1
configure_prompt

toggle_oneline_prompt() {
    if [ "$PROMPT_ALTERNATIVE" = oneline ]; then
        PROMPT_ALTERNATIVE=twoline
    else
        PROMPT_ALTERNATIVE=oneline
    fi
    configure_prompt
    zle reset-prompt
}
zle -N toggle_oneline_prompt
# Alt-P, not ^P: in the emacs keymap ^P is up-line-or-history, the partner to
# ^N, and shadowing it costs a core navigation key for a rarely-used toggle.
bindkey '^[p' toggle_oneline_prompt

# A third prompt: starship, in the same Osaka palette as tmux, kitty and nvim
# (~/.config/starship.toml). It gives two things the zsh prompt above does not
# — how long the last command ran, and a right-aligned clock.
#
# Everything above stays intact and is one env var away: `export PROMPT_STYLE=zsh`
# then `exec zsh`. It is also the automatic fallback if the binary ever goes
# missing, so a broken install cannot leave you without a prompt.
#
# Note that Alt-P is inert while starship is active: starship re-sets PROMPT on
# every precmd, so the twoline/oneline toggle has nothing to hold on to.
PROMPT_STYLE=${PROMPT_STYLE:-starship}
if [ "$PROMPT_STYLE" = starship ] && command -v starship >/dev/null 2>&1; then
    eval "$(starship init zsh)"
    _STARSHIP_ACTIVE=1
fi

# Picks the one powerline cap starship's prompt needs between its last coloured
# block and whatever follows — see the env_var modules in starship.toml. The
# path is blue, the git block yellow; the next block is red when the last
# command failed, the grey tail otherwise. Pure zsh: walks up from $PWD for a
# .git (a directory, or a file in worktrees and submodules) without starting a
# process, and reads the exit code prompt_starship_precmd saved, which runs
# just before this.
_starship_caps() {
    local last=BLUE next=GREY d=$PWD
    while :; do
        if [[ -e $d/.git ]]; then
            last=YEL
            break
        fi
        [[ $d == / || -z $d ]] && break
        d=${d:h}
    done
    # Red if anything in the pipeline failed, matching the status block.
    [[ -n $STARSHIP_CMD_STATUS && ${STARSHIP_PIPE_STATUS[*]:-$STARSHIP_CMD_STATUS} == *[1-9]* ]] && next=RED
    unset STARSHIP_CAP_BLUE_GREY STARSHIP_CAP_BLUE_RED STARSHIP_CAP_YEL_GREY STARSHIP_CAP_YEL_RED
    export "STARSHIP_CAP_${last}_${next}=1"
}

case "$TERM" in
    xterm*|rxvt*|kitty*|alacritty|screen*|tmux*)
        TERM_TITLE=$'\e]0;${VIRTUAL_ENV:+($(basename $VIRTUAL_ENV))}%n@%m: %~\a'
        ;;
esac

# Registered on the precmd hook array rather than defined as a bare `precmd`
# function: the function is a single global slot, so anything sourced later
# that defines its own (iTerm2 shell integration is the usual culprit) would
# silently replace this one and stop the git segment and title from updating.
autoload -Uz add-zsh-hook

_zshrc_precmd() {
    # vcs_info only feeds the zsh prompt. With starship drawing git itself it
    # was a second full git pass before every prompt, for output nothing read.
    if [ -n "$_STARSHIP_ACTIVE" ]; then
        _starship_caps
    else
        vcs_info                  # refresh ${vcs_info_msg_0_} for the prompt
    fi
    print -Pnr -- "$TERM_TITLE"
    # blank line between commands, but not above the first prompt
    if [ "$NEWLINE_BEFORE_PROMPT" = yes ]; then
        if [ -z "$_NEW_LINE_BEFORE_PROMPT" ]; then
            _NEW_LINE_BEFORE_PROMPT=1
        else
            print ""
        fi
    fi
}
add-zsh-hook precmd _zshrc_precmd

# ---------------------------------------------------------------------------
# Colour and aliases
# ---------------------------------------------------------------------------
# The old dircolors block was guarded on /usr/bin/dircolors, which macOS does
# not ship — so none of this ran. CLICOLOR/LSCOLORS is the BSD equivalent.
export CLICOLOR=1

alias ls='ls -G'
alias la='ls -A'
alias l='ls -CF'

# Only ll gets eza, which is how craftzdog splits it — and the reason is not
# taste. eza's -t is --time <FIELD> and takes a value, so `ls -latr` becomes
# "invalid value 'r' for '--time <FIELD>'" the moment ls is eza. Leaving ls as
# BSD ls keeps every flag combination you already have in your fingers.
#
# --icons=auto rather than his bare --icons: the flag's value is optional, so
# `ll somedir` parses the directory as the value and errors. auto also drops
# the icons when output is piped, so `ll | wc -l` stays honest.
#
# Guarded like his `if type -q eza`, so a machine without eza still gets a
# working ll rather than "command not found".
if command -v eza >/dev/null 2>&1; then
    alias ll='eza -l -g --icons=auto --group-directories-first'
else
    alias ll='ls -lG'
fi

alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# Colourised man pages
export LESS_TERMCAP_mb=$'\E[1;31m'
export LESS_TERMCAP_md=$'\E[1;36m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;33m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_us=$'\E[1;32m'
export LESS_TERMCAP_ue=$'\E[0m'

# ---------------------------------------------------------------------------
# Node / nvm
# ---------------------------------------------------------------------------
# Sourcing nvm.sh cost ~445ms — about half of total shell startup — because it
# runs nvm_auto to select the default version. Instead, put that version's bin
# on PATH directly. These are real binaries, so anything with a
# `#!/usr/bin/env node` shebang (the LSP servers in ~/.local/bin, for one)
# keeps working without nvm ever being loaded.
export NVM_DIR="$HOME/.nvm"
if [[ -r "$NVM_DIR/alias/default" ]]; then
    () {
        setopt local_options null_glob numeric_glob_sort
        local v d
        v=$(<"$NVM_DIR/alias/default")
        d=("$NVM_DIR"/versions/node/v${v}*(/))
        (( $#d )) && path=("${d[-1]}/bin" $path)
    }
fi

# nvm itself only loads when you actually call it. Its bash_completion is
# loaded here too rather than at startup: it ran a bare `compinit` against a
# *second* dump file, which is why compinit was running twice.
nvm() {
    unfunction nvm
    source "$NVM_DIR/nvm.sh"
    [[ -s "$NVM_DIR/bash_completion" ]] && source "$NVM_DIR/bash_completion"
    nvm "$@"
}

# ---------------------------------------------------------------------------
# Python / pyenv
# ---------------------------------------------------------------------------
# `pyenv init --path` and `pyenv init -` emit identical PATH code, so the two
# evals were doing the same work twice — and each spawned a `bash --norc`
# subprocess to dedupe PATH. All they ultimately do is put the shims first,
# which is one line. The rest loads on first use.
# ($PYENV_ROOT/bin was also on PATH but does not exist; pyenv comes from brew.)
export PYENV_ROOT="$HOME/.pyenv"
export PYENV_SHELL=zsh
path=("$PYENV_ROOT/shims" $path)

pyenv() {
    unfunction pyenv
    eval "$(command pyenv init - zsh)"
    pyenv "$@"
}

# ---------------------------------------------------------------------------
# fzf
# ---------------------------------------------------------------------------
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# ---------------------------------------------------------------------------
# zoxide
# ---------------------------------------------------------------------------
# `z <partial>` jumps to a directory you've been in before, ranked by how often
# and how recently. Has to init eagerly — it hooks directory changes to learn.
# `cd` is untouched, so nothing you already do changes.
if command -v zoxide >/dev/null 2>&1; then
    eval "$(zoxide init zsh)"
fi

# ---------------------------------------------------------------------------
# Plugins — these must come last
# ---------------------------------------------------------------------------
if [ -f /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
    . /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
    ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#999'
fi

# zsh-syntax-highlighting must be sourced at the very end of the file.
if [ -f /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
    . /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
    ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern)
    ZSH_HIGHLIGHT_STYLES[default]=none
    ZSH_HIGHLIGHT_STYLES[unknown-token]=underline
    ZSH_HIGHLIGHT_STYLES[reserved-word]=fg=cyan,bold
    ZSH_HIGHLIGHT_STYLES[suffix-alias]=fg=green,underline
    ZSH_HIGHLIGHT_STYLES[global-alias]=fg=green,bold
    ZSH_HIGHLIGHT_STYLES[precommand]=fg=green,underline
    ZSH_HIGHLIGHT_STYLES[commandseparator]=fg=blue,bold
    ZSH_HIGHLIGHT_STYLES[autodirectory]=fg=green,underline
    ZSH_HIGHLIGHT_STYLES[path]=bold
    ZSH_HIGHLIGHT_STYLES[path_pathseparator]=
    ZSH_HIGHLIGHT_STYLES[path_prefix_pathseparator]=
    ZSH_HIGHLIGHT_STYLES[globbing]=fg=blue,bold
    ZSH_HIGHLIGHT_STYLES[history-expansion]=fg=blue,bold
    ZSH_HIGHLIGHT_STYLES[command-substitution]=none
    ZSH_HIGHLIGHT_STYLES[command-substitution-delimiter]=fg=magenta,bold
    ZSH_HIGHLIGHT_STYLES[process-substitution]=none
    ZSH_HIGHLIGHT_STYLES[process-substitution-delimiter]=fg=magenta,bold
    ZSH_HIGHLIGHT_STYLES[single-hyphen-option]=fg=green
    ZSH_HIGHLIGHT_STYLES[double-hyphen-option]=fg=green
    ZSH_HIGHLIGHT_STYLES[back-quoted-argument]=none
    ZSH_HIGHLIGHT_STYLES[back-quoted-argument-delimiter]=fg=blue,bold
    ZSH_HIGHLIGHT_STYLES[single-quoted-argument]=fg=yellow
    ZSH_HIGHLIGHT_STYLES[double-quoted-argument]=fg=yellow
    ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument]=fg=yellow
    ZSH_HIGHLIGHT_STYLES[rc-quote]=fg=magenta
    ZSH_HIGHLIGHT_STYLES[dollar-double-quoted-argument]=fg=magenta,bold
    ZSH_HIGHLIGHT_STYLES[back-double-quoted-argument]=fg=magenta,bold
    ZSH_HIGHLIGHT_STYLES[back-dollar-quoted-argument]=fg=magenta,bold
    ZSH_HIGHLIGHT_STYLES[assign]=none
    ZSH_HIGHLIGHT_STYLES[redirection]=fg=blue,bold
    ZSH_HIGHLIGHT_STYLES[comment]=fg=black,bold
    ZSH_HIGHLIGHT_STYLES[named-fd]=none
    ZSH_HIGHLIGHT_STYLES[numeric-fd]=none
    ZSH_HIGHLIGHT_STYLES[arg0]=fg=cyan
    ZSH_HIGHLIGHT_STYLES[bracket-error]=fg=red,bold
    ZSH_HIGHLIGHT_STYLES[bracket-level-1]=fg=blue,bold
    ZSH_HIGHLIGHT_STYLES[bracket-level-2]=fg=green,bold
    ZSH_HIGHLIGHT_STYLES[bracket-level-3]=fg=magenta,bold
    ZSH_HIGHLIGHT_STYLES[bracket-level-4]=fg=yellow,bold
    ZSH_HIGHLIGHT_STYLES[bracket-level-5]=fg=cyan,bold
    ZSH_HIGHLIGHT_STYLES[cursor-matchingbracket]=standout
fi
