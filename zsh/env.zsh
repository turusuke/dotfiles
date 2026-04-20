export EDITOR=/opt/homebrew/bin/vim
export LANG=ja_JP.UTF-8
export LC_CTYPE=en_US.UTF-8
export TERM=xterm-256color
export DOCKER_CONTENT_TRUST=1

export FZF_CTRL_T_COMMAND='rg --files --hidden --follow --glob "!.git/*"'
export FZF_CTRL_T_OPTS='--preview "bat --color=always --style=header,grid --line-range :100 {}"'
export FZF_DEFAULT_COMMAND='ag -g ""'

export NNN_PLUG='f:finder;o:fzopen;p:mocplay;d:diffs;t:nmount;v:imgview'
export PNPM_HOME="/Users/turusuke/Library/pnpm"

typeset -U path PATH
path=(
  /Users/turusuke/.local/bin
  /opt/homebrew/opt/trash/bin
  "$PNPM_HOME"
  $path
  /Users/turusuke/.lmstudio/bin
)

export PATH
