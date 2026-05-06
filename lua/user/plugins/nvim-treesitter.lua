return function()
  -- Map filetypes to TS parsers
  for ft, parser in pairs({
    handlebars = "glimmer",
  }) do
    vim.treesitter.language.register(ft, parser)
  end

  require("nvim-treesitter.configs").setup({
    -- Only install what has been seen at least once
    -- ensure_installed = "all", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
    auto_install = true,
    highlight = {
      enable = true,
      additional_vim_regex_highlighting = true,
      disable = function(lang, bufnr)
        local kb = Config.common.utils.buf_get_size(bufnr)

        if kb > 320 then return true end

        return vim.tbl_contains({
          -- "vim",
          -- "help",
          -- "markdown", -- NOTE: Parser seems immature. Revisit later.
          -- "c", -- NOTE: Performance is abysmal in files of any notable length.
          -- "cpp",
          "latex",
          "comment",
          "haxe",
        }, lang)
      end,
    },
    indent = {
      enable = true,
      disable = {
        -- NOTE: This cause some issues with `gw` (format line) in normal mode not
        -- being properly indented in markdown files bullet points
        "markdown",
      }
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
      enable = false, -- Disabled: nvim-treesitter archived, query_predicates incompatible with Nvim 0.13-dev
    },
    -- Plugin: nvim-treesitter-endwise
    endwise = {
      enable = false,
    },
  })

  -- Patch nvim-treesitter's set-lang-from-info-string! directive.
  -- Neovim 0.12+ changed match values to TSNode[] arrays, but the archived
  -- nvim-treesitter still treats them as single nodes — causing
  -- "attempt to call method 'range' (a nil value)" on markdown with fenced
  -- code blocks. Applied here (after setup) so it overrides the broken
  -- handler nvim-treesitter registered during require('nvim-treesitter').
  do
    local query = vim.treesitter.query
    if query and query.add_directive then
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
        metadata["injection.language"] = (text:lower():match("^%s*(%S+)") or text)
      end, { force = true, all = false })
    end
  end
end
