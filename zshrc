if [ -f $(brew --prefix)/etc/brew-wrap ];then
  source $(brew --prefix)/etc/brew-wrap
fi
eval "$(anyenv init -)"

source /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/local/opt/powerlevel10k/powerlevel10k.zsh-theme

########################################

# 少し凝った zshrc
# License : MIT
# http://mollifier.mit-license.org/

# 上記の一部設定をカスマイズして使っています

# 環境変数
export LANG=ja_JP.UTF-8
export FZF_CTRL_T_COMMAND='rg --files --hidden --follow --glob "!.git/*"'
export FZF_CTRL_T_OPTS='--preview "bat --color=always --style=header,grid --line-range :100 {}"'
export NNN_PLUG='f:finder;o:fzopen;p:mocplay;d:diffs;t:nmount;v:imgview'
export DOCKER_CONTENT_TRUST=1

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

########################################

# cd を入力しなくても移動できるようにする
setopt auto_cd

# alias
alias -g C='| pbcopy'  # C で標準出力をクリップボードにコピーする
alias -g X='| xargs'
alias k='kill -9'
alias zshrc='vim ~/.zshrc'
alias vimrc='vim ~/.vimrc'
alias ideavim='vim ~/.ideavimrc'
alias brewfile='vim ~/.config/brewfile/Brewfile'
alias tigrc='vim ~/.tigrc'
alias dotfiles='cd ~/dotfiles'
alias dein='vim ~/dotfiles/dein_plugins'
alias -s {html,pug,nunjax,css,scss,js,ts,tsc}='code'
alias sz='source ~/.zshrc'
alias tmuxconf='vim ~/tmux.conf'
alias gq='cd $(ghq root)/$(ghq list | fzf --preview "bat --color=always --style=header,grid --line-range :80 $(ghq root)/{}/README.*")'
alias hb='hub browse $(ghq list | fzf | cut -d "/" -f 2,3)'
alias ls='ls -G'
alias la='ls -a'
alias mkdir='mkdir -p'
# alias npm=prioritize-yarn

# alias git
alias g=git
alias gc='g commit'
alias ga='g add'
alias gA='g add -A'
alias gch='g checkout'
alias gf='g fetch'
alias gs='g status'
alias gd='g diff'
alias gdh='g diff HEAD'
alias gdc='g diff --cached'
alias gce='g commit --allow-empty'
alias gca='g commit -a'
alias gl='g log'
alias gso='g show'
alias deco='g log --graph --oneline --decorate=full'
alias fco='g checkout `git branch --all | grep -v HEAD | fzf`' # fzf でブランチを検索、checkout
alias gio='g switch --orphan'
alias gr='g restore'
alias grso='g restore --source' # 特定ファイルを特定コミットの状態にする
alias grst='g restore --staged' # ステージングにあるファイルを実ファイルへの変更はそのままで復旧する
alias grw='g restore --workspace' # ワークツリー上のファイルを復旧する
alias gp='g pull'
alias gzz='g fuzzy'

alias bri='brew install'

# alias npm
alias ni='npm init'
alias nis='npm install --save'
alias nid='npm install --save-dev'
alias nin='npm install --no-save'
alias nig='npm install -g'
alias nui='npm uninstall --save'
alias nud='npm uninstall --save-dev'
alias nau='npm audit'

# alias docker
alias dc='docker container ls -a --format "{{.Names}}" | fzf'

## https://qiita.com/yaotti/items/0af5d50f4f52d22a46fe
local git==git
branchname=`${git} symbolic-ref --short HEAD 2> /dev/null`

# tree alias
alias tree="tree -I node_modules"

#  zsh-completions
if [ -e /usr/local/share/zsh-completions ]; then
    fpath=(/usr/local/share/zsh-completions $fpath)
fi

# z
. `brew --prefix`/etc/profile.d/z.sh

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

# docui
export LC_CTYPE=en_US.UTF-8
export TERM=xterm-256color

# fzf
export FZF_DEFAULT_COMMAND='ag -g ""'

# nnn
export NNN_PLUG='f:finder;o:fzopen;p:mocplay;d:diffs;t:nmount;v:imgview'

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

function copy-prev-cmd-to-clipboard () {
  fc -lrn | head -n 1 | pbcopy
}
zle -N copy-prev-cmd-to-clipboard

# 直前のコマンドをコピーする
bindkey '^K' copy-prev-cmd-to-clipboard

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
stty -ixon
bindkey '^,' pet-select

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# scrapbox
function scb() {
  if [[ $1 == '--create' || $1 == '-c' ]]; then
    open "https://scrapbox.io/$2/$3"
  elif [[ $1 == '--open' || $1 == '-o' ]]; then
    articles=$(curl -s "https://scrapbox.io/api/pages/$2" -b "connect.sid=$SCRAPBOX_SID")
    title=$(echo $articles | tr -d '[:cntrl:]' | jq -r '.pages[].title' | fzf)
    echo "https://scrapbox.io/$2/$(echo $articles | tr -d '[:cntrl:]' | jq -r --arg title $title '.pages[] | select(.title == $title) | .title' | sed -e 's/  */_/g')" | xargs open
  else
    title=$(curl -s "https://scrapbox.io/api/pages/$1" -b "connect.sid=$SCRAPBOX_SID" | jq -r '.pages[].title' | fzf | sed -e 's/ /_/g' | nkf -WwMQ | sed 's/=$//g' | tr = % | tr -d '\n')
    curl -s "https://scrapbox.io/api/pages/$1/$title/text" -b "connect.sid=$SCRAPBOX_SID" | bat -l md
  fi
}

# ローカルの zshrc を読み込む
if [[ -f ~/.zshrc-local ]]; then
  echo 'Loaded .zshrc-local'
  source ~/.zshrc-local
fi

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh


# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('~/opt/anaconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "~/opt/anaconda3/etc/profile.d/conda.sh" ]; then
        . "~/opt/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="~/opt/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

export PATH="/Users/turusuke/dotfiles/git-fuzzy/bin:$PATH"
