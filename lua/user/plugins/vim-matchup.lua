return function()
  vim.cmd([[
    let g:matchup_matchparen_deferred = 1
    let g:matchup_matchparen_hi_surround_always = 1
    " let g:matchup_matchparen_offscreen = {'method': 'popup'}
  ]])
end
