# ==============================================================================
# Zsh Configuration - Fast, Distraction-Free, Vi-Mode & Kanagawa Theme
# ==============================================================================

# --- Environment & PATH ---
export PATH="/opt/nvim-linux-x86_64/bin:/usr/local/bin:$HOME/.local/bin:$PATH"
export GOPATH="$HOME/go"
export PATH="$PATH:$GOPATH/bin"
export EDITOR="nvim"
export VISUAL="nvim"

# --- History Configuration ---
HISTFILE="${ZDOTDIR:-$HOME/.config/zsh}/.zsh_history"
HISTSIZE=50000
SAVEHIST=50000
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS
setopt HIST_SAVE_NO_DUPS
setopt HIST_VERIFY

# --- Fast Completion System ---
autoload -Uz compinit
# Cache compinit for blazing-fast startup time (<10ms)
if [ -n "$HOME/.zcompdump(#qN.mh+24)" ]; then
  compinit -i
else
  compinit -C -i
fi

zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

# --- Vi Mode Configuration ---
bindkey -v
export KEYTIMEOUT=15 # 150ms timeout for multi-key mappings

# Map 'jk' to Escape (exit insert mode)
bindkey -M viins 'jk' vi-cmd-mode

# --- Insert Mode Movement in Vi Mode ---
# Character movement (Ctrl-h/l, Ctrl-b/f, Arrow keys)
bindkey -M viins '^h' backward-char
bindkey -M viins '^l' forward-char
bindkey -M viins '^b' backward-char
bindkey -M viins '^f' forward-char
bindkey -M viins '^[[D' backward-char
bindkey -M viins '^[[C' forward-char
bindkey -M viins '^[OD' backward-char
bindkey -M viins '^[OC' forward-char

# Word movement (Alt-h/l, Alt-b/f, Alt-w, Ctrl/Alt Left/Right)
bindkey -M viins '\eh' backward-word
bindkey -M viins '\el' forward-word
bindkey -M viins '\eb' backward-word
bindkey -M viins '\ef' forward-word
bindkey -M viins '^[b' backward-word
bindkey -M viins '^[f' forward-word
bindkey -M viins '\ew' forward-word
bindkey -M viins '^[[1;5D' backward-word
bindkey -M viins '^[[1;5C' forward-word
bindkey -M viins '^[[5D' backward-word
bindkey -M viins '^[[5C' forward-word
bindkey -M viins '^[^[[D' backward-word
bindkey -M viins '^[^[[C' forward-word
bindkey -M viins '\e[1;3D' backward-word
bindkey -M viins '\e[1;3C' forward-word

# Line movement (Ctrl-a/e, Home/End keys)
bindkey -M viins '^a' beginning-of-line
bindkey -M viins '^e' end-of-line
bindkey -M viins '^[[H' beginning-of-line
bindkey -M viins '^[[F' end-of-line
bindkey -M viins '^[OH' beginning-of-line
bindkey -M viins '^[OF' end-of-line
bindkey -M viins '^[[1~' beginning-of-line
bindkey -M viins '^[[4~' end-of-line
bindkey -M viins '^[[7~' beginning-of-line
bindkey -M viins '^[[8~' end-of-line

# Essential editing in insert mode
bindkey -M viins '^?' backward-delete-char
bindkey -M viins '^[[3~' delete-char
bindkey -M viins '^d' delete-char
bindkey -M viins '^w' backward-kill-word
bindkey -M viins '^u' backward-kill-line
bindkey -M viins '\ed' kill-word

# --- History-Matched Search with Cursor at End (Ctrl-p / Ctrl-n) ---
autoload -U history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end

# Works across insert and normal modes
bindkey '^p' history-beginning-search-backward-end
bindkey '^n' history-beginning-search-forward-end
bindkey -M viins '^p' history-beginning-search-backward-end
bindkey -M viins '^n' history-beginning-search-forward-end
bindkey -M vicmd '^p' history-beginning-search-backward-end
bindkey -M vicmd '^n' history-beginning-search-forward-end

# Also keep Up and Down arrows behaving identically
bindkey '\e[A' history-beginning-search-backward-end
bindkey '\e[B' history-beginning-search-forward-end

# --- Cursor Shape & Prompt Symbol Color (Changes with Vi Mode) ---
PROMPT_CHAR_COLOR='#76946A' # Green in Insert mode, Red-Orange in Normal mode

function zle-keymap-select {
  if [[ ${KEYMAP} == vicmd ]] || [[ $1 = 'block' ]]; then
    echo -ne '\e[2 q'
    PROMPT_CHAR_COLOR='#E58B58' # Warm orange when in Normal/Command mode
  else
    echo -ne '\e[5 q'
    PROMPT_CHAR_COLOR='#76946A' # Green when in Insert mode
  fi
  zle reset-prompt
}
zle -N zle-keymap-select

_fix_cursor() {
  echo -ne '\e[5 q'
  PROMPT_CHAR_COLOR='#76946A'
}
precmd_functions+=(_fix_cursor)

# --- Fast Git Branch Prompt Helper ---
autoload -Uz vcs_info
precmd_vcs_info() { vcs_info }
precmd_functions+=(precmd_vcs_info)
setopt prompt_subst
zstyle ':vcs_info:git:*' formats ' %F{#FFA066}(%b)%f'
zstyle ':vcs_info:*' enable git

# --- Prompt (Distraction-free 2-line layout: time, concise path, git, error indicator) ---
PROMPT='%F{#727169}%D{%H:%M}%f %F{#7FB4CA}%3~%f${vcs_info_msg_0_}%(?.. %F{#FF5D62}↵ %?%f)
%F{${PROMPT_CHAR_COLOR}}❯%f '

# --- Useful Distraction-Free Aliases ---
alias v="nvim"
alias vim="nvim"
alias vi="nvim"
alias ls="ls --color=auto"
alias ll="ls -la --color=auto"
alias grep="grep --color=auto"
alias kitty="kitty --start-as=fullscreen"

# --- Plugins (Autosuggestions & Syntax Highlighting) ---
if [ -f ${ZDOTDIR:-$HOME/.config/zsh}/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
  ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#727169'
  ZSH_AUTOSUGGEST_STRATEGY=(history completion)
  source ${ZDOTDIR:-$HOME/.config/zsh}/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
  bindkey '^y' autosuggest-accept
fi

if [ -f ${ZDOTDIR:-$HOME/.config/zsh}/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
  source ${ZDOTDIR:-$HOME/.config/zsh}/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi
