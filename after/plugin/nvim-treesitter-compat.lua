-- Patch nvim-treesitter's set-lang-from-info-string! directive to handle
-- Neovim 0.13-dev where match values are TSNode[] arrays instead of single nodes.
-- nvim-treesitter is archived and won't ship this fix upstream.
-- See: https://github.com/nvim-treesitter/nvim-treesitter (archived May 2025)

vim.api.nvim_create_autocmd("User", {
  pattern = "LazyDone",
  once = true,
  callback = function()
    local ok, query = pcall(require, "nvim-treesitter.query")
    if not ok then return end

    local ok2, ts_query = pcall(require, "vim.treesitter.query")
    if not ok2 then ts_query = vim.treesitter.query end

    -- Re-register the directive with nil-safe node handling
    local opts = { force = true, all = false }
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
      -- replicate get_parser_from_markdown_info_string logic
      local alias = text:lower():match("^%s*(%S+)")
      if alias then
        metadata["injection.language"] = alias
      end
    end, opts)
  end,
})
