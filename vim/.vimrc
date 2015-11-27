" This is required for Vundle
set nocompatible
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin() 

source ~/.vimrc.bundles.local
source ~/.vimrc.local

call vundle#end()
colorscheme hybrid

highlight ColorColumn ctermbg=236 guibg=#1e2227

filetype plugin indent on
