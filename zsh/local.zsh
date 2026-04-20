if [[ -f ~/.zshrc-local ]]; then
  echo 'Loaded .zshrc-local'
  source ~/.zshrc-local
fi

[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh
