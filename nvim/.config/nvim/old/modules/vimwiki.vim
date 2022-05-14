" Task and Wiki
Plug 'vimwiki/vimwiki'
Plug 'tbabej/taskwiki'
Plug 'plasticboy/vim-markdown'

" ====================================================================
"           VimWiki settings
" ====================================================================
let g:vimwiki_list = [{'path': '~/vimwiki/', 'syntax': 'markdown', 'ext': '.md'}]
:nmap <Leader><CR> <Plug>VimwikiFollowLink
