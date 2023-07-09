return function()
  vim.g.flog_default_opts = { max_count = 512 }
  vim.g.flog_override_default_mappings = {}
  vim.g.flog_jumplist_default_mappings = {}
  vim.g.flog_use_internal_lua = true
  vim.cmd([[
    " Compare the commit under the cursor with the current HEAD
    au FileType floggraph nno <buffer> <silent> d* :<C-U>exec flog#Exec(flog#Format("DiffviewOpen %h"), 0, 1, 1)<CR>

    " Compare the last interacted commit (ex. the last commit you hit "Enter" on) with the current HEAD
    au FileType floggraph nno <buffer> <silent> d* :<C-U>exec flog#Exec(flog#Format("DiffviewOpen %(h'!)"), 0, 1, 1)<CR>

    " Compare the commits at the beginning and end of the visual selection 
    au FileType floggraph vno <buffer> <silent> d* :<C-U>exec flog#Exec(flog#Format("DiffviewOpen %(h'<) %(h'>)"), 0, 1, 1)<CR>

    " Compare the commits at mark "a" and "b" (commits can be marked with "ma"/"mb")
    au FileType floggraph nno <buffer> <silent> d* :<C-U>exec flog#Exec(flog#Format("DiffviewOpen %(h'a) %(h'b)"), 0, 1, 1)<CR>
    ]])
end
