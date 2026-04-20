if (( $+commands[brew] )); then
  brew_prefix="$(brew --prefix)"

  [[ -f "$brew_prefix/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]] &&
    source "$brew_prefix/share/zsh-autosuggestions/zsh-autosuggestions.zsh"

  [[ -f "$brew_prefix/etc/profile.d/z.sh" ]] &&
    source "$brew_prefix/etc/profile.d/z.sh"

  [[ -f "$brew_prefix/etc/brew-wrap" ]] &&
    source "$brew_prefix/etc/brew-wrap"

  unset brew_prefix
fi

# powerlevel10k
[[ -f ~/powerlevel10k/powerlevel10k.zsh-theme ]] &&
  source ~/powerlevel10k/powerlevel10k.zsh-theme

# zsh-completion
if [[ -d /usr/local/share/zsh-completions ]]; then
  fpath=(/usr/local/share/zsh-completions $fpath)
fi

# fzf
[[ -f ~/.fzf.zsh ]] && source ~/.fzf.zsh

# bear
BEAR_AC_ZSH_SETUP_PATH=~/Library/Caches/@sloansparger/bear/autocomplete/zsh_setup
[[ -f "$BEAR_AC_ZSH_SETUP_PATH" ]] && source "$BEAR_AC_ZSH_SETUP_PATH"
unset BEAR_AC_ZSH_SETUP_PATH

# mise
if (( $+commands[mise] )); then
  eval "$(mise activate zsh)"
fi
