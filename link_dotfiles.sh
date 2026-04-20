#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="${HOME}/.dotfiles_backup/$(date +%Y%m%d%H%M%S)"
DRY_RUN=false
FORCE=false

usage() {
  cat <<'USAGE'
Usage: ./link_dotfiles.sh [--dry-run] [--force]

Create symbolic links from this dotfiles repository into your home directory.

Options:
  --dry-run  Show what would be changed without changing files
  --force    Backup conflicting files, then replace them with symlinks
  -h, --help Show this help
USAGE
}

log() {
  printf '%s\n' "$*"
}

run() {
  if "$DRY_RUN"; then
    log "[dry-run] $*"
  else
    "$@"
  fi
}

link_file() {
  local source_path="${DOTFILES_DIR}/$1"
  local target_path="$2"
  local target_dir

  target_dir="$(dirname "$target_path")"

  if [[ ! -e "$source_path" ]]; then
    log "missing: $source_path"
    return 1
  fi

  if [[ -L "$target_path" ]]; then
    local current_target
    current_target="$(readlink "$target_path")"

    if [[ "$current_target" == "$source_path" ]]; then
      log "exists: $target_path -> $source_path"
      return 0
    fi
  fi

  if [[ -e "$target_path" || -L "$target_path" ]]; then
    if ! "$FORCE"; then
      log "skip: $target_path already exists. Use --force to replace it."
      return 0
    fi

    local backup_path="${BACKUP_DIR}${target_path}"
    log "backup: $target_path -> $backup_path"
    run mkdir -p "$(dirname "$backup_path")"
    run mv "$target_path" "$backup_path"
  fi

  run mkdir -p "$target_dir"
  run ln -s "$source_path" "$target_path"
  if "$DRY_RUN"; then
    log "would link: $target_path -> $source_path"
  else
    log "linked: $target_path -> $source_path"
  fi
}

while (($#)); do
  case "$1" in
    --dry-run)
      DRY_RUN=true
      ;;
    --force)
      FORCE=true
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      log "Unknown option: $1"
      usage
      exit 1
      ;;
  esac
  shift
done

link_file "zshrc" "${HOME}/.zshrc"
link_file "vimrc" "${HOME}/.vimrc"
link_file "ideavimrc" "${HOME}/.ideavimrc"
link_file "tigrc" "${HOME}/.tigrc"
link_file "tmux.conf" "${HOME}/.tmux.conf"
link_file "Brewfile" "${HOME}/.config/brewfile/Brewfile"
