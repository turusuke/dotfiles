if [ -f $(brew --prefix)/etc/brew-wrap ];then
  source $(brew --prefix)/etc/brew-wrap
fi
eval "$(anyenv init -)"

source /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# 環境変数
export LANG=ja_JP.UTF-8

# ヒストリの設定
HISTFILE=~/.zsh_history
HISTSIZE=1000000
SAVEHIST=1000000

# オプション
# 日本語ファイル名を表示可能にする
setopt print_eight_bit

# beep を無効にする
setopt no_beep

# 同時に起動したzshの間でヒストリを共有する
setopt share_history

# ヒストリーに重複を表示しない
setopt histignorealldups

# 同じコマンドをヒストリに残さない
setopt hist_ignore_all_dups

# スペースから始まるコマンド行はヒストリに残さない
setopt hist_ignore_space

# ヒストリに保存するときに余分なスペースを削除する
setopt hist_reduce_blanks

# 高機能なワイルドカード展開を使用する
setopt extended_glob

# ^R で履歴検索をするときに * でワイルドカードを使用出来るようにする
bindkey '^R' history-incremental-pattern-search-backward

# alias
alias -g C='| pbcopy'  # C で標準出力をクリップボードにコピーする
alias -g X='| xargs'
alias zshrc='vim ~/.zshrc'
alias vimrc='vim ~/.vimrc'
alias ideavim='vim ~/.ideavimrc'
alias brewfile='vim ~/.config/Brewfile'
alias tigrc='vim ~/.tigrc'
alias -s {html,pug,nunjax,css,scss,js,ts,tsc}='code'
alias s='source ~/.zshrc'
alias tmuxconf='vim ~/tmux.conf' 
alias gq='cd $(ghq root)/$(ghq list | fzf)'
alias gh='hub browse $(ghq list | fzf | cut -d "/" -f 2,3)'

# git
alias g=git
alias deco='g log --graph --oneline --decorate=full'
## https://qiita.com/yaotti/items/0af5d50f4f52d22a46fe
local git==git
branchname=`${git} symbolic-ref --short HEAD 2> /dev/null`

alias fco='git checkout `git branch --all | grep -v HEAD | fzf`' # fzf でブランチを検索、checkout
alias ls='ls -G'
alias mkdir='mkdir -p'

# カレントディレクトリ以下を再帰的に検索する
alias rgrep='find . -name "*.svn*" -prune -o -type f -print0 | xargs -0 grep'

# tree alias
alias tree="tree -I node_modules"

#  zsh-completions
if [ -e /usr/local/share/zsh-completions ]; then
    fpath=(/usr/local/share/zsh-completions $fpath)
fi

# コマンドを途中まで入力後、historyから絞り込み
# 例 ls まで打ってCtrl+pでlsコマンドをさかのぼる、Ctrl+bで逆順
autoload -Uz history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^p" history-beginning-search-backward-end
bindkey "^b" history-beginning-search-forward-end

# 複数ファイルのmv 例 zmv *.txt *.txt.bk
autoload -Uz zmv
alias zmv='noglob zmv -W'

# mkdirとcdを同時実行
function mkcd() {
  if [[ -d $1 ]]; then
    echo "$1 already exists!"
    cd $1
  else
    mkdir -p $1 && cd $1
  fi
}

function url_encode() {
  echo $1 | nkf -WwMQ | tr = % | tr -d '\n' | sed -e 's/%%/%/g'
}

function url_decode() {
  echo $1 | tr % = | nkf -WwmQ
}

# hub replace git
# function git(){hub "$@"}

# create git-worktree
function gwt() {
  GIT_CDUP_DIR=`git rev-parse --show-cdup`
  git worktree add ${GIT_CDUP_DIR}git-worktrees/$1 -b $1
}

# cgb - checkout git branch
function cgb() {
  local branches branch
  branches=$(git branch -vv) &&
  branch=$(echo "$branches" | fzf +m) &&
  git checkout $(echo "$branch" | awk '{print $1}' | sed "s/.* //")
}

# cgbr- checkout git branch (including remote branches)
function cgbr() {
  local branches branch
  branches=$(git branch --all | grep -v HEAD) &&
  branch=$(echo "$branches" |
  fzf-tmux -d $(( 2 + $(wc -l <<< "$branches") )) +m) &&
  git checkout $(echo "$branch" | sed "s/.* //" | sed "s#remotes/[^/]*/##")
}

# pet で直前のコマンドをスニペットに登録する
function prev() {
  PREV=$(fc -lrn | head -n 1)
  sh -c "pet new -t `printf %q "$PREV"`"
}

# コマンドライン上にスニペットを表示する
function pet-select() {
  BUFFER=$(pet search --query "$LBUFFER")
  CURSOR=$#BUFFER
  zle redisplay
}
zle -N pet-select
bindkey '^,' pet-select

source ~/powerlevel10k/powerlevel10k.zsh-theme

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# ローカルの zshrc を読み込む
if [[ -s "~/.zshrc-local" ]]; then
  echo 'Loaded .zshrc-local'
  source "~/.zshrc-local"
fi

# zplug section
export ZPLUG_HOME=/usr/local/opt/zplug
source $ZPLUG_HOME/init.zsh
zplug "b4b4r07/easy-oneliner", if:"which fzf"
