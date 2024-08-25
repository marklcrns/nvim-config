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
    ignore_install = {
      "luap",
    },
    highlight = {
      enable = true,
      additional_vim_regex_highlighting = true,
      disable = function(lang, bufnr)
        local kb = Config.common.utils.buf_get_size(bufnr)

        if kb > 320 then return true end

        return vim.tbl_contains({
          -- "vim",
          -- "help",
          "c", -- NOTE: Performance is abysmal in files of any notable length.
          "cpp",
          "latex",
          "comment",
        }, lang)
      end,
    },
    indent = {
      enable = true,
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
end
