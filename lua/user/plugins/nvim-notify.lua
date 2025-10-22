return function()
  ---@diagnostic disable-next-line: different-requires
  local notify = require("notify")
  notify.setup({
    max_width = 80,
    max_height = 15,
    top_down = false,
    render = "wrapped-compact",
    stages = "static",
  })
  vim.opt.cmdheight = 1

  ---@diagnostic disable-next-line: duplicate-set-field
  vim.notify = function(msg, level, opts)
    opts = opts or {}
    notify(msg, level, vim.tbl_extend("force", opts, {
      on_open = function(winid)
        local bufid = api.nvim_win_get_buf(winid)
        -- vim.bo[bufid].filetype = "markdown"
        vim.wo[winid].conceallevel = 3
        vim.wo[winid].concealcursor = "n"
        vim.wo[winid].spell = false
        vim.treesitter.start(bufid, "markdown")

        if opts.on_open then
          opts.on_open(winid)
        end
      end,
    }))
  end
end
