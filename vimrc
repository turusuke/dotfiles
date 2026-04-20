if &compatible
  set nocompatible
endif

" Required:
filetype plugin indent on
syntax enable

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
