return function()
  require("lualine").setup({
    options = {
      theme = "auto", -- follows :colorscheme; lualine reloads on ColorScheme
      icons_enabled = true,
      component_separators = { left = "", right = "" },
      section_separators  = { left = "", right = "" },
      globalstatus = vim.o.laststatus == 3,
      disabled_filetypes = {
        statusline = {
          "alpha",
          "dashboard",
          "lazy",
          "mason",
          "neo-tree",
          "TelescopePrompt",
          "TelescopeResults",
          "Outline",
          "trouble",
          "DiffviewFiles",
          "DiffviewFileHistory",
          "DiffviewFHOptionPanel",
          "NeogitStatus",
          "NeogitCommitMessage",
          "qf",
        },
        winbar = {},
      },
      ignore_focus = {},
      always_divide_middle = true,
      refresh = {
        statusline = 1000,
        tabline    = 1000,
        winbar     = 1000,
      },
    },
    sections = {
      lualine_a = {
        { "mode", fmt = function(s) return s:sub(1, 6) end },
      },
      lualine_b = {
        { "branch", icon = "" },
        {
          "diff",
          symbols = { added = " ", modified = " ", removed = " " },
        },
      },
      lualine_c = {
        {
          "diagnostics",
          sources = { "nvim_diagnostic" },
          symbols = {
            error = " ",
            warn  = " ",
            info  = " ",
            hint  = " ",
          },
          update_in_insert = false,
        },
        {
          "filename",
          path = 1, -- 0 = just filename, 1 = relative, 2 = absolute
          symbols = {
            modified = "[]",
            readonly = "[]",
            unnamed  = "[No Name]",
            newfile  = "[New]",
          },
        },
      },
      lualine_x = {
        -- All active LSP clients (comma-joined) — preserves feline's
        -- multi-client display instead of lualine's default first-only.
        {
          function()
            local clients = vim.lsp.get_clients({ bufnr = 0 })
            if not next(clients) then return "" end
            return table.concat(vim.tbl_map(function(c) return c.name end, clients), ",")
          end,
          icon = "",
          cond = function()
            return next(vim.lsp.get_clients({ bufnr = 0 })) ~= nil
          end,
        },
        { "encoding" },
        { "fileformat" },
        { "filetype",  icon_only = false },
      },
      lualine_y = { "progress" },
      lualine_z = { "location" },
    },
    inactive_sections = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = {
        {
          "filename",
          path = 1,
          symbols = {
            modified = "[]",
            readonly = "[]",
            unnamed  = "[No Name]",
          },
        },
      },
      lualine_x = { "location" },
      lualine_y = {},
      lualine_z = {},
    },
    tabline = {},
    winbar = {},
    inactive_winbar = {},
    extensions = {
      "fugitive",
      "neo-tree",
      "quickfix",
      "lazy",
      "mason",
      "trouble",
      "man",
    },
  })
end
