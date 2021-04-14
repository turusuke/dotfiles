"dein Scripts-----------------------------
if &compatible
  set nocompatible
endif

" Required:
set runtimepath+=~/.cache/dein/repos/github.com/Shougo/dein.vim

" Required:
if dein#load_state('~/.cache/dein')
  call dein#begin('~/.cache/dein')

  " Let dein manage dein
  " Required:
  call dein#add('Shougo/dein.vim')
  " 起動時に読み込むプラグイン群
  call dein#load_toml('~/dotfiles/dein_plugins/dein.toml', {'lazy': 0})
  "" 遅延読み込みしたいプラグイン群
  call dein#load_toml('~/dotfiles/dein_plugins/dein_lazy.toml', {'lazy': 1})
  " Required:
  call dein#end()
  call dein#save_state()
endif

" Required:
filetype plugin indent on
syntax enable

" If you want to install not installed plugins on startup.
if dein#check_install()
  call dein#install()
endif

"End dein Scripts-------------------------

" =============================================================
" Global Configuration
" =============================================================
let mapleader=","
set helplang=ja,en

set autoindent
set expandtab
set tabstop=2
set shiftwidth=2
set cursorline
set number
set encoding=utf-8
set fileencoding=utf-8
set backspace=indent,eol,start
set wildmenu
set shell=zsh\ -i

" カーソルの形状を変化させる
" https://qiita.com/Linda_pp/items/9e0c94eb82b18071db34
if has('vim_starting')
  " 挿入モード時に非点滅の縦棒タイプのカーソル
  let &t_SI .= "\e[6 q"
  " ノーマルモード時に非点滅のブロックタイプのカーソル
  let &t_EI .= "\e[2 q"
  " 置換モード時に非点滅の下線タイプのカーソル
  let &t_SR .= "\e[4 q"
endif

let g:user_emmet_settings = {
\  'variables' : {
\    'lang' : "ja"
\  },
\  'html' : {
\    'indentation' : '  ',
\    'snippets' : {
\      'html:5': "<!DOCTYPE html>\n"
\        ."<html lang=\"${lang}\">\n"
\        ."<head>\n"
\        ."\t<meta charset=\"${charset}\">\n"
\        ."\t<meta http-equiv=\"X-UA-Compatible\" content=\"IE=edge\">\n"
\        ."\t<meta name=\"viewport\" content=\"width=device-width, initial-scale=1\">\n"
\        ."\t<title></title>\n"
\        ."</head>\n"
\        ."<body>\n\t${child}|\n</body>\n"
\        ."</html>",
\    }
\  }
\}

" 外部で変更のあったファイルを自動的に読み込む
if has("autocmd")
  augroup vimrc-checktime
  autocmd!
  autocmd InsertEnter,WinEnter * checktime
  augroup END
endif

" Vimでプロジェクト固有の設定を適用する
" https://qiita.com/unosk/items/43989b61eff48e0665f3
augroup vimrc-local
  autocmd!
  autocmd BufNewFile,BufReadPost * call s:vimrc_local(expand('<afile>:p:h'))
augroup END

function! s:vimrc_local(loc)
  let files = findfile('.vimrc.local', escape(a:loc, ' ') . ';', -1)
  for i in reverse(filter(files, 'filereadable(v:val)'))
    source `=i`
  endfor
endfunction

" =============================================================
" Editor control
" =============================================================
inoremap <silent> ;; <ESC> ";;でノーマルモード
nnoremap <silent><C-e> :NERDTreeToggle<CR> " ファイルツリーを Ctrl + e で出せるようにする
nnoremap Y 0y$ " 先頭から行末までコピー

" =============================================================
" Clipboard
" =============================================================
set clipboard=unnamed,unnamedplus " クリップボードと yank を同期させる
" statusline
" ===============================
set laststatus=2
let g:lightline = {
  \ 'colorscheme': 'gruvbox'
  \ }

" indentGuide
let g:indent_guides_enable_on_vim_startup = 1 " vimを立ち上げたときに、自動的にvim-indent-guidesをオンにする
let g:bookmark_auto_close = 1 " マーク一覧からマークを選択した後に自動的にウィンドウを閉じる

" incserarch-easymotion
map z/ <Plug>(incsearch-easymotion-/)
map z? <Plug>(incsearch-easymotion-?)
map zg/ <Plug>(incsearch-easymotion-stay)

" easy-motion
let g:EasyMotion_do_mapping = 0 " Disable default mappings
map <Leader> <Plug>(easymotion-prefix)

" Jump to anywhere you want with minimal keystrokes, with just one key binding.
" `s{char}{label}`
nmap s <Plug>(easymotion-overwin-f)
" or
" `s{char}{char}{label}`
" Need one more keystroke, but on average, it may be more comfortable.
nmap s <Plug>(easymotion-overwin-f2)

" Turn on case-insensitive feature
let g:EasyMotion_smartcase = 1

" JK motions: Line motions
map <Leader>j <Plug>(easymotion-j)
map <Leader>k <Plug>(easymotion-k)" =======================================

" General Configuration
" =======================================
let g:EasyMotion_keys = 'QWERASDFZXCV'
" Show target key with upper case to improve readability
let g:EasyMotion_use_upper = 1
" Jump to first match with enter & space
let g:EasyMotion_enter_jump_first = 1
let g:EasyMotion_space_jump_first = 1

