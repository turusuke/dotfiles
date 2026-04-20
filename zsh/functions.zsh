function mkcd() {
  if [[ -d $1 ]]; then
    echo "$1 already exists!"
    cd "$1"
  else
    mkdir -p "$1" && cd "$1"
  fi
}

function url_encode() {
  echo "$1" | nkf -WwMQ | tr = % | tr -d '\n' | sed -e 's/%%/%/g'
}

function url_decode() {
  echo "$1" | tr % = | nkf -WwmQ
}

function gwt() {
  local git_cdup_dir
  git_cdup_dir="$(git rev-parse --show-cdup)"
  git worktree add "${git_cdup_dir}git-worktrees/$1" -b "$1"
}

function cgb() {
  local branches branch
  branches=$(git branch -vv) &&
  branch=$(echo "$branches" | fzf +m) &&
  git checkout "$(echo "$branch" | awk '{print $1}' | sed "s/.* //")"
}

function cgbr() {
  local branches branch
  branches=$(git branch --all | grep -v HEAD) &&
  branch=$(echo "$branches" |
  fzf-tmux -d $(( 2 + $(wc -l <<< "$branches") )) +m) &&
  git checkout "$(echo "$branch" | sed "s/.* //" | sed "s#remotes/[^/]*/##")"
}

function copy-prev-cmd-to-clipboard() {
  fc -lrn | head -n 1 | pbcopy
}

function prev() {
  local prev_cmd
  prev_cmd=$(fc -lrn | head -n 1)
  sh -c "pet new -t $(printf %q "$prev_cmd")"
}

function pet-select() {
  BUFFER=$(pet search --query "$LBUFFER")
  CURSOR=$#BUFFER
  zle redisplay
}

function scb() {
  local articles title

  if [[ $1 == '--create' || $1 == '-c' ]]; then
    open "https://scrapbox.io/$2/$3"
  elif [[ $1 == '--open' || $1 == '-o' ]]; then
    articles=$(curl -s "https://scrapbox.io/api/pages/$2" -b "connect.sid=$SCRAPBOX_SID")
    title=$(echo "$articles" | tr -d '[:cntrl:]' | jq -r '.pages[].title' | fzf)
    echo "https://scrapbox.io/$2/$(echo "$articles" | tr -d '[:cntrl:]' | jq -r --arg title "$title" '.pages[] | select(.title == $title) | .title' | sed -e 's/  */_/g')" | xargs open
  else
    title=$(curl -s "https://scrapbox.io/api/pages/$1" -b "connect.sid=$SCRAPBOX_SID" | jq -r '.pages[].title' | fzf | sed -e 's/ /_/g' | nkf -WwMQ | sed 's/=$//g' | tr = % | tr -d '\n')
    curl -s "https://scrapbox.io/api/pages/$1/$title/text" -b "connect.sid=$SCRAPBOX_SID" | bat -l md
  fi
}

# ref: https://zenn.dev/shunk031/articles/ghq-gwq-fzf-worktree
function ghq-path() {
    ghq list --full-path | fzf
}

function dev() {
    local moveto
    moveto=$(ghq-path)
    cd "${moveto}" || exit 1

    # rename session if in tmux
    if [[ -n ${TMUX} ]]; then
        local repo_name
        repo_name="${moveto##*/}"

        tmux rename-session "${repo_name//./-}"
    fi
}
