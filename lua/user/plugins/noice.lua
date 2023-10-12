return function()
  require("noice").setup({
    lsp = {
      -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
      override = {
        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
        ["vim.lsp.util.stylize_markdown"] = true,
        ["cmp.entry.get_documentation"] = true,
      },
      signature = {
        enabled = false,
      },
    },
    -- you can enable a preset for easier configuration
    presets = {
      bottom_search = false, -- use a classic bottom cmdline for search
      command_palette = true, -- position the cmdline and popupmenu together
      long_message_to_split = true, -- long messages will be sent to a split
      inc_rename = true, -- enables an input dialog for inc-rename.nvim
      lsp_doc_border = false, -- add a border to hover docs and signature help
    },
    messages = {
      enabled = false, -- enables the Noice messages UI
    },
    views = {
      cmdline_popup = {
        border = {
          style = "none",
          padding = { 1, 2 },
        },
        filter_options = {},
        win_options = {
          winhighlight = "NormalFloat:NormalFloat,FloatBorder:FloatBorder",
        },
      },
    },
    notify = {
      -- Noice can be used as `vim.notify` so you can route any notification like other messages
      -- Notification messages have their level and other properties set.
      -- event is always "notify" and kind can be any log level as a string
      -- The default routes will forward notifications to nvim-notify
      -- Benefit of using Noice for this is the routing and consistent history view
      enabled = true,
      view = "notify",
    },
  })
end
