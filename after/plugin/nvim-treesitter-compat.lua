-- Patch nvim-treesitter's set-lang-from-info-string! directive to handle
-- Neovim 0.13-dev where match values are TSNode[] arrays instead of single nodes.
-- nvim-treesitter is archived and won't ship this fix upstream.

vim.api.nvim_create_autocmd("User", {
  pattern = "LazyDone",
  once = true,
  callback = function()
    local query = vim.treesitter.query
    if not query or not query.add_directive then return end

    query.add_directive("set-lang-from-info-string!", function(match, _, bufnr, pred, metadata)
      local capture_id = pred[2]
      local node = match[capture_id]
      if not node then return end
      -- Nvim 0.13-dev: match values may be TSNode[] arrays
      if type(node) == "table" and not vim.is_callable(node) then
        node = node[1]
      end
      if not node or not vim.is_callable(node.range) then return end
      local text = vim.treesitter.get_node_text(node, bufnr)
      if not text then return end
      local alias = text:lower():match("^%s*(%S+)")
      if alias then
        metadata["injection.language"] = alias
      end
    end, { force = true, all = false })
  end,
})
