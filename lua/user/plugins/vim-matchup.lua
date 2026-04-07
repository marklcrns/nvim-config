return function()
  vim.cmd([[
    let g:matchup_matchparen_deferred = 1
    let g:matchup_matchparen_hi_surround_always = 1
    " Disable treesitter integration: nvim-treesitter is archived and its
    " query_predicates are incompatible with Neovim 0.13-dev (nil node in match table)
    let g:matchup_matchparen_nomode = 'i'
  ]])
  -- Disable treesitter integration via Lua API
  vim.g.matchup_treesitter_enabled = 0
end
