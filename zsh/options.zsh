HISTFILE=~/.zsh_history
HISTSIZE=1000000
SAVEHIST=1000000

setopt print_eight_bit
setopt no_beep
setopt share_history
setopt histignorealldups
setopt hist_ignore_all_dups
setopt hist_ignore_space
setopt hist_reduce_blanks
setopt extended_glob
setopt auto_cd

autoload -Uz history-search-end
autoload -Uz zmv

if [[ -o interactive ]]; then
  bindkey '^R' history-incremental-pattern-search-backward

  zle -N history-beginning-search-backward-end history-search-end
  zle -N history-beginning-search-forward-end history-search-end
  bindkey "^p" history-beginning-search-backward-end
  bindkey "^b" history-beginning-search-forward-end

  zle -N copy-prev-cmd-to-clipboard
  bindkey '^K' copy-prev-cmd-to-clipboard

  zle -N pet-select
  [[ -t 0 ]] && stty -ixon
  bindkey '^,' pet-select
fi
