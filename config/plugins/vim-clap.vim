let s:user_profile               = expand($HOME . '/.profile')
let s:user_bash_profile          = expand($HOME . '/.bash_profile')
let s:user_bashrc                = expand($HOME . '/.bashrc')
let s:user_bash_aliases          = expand($HOME . '/.bash_aliases')
let s:user_dotfilesrc            = expand($HOME . '/.dotfilesrc')
let s:user_zsh_profile           = expand($HOME . '/.zprofile')
let s:user_zshrc                 = expand($HOME . '/.zshrc')
let s:user_tmux_conf             = expand($HOME . '/.tmux.conf')
let s:user_git_config            = expand($HOME . '/.gitconfig')
let s:user_git_alias             = expand($HOME . '/.gitconfig.d/gitalias.txt')
let s:user_git_ignore_global     = expand($HOME . '/.gitignore_global')
let s:user_task_config           = expand($HOME . '/.taskrc')
let s:user_timewarrior_config    = expand($HOME . '/.timewarrior/timewarrior.cfg')
let s:user_nvim_core_mappings    = expand($VIM_PATH . '/core/mappings.vim')
let s:user_nvim_core_general     = expand($VIM_PATH . '/core/general.vim')
let s:user_nvim_coc_settings     = expand($VIM_PATH . '/coc-settings.json')
let s:user_nvim_plugins          = expand($VIM_PATH . '/config/plugins.yaml')
let s:user_nvim_plugins_mappings = expand($VIM_PATH . '/config/keybinds.vim')
let s:user_nvim_whichkey         = expand($VIM_PATH . '/config/plugins/whichkey.vim')

let g:clap_cache_directory = $DATA_PATH . '/clap'
let g:clap_disable_run_rooter = v:false
let g:clap_theme = 'atom_dark'
let g:clap_current_selection_sign= { 'text': '➤', 'texthl': "ClapCurrentSelectionSign", "linehl": "ClapCurrentSelection"}
let g:clap_layout = { 'relative': 'editor' }
let g:clap_enable_icon = 1
let g:clap_search_box_border_style = 'curve'
let g:clap_provider_grep_executable = 'rg'
let g:clap_provider_grep_opts = '-H --hidden --no-heading --smart-case --vimgrep -g "!.git/" -g "!node_modules/"'
let g:clap_provider_grep_enable_icon = 1
let g:clap_prompt_format = '%spinner%%forerunner_status% %provider_id%:'

let g:clap_provider_personalconf = {
      \ 'source': [
      \ s:user_profile,
      \ s:user_bash_profile,
      \ s:user_bashrc,
      \ s:user_bash_aliases,
      \ s:user_dotfilesrc,
      \ s:user_zsh_profile,
      \ s:user_zshrc,
      \ s:user_tmux_conf,
      \ s:user_git_config,
      \ s:user_git_alias,
      \ s:user_git_ignore_global,
      \ s:user_task_config,
      \ s:user_timewarrior_config,
      \ s:user_nvim_core_mappings,
      \ s:user_nvim_core_general,
      \ s:user_nvim_coc_settings,
      \ s:user_nvim_plugins,
      \ s:user_nvim_plugins_mappings,
      \ s:user_nvim_whichkey,
      \ ],
      \ 'sink': 'e',
      \ }

" A function to config highlight of ClapSymbol
" when the background color opaque
function! s:ClapSymbolHL() abort
    let s:current_bgcolor = synIDattr(hlID("Normal"), "bg")
    if s:current_bgcolor == ''
        hi ClapSymbol guibg=NONE ctermbg=NONE
    endif
endfunction

autocmd User ClapOnEnter call s:ClapSymbolHL()
