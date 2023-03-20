" NOTE: Must run `:call dein#recache_runtimepath()` when switching between modes
" and toggling g:init_secondary_config
" To delete unused plugins, run `:call map(dein#check_clean(), "delete(v:val, \"rf\")")`
" ------
" full    = loads /config/plugins/plugins.* (default)
" minimal = loads /config/plugins/plugins_minimal.*
" skip    = only load ~/.local-nvim.d/config/plugins.* (global keybinds.vim will be skipped as well)
" disable = disable package manager (no plugins will be loaded)
" ------
"  Lazy loaded plugin for toml plugins can be put in a separate file:
"  plugins_minimal_lazy.toml
"  Yaml plugins does not need to be in a separate '_lazy' file and thus wont be
"  loaded.

let g:handle_plugins = 'full'

" Initialize ~/.local-nvim.d/init.vim
let g:init_secondary_config = 0

" Currently supported: dein_yaml (requires PyYAML), dein_toml
let g:package_manager = 'dein_yaml'

" Custom settings enable
let g:custom_colorscheme = v:true
let g:custom_colorscheme_persist = v:true
let g:transparent_background = v:true
let g:custom_statusline_enable = v:true
let g:custom_tabline_enable = v:true
let g:custom_cursorline_enable = v:true    " See modes.luv:true
let g:custom_cursorcolumn_enable = v:false
let g:enable_format_on_save= v:true

" Gui Fonts
let g:guifontsize = 12
" let g:guifont = 'Source\ Code\ Pro\ iCursive\ S12'
" let g:guifont = 'OperatorMono\ Nerd\ Font'
let g:guifont = 'VictorMono\ Nerd\ Font'

execute 'source' fnamemodify(expand('<sfile>'), ':h').'/core/rtp.vim'
execute 'source' fnamemodify(expand('<sfile>'), ':h').'/core/core.vim'
