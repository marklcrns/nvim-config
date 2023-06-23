return function()
  local wk = require("which-key")

  wk.setup({
    key_labels = {
      -- override the label used to display some keys. It doesn't effect WK in any other way.
      -- For example:
      ["<space>"] = "␣",
      ["<cr>"] = "↵",
      ["<tab>"] = "⇆",
      ["<S-tab>"] = "S⇆",
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
      i = { "j", "k", "f" },
      v = { "j", "k", "f", "d", "y" },
      n = { "j", "k", "f", "d", "y" },
    },
  })

  wk.register({
    a = {
      name = "+ai",
    },
    c = {
      name = "+code",
      m = {
        name = "+markdown",
      },
      t = {
        name = "+trouble",
      },
      u = {
        name = "+ui",
      },
    },
    d = {
      name = "+documentation",
    },
    e = {
      name = "+explorer",
    },
    f = {
      name = "+file-manager",
      d = {
        name = "+finder",
        l = {
          name = "+lsp",
        },
        g = {
          name = "+git",
        },
      },
    },
    g = {
      name = "+git",
      c = {
        name = "+commit",
      },
      h = {
        name = "+hunk",
        t = {
          name = "+toggle",
        },
      },
    },
    h = {
      name = "+harpoon",
    },
    i = {
      name = "+ui-interface",
      d = {
        name = "+diff",
      },
    },
    l = {
      name = "+lsp",
    },
    p = {
      name = "+plugin-manager",
    },
    r = {
      name = "+text-editting",
      a = {
        name = "+align",
      },
      m = {
        name = "+muren",
      },
    },
    w = {
      name = "+window-manager",
    },
  }, { prefix = "<leader>" })

  wk.register({
    n = {
      name = "+notetaker",
      n = {
        name = "+neorg",
        f = {
          name = "+finder",
        },
        j = {
          name = "+journal",
        },
        m = {
          name = "+navigation-modes",
        },
      },
      w = {
        name = "+vimwiki",
      },
    },
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
  }, { prefix = "<localleader>" })
end
