" Neotags
" set regexpengine=1
" let g:neotags_enabled = 1
" let g:neotags_file = '~/flowcontroller/flowcontroller/tags'
" let g:neotags_highlight = 1
" let g:neotags_run_ctags = 0
" let g:neotags#python#order = 'mfc'

" highlight link pythonMethodTag Special
" highlight link pythonFunctionTag Special
" highlight link pythonClassTag Identifier

" highlighter.nvim
let g:highlighter#auto_update = 2


let g:highlighter#syntax_python = [
	\ { 'hlgroup'       : 'HighlighterPythonFunction',
	\   'hlgroup_link'  : 'Identifier',
	\   'tagkinds'      : 'f',
	\   'syntax_type'   : 'match',
	\   'syntax_suffix' : '(\@=',
	\ },
	\ { 'hlgroup'       : 'HighlighterPythonMethod',
	\   'hlgroup_link'  : 'Identifier',
	\   'tagkinds'      : 'm',
	\   'syntax_type'   : 'match',
	\   'syntax_prefix' : '\.\@<=',
	\ },
	\ { 'hlgroup'       : 'HighlighterPythonClass',
	\   'hlgroup_link'  : 'Type',
	\   'tagkinds'      : 'c',
	\ },
	\ { 'hlgroup'       : 'HighlighterPythonVariable',
	\   'hlgroup_link'  : 'Contstant',
	\   'tagkinds'      : 'v',
	\ }]

map <F10> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
\ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
\ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>
"  Gutentags
" let g:gutentags_ctags_tagfile = '~/flowcontroller/mytags'
"
" atags.vim
" let g:atags_build_commands_list = [
"     \"ctags -R -f tags.tmp",
"     \"awk 'length($0) < 400' tags.tmp > ~/flowcontroller/tags",
"     \"rm tags.tmp"
"     \]
" autocmd BufWritePost * call atags#generate()
