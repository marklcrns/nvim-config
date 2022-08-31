-- local cmp = require("cmp")
-- local cmp_ultisnips_mappings = require("cmp_nvim_ultisnips.mappings")
-- require("cmp").setup({
--   -- recommended configuration for <Tab> people:
--   mapping = {
--     ["<Tab>"] = cmp.mapping(
--       function(fallback)
--         cmp_ultisnips_mappings.expand_or_jump_forwards(fallback)
--       end,
--       { "i", "s" }
--     ),
--     ["<S-Tab>"] = cmp.mapping(
--       function(fallback)
--         cmp_ultisnips_mappings.jump_backwards(fallback)
--       end,
--       { "i", "s" }
--     ),
--   },
-- })

require("cmp_nvim_ultisnips").setup {
  filetype_source = "treesitter",
  show_snippets = "all",
  documentation = function(snippet)
    return snippet.value
  end
}
