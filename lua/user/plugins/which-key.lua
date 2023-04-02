return function()
  local wk = require("which-key")

  wk.setup({
    icons = {
      breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
      separator = "  ", -- symbol used between a key and it's label
      group = "+", -- symbol prepended to a group
    },

    popup_mappings = {
      scroll_down = "<c-d>", -- binding to scroll down inside the popup
      scroll_up = "<c-u>", -- binding to scroll up inside the popup
    },

    window = {
      border = "none", -- none/single/double/shadow
    },

    layout = {
      spacing = 6, -- spacing between columns
    },

    hidden = { "<silent>", "<cmd>", "<Cmd>", "<CR>", "call", "lua", "^:", "^ " },

    triggers_blacklist = {
      -- list of mode / prefixes that should never be hooked by WhichKey
      i = { "j", "k" },
      v = { "j", "k" },
    },
  })

  wk.register({
    c = {
      name = "+code",
    },
    e = {
      name = "+explorer",
    },
    f = {
      name = "+file-manager",
      d = {
        name = "+finder",
        g = {
          name = "+git",
        },
      },
    },
    g = {
      name = "+git",
    },
    i = {
      name = "+ui-interface",
      d = {
        name = "+diff",
      },
    },
    p = {
      name = "+plugin-manager",
    },
  }, { prefix = "<leader>" })

  wk.register({
    s = {
      name = "+settings-toggle",
      d = {
        name = "+diminactive",
      },
      l = {
        name = "+lsp",
        d = {
          name = "+diagnostics",
        },
      },
    },
  }, { prefix = "<LocalLeader>" })
end
