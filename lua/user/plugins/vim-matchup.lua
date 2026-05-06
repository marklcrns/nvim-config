return function()
  vim.cmd([[
    let g:matchup_matchparen_deferred = 1
    let g:matchup_matchparen_hi_surround_always = 1
    let g:matchup_matchparen_nomode = 'i'
  ]])
  -- Treesitter integration: Nvim 0.13 TSNode[] match format is handled by
  -- our set-lang-from-info-string! patch in lua/user/plugins/nvim-treesitter.lua
end
