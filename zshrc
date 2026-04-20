DOTFILES_DIR="${${(%):-%N}:A:h}"

for zsh_config in \
  "$DOTFILES_DIR/zsh/env.zsh" \
  "$DOTFILES_DIR/zsh/functions.zsh" \
  "$DOTFILES_DIR/zsh/options.zsh" \
  "$DOTFILES_DIR/zsh/aliases.zsh" \
  "$DOTFILES_DIR/zsh/tools.zsh" \
  "$DOTFILES_DIR/zsh/local.zsh"
do
  [[ -r "$zsh_config" ]] && source "$zsh_config"
done

unset zsh_config
