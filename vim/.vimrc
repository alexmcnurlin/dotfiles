" Welcome to my .vimrc!
" I first learned vim with the 'aid' of spf13-vim, until I realized that I 
" should adventure into the land of making my vim configuration. 
" As a result a lot of the plugins/mappings come from spf13-vim.
" Also, the majority of my configuration is found in .vimrc.local, not here.
" Likewise, my plugins can all be found in .vimrc.bundles.local. 
"
"	Any configuration requiring a plugin should be noted as such. 
"
" This is required for Vundle
	set nocompatible
	filetype off
	set rtp+=~/.vim/bundle/Vundle.vim
	call vundle#begin() 

source ~/.vimrc.bundles.local
source ~/.vimrc.local

" Also required for Vundle
	call vundle#end()

set background=dark
colorscheme PaperColor

highlight ColorColumn ctermbg=236 guibg=#1e2227

filetype plugin indent on
