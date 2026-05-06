execute 'source' fnamemodify(expand('<sfile>'), ':h').'/core/utils.vim'

" Disable unused providers to suppress checkhealth warnings
let g:loaded_perl_provider = 0
let g:loaded_ruby_provider = 0

let g:enable_format_on_save= v:true

" Snippet engine used by blink.cmp (luasnip or ultisnips)
let g:snippet_engine = 'luasnip'

" ─── Colorscheme ─────────────────────────────────────────────────────────────
" Colorscheme to activate. Special values 'default_dark' / 'default_light'
" resolve to the names below. Can include background: 'kanagawa dark'.
" NVIM_COLORSCHEME env var overrides this.
let g:colorscheme               = 'tokyonight'
let g:default_dark_colorscheme  = 'tokyonight'
let g:default_light_colorscheme = 'seoulbones'
" ─────────────────────────────────────────────────────────────────────────────

" Enable ai code autosuggestions
let g:ai_enabled = v:true

" Enable this to disable cpu intensive plugins/modules (default: false)
let g:low_performance_mode = g:ReadCacheFromDataDir('low_performance_mode', v:false) == 0 ? v:false : v:true

" ─── Plugin category switches ────────────────────────────────────────────────
" Set to v:false to disable an entire category and all plugins that depend on it.

" LSP stack: mason, nvim-lspconfig, mason-lspconfig, conform, trouble,
"            goto-preview, typescript-tools, nvim-jdtls, inc-rename
let g:lsp_enabled = v:true

" Treesitter stack: nvim-treesitter + textobjects/textsubjects/context/endwise
let g:treesitter_enabled = v:true

" Git stack: fugitive, neogit, gitsigns, diffview, vim-flog
let g:git_enabled = v:true

" Notetaking stack: markview
let g:notetaking_enabled = v:true
" ─────────────────────────────────────────────────────────────────────────────

" Load core files. Will be deprecated soon!
execute 'source' fnamemodify(expand('<sfile>'), ':h').'/core/rtp.vim'
execute 'source' fnamemodify(expand('<sfile>'), ':h').'/core/core.vim'
