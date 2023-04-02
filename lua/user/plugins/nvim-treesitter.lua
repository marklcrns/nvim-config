return function()
  require("nvim-treesitter.configs").setup({
    ensure_installed = "all", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
    auto_install = true,
    -- ignore_install = { "javascript" }, -- List of parsers to ignore installing
    highlight = {
      enable = true,
      disable = function(lang, bufnr)
        local kb = Config.common.utils.buf_get_size(bufnr)

        if kb > 320 then
          return true
        end

        return vim.tbl_contains({
          "tex",
          "latex",
          "plaintex",
        }, lang)
      end,

      -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
      -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
      -- Using this option may slow down your editor, and you may see some duplicate highlights.
      -- Instead of true it can also be a list of languages
      additional_vim_regex_highlighting = false,
    },

    -- Defined in nvim-treesitter-textobjects
    -- textobjects = {
    --   select = {
    --     enable = true,
    --     keymaps = {
    --       -- You can use the capture groups defined in textobjects.scm
    --       ["af"] = "@function.outer",
    --       ["if"] = "@function.inner",
    --       ["ac"] = "@class.outer",
    --       ["ic"] = "@class.inner",
    --     },
    --   },
    -- },

    -- Plugin: nvim-treesitter-textsubjects
    textsubjects = {
      enable = true,
      prev_selection = ";", -- (Optional) keymap to select the previous selection
      keymaps = {
        ["<cr>"] = "textsubjects-smart",
      },
    },
    -- Plugin: vim-matchup
    matchup = {
      enable = true, -- mandatory, false will disable the whole extension
      -- disable = { "c", "ruby" },  -- optional, list of language that will be disabled
    },
    -- Plugin: nvim-treesitter-endwise
    endwise = {
      enable = true,
    },
  })

  vim.api.nvim_command("set foldmethod=expr")
  vim.api.nvim_command("set foldexpr=nvim_treesitter#foldexpr()")

  -- -- ref: https://github.com/skbolton/titan/commit/e9a348f3795bf36481463b97490d3cc1fd94fa77
  -- -- Override markdown conceal to show fenced code block_quote_marker
  -- require("vim.treesitter.query").set_query(
  --   "markdown",
  --   "highlights",
  --   [[
  -- ;From MDeiml/tree-sitter-markdown
  -- (atx_heading (inline) @text.title)
  -- (setext_heading (paragraph) @text.title)
  -- [
  --   (atx_h1_marker)
  --   (atx_h2_marker)
  --   (atx_h3_marker)
  --   (atx_h4_marker)
  --   (atx_h5_marker)
  --   (atx_h6_marker)
  --   (setext_h1_underline)
  --   (setext_h2_underline)
  -- ] @punctuation.special
  -- [
  --   (link_title)
  --   (indented_code_block)
  --   (fenced_code_block)
  -- ] @text.literal
  -- [
  --   (fenced_code_block_delimiter)
  -- ] @punctuation.delimiter
  -- (code_fence_content) @none
  -- [
  --   (link_destination)
  -- ] @text.uri
  -- [
  --   (link_label)
  -- ] @text.reference
  -- [
  --   (list_marker_plus)
  --   (list_marker_minus)
  --   (list_marker_star)
  --   (list_marker_dot)
  --   (list_marker_parenthesis)
  --   (thematic_break)
  -- ] @punctuation.special
  -- [
  --   (block_continuation)
  --   (block_quote_marker)
  -- ] @punctuation.special
  -- [
  --   (backslash_escape)
  -- ] @string.escape
  -- ]]
  -- )
end