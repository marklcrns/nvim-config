" NOTE: Must run `:call dein#recache_runtimepath()` when switching between modes
" and toggling g:init_secondary_config
" To delete unused plugins, run `:call map(dein#check_clean(), "delete(v:val, \"rf\")")`
" ------
" full    = loads /config/plugins/plugins.* (default)
" minimal = loads /config/plugins/plugins_minimal.*
" skip    = only load ~/.local-nvim.d/config/plugins.* (global keybinds.vim will be skipped as well)
" disable = disable package manager (no plugins will be loaded)
let g:handle_plugins = 'full'

" Initialize ~/.local-nvim.d/init.vim
let g:init_secondary_config = 0

" Currently supported: dein_yaml, dein_toml
let g:package_manager = 'dein_yaml'

" Custom settings enable
let g:custom_statusline_enable = 1
let g:custom_tabline_enable = 1
let g:custom_cursorline_enable = 1
let g:custom_cursorcolumn_enable = 0

" Gui Fonts
let g:guifontsize = 12
" let g:guifont = 'Source\ Code\ Pro\ iCursive\ S12'
let g:guifont = 'OperatorMono\ Nerd\ Font'

execute 'source' fnamemodify(expand('<sfile>'), ':h').'/core/rtp.vim'
execute 'source' fnamemodify(expand('<sfile>'), ':h').'/core/core.vim'
