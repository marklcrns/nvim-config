-- Patch nvim-treesitter's set-lang-from-info-string! directive to handle
-- Neovim 0.12+ where match values are TSNode[] arrays instead of single nodes.
-- nvim-treesitter is archived and won't ship this fix upstream.
-- Runs immediately at load time (after/plugin fires after plugins load)
-- AND on LazyDone to catch any re-registration.

local function apply_patch()
  local query = vim.treesitter.query
  if not query or not query.add_directive then return end

  -- Inline the markdown info-string → language mapping (lowercase + strip
  -- leading whitespace). Avoids require("nvim-treesitter.query") which
  -- eagerly loads the whole nvim-treesitter plugin and adds ~30ms to startup.
  local function get_lang(alias)
    return alias:lower():match("^%s*(%S+)") or alias
  end

  query.add_directive("set-lang-from-info-string!", function(match, _, bufnr, pred, metadata)
    local capture_id = pred[2]
    local node = match[capture_id]
    if not node then return end
    -- Nvim 0.12+: match values may be TSNode[] arrays instead of single nodes
    if type(node) == "table" and not vim.is_callable(node) then
      node = node[1]
    end
    if not node or not vim.is_callable(node.range) then return end
    local text = vim.treesitter.get_node_text(node, bufnr)
    if not text then return end
    metadata["injection.language"] = get_lang(text)
  end, { force = true, all = false })
end

-- Apply immediately (after/plugin runs after all plugins are sourced)
apply_patch()

-- Re-apply after LazyDone in case lazy re-sources the plugin
vim.api.nvim_create_autocmd("User", {
  pattern = "LazyDone",
  once = true,
  callback = apply_patch,
})
