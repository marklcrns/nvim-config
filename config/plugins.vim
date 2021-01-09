call plug#begin('~/.cache/vim/plugged')

Plug 'vimwiki/vimwiki', { 'on': ['VimwikIndex', 'VimwikiDiaryIndex', 'VimwikiUISelect'], 'for': 'vimwiki' }
Plug 'christoomey/vim-tmux-navigator'
Plug 'tyru/caw.vim'
Plug 'machakann/vim-sandwich'
Plug 'Raimondi/delimitMate'
Plug 'liuchengxu/vim-clap', { 'do': ':Clap install-binary!' }

Plug 'dhruvasagar/vim-zoom'
Plug 'plasticboy/vim-markdown', { 'for': 'markdown' }
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug'] }

call plug#end()

" Auto install missing plugins
autocmd VimEnter *
  \  if !empty(filter(copy(g:plugs), '!isdirectory(v:val.dir)'))
  \|   PlugInstall
  \| endif

let g:zoom#statustext = ''

source $VIM_PATH/config/plugins/delimitMate.vim
source $VIM_PATH/config/plugins/vim-clap.vim
source $VIM_PATH/config/plugins/vim-markdown.vim
source $VIM_PATH/config/plugins/markdown-preview.vim
source $VIM_PATH/config/plugins/vimwiki.vim
