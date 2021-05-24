" NOTE: Must run `:call dein#recache_runtimepath()` when switching between modes
" and toggling g:init_secondary_config
" To delete unused plugins, run `:call map(dein#check_clean(), "delete(v:val, \"rf\")")`
" ------
" full    = loads /config/plugins/plugins.* (default)
" minimal = loads /config/plugins/plugins_minimal.*
" skip    = no load plugins (excluding ~/.local-nvim.d/config/plugins.*)
" disable = disable package manager (no plugins will be loaded)
let g:handle_plugins = 'full'
" Initialize ~/.local-nvim.d/init.vim
let g:init_secondary_config = 0
" Currently supported: dein_yaml, dein_toml
let g:package_manager = 'dein_yaml'

execute 'source' fnamemodify(expand('<sfile>'), ':h').'/core/rtp.vim'
execute 'source' fnamemodify(expand('<sfile>'), ':h').'/core/core.vim'
