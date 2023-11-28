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
      d = {
        name = "+documentation",
      },
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
      name = "+debugger",
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
      l = {
        name = "+leetcode",
      },
      m = {
        name = "+minimap",
      },
      r = {
        name = "+repl",
      },
      s = {
        name = "+code-runner",
      },
    },
    l = {
      name = "+lsp",
    },
    m = {
      name = "+misc",
      c = {
        name = "+cellular-automaton",
      },
    },
    o = {
      name = "+open",
    },
    p = {
      name = "+plugin-manager",
    },
    r = {
      name = "+text-editting",
      a = {
        name = "+align",
        a = {
          name = "+after",
        },
      },
      c = {
        name = "+text-case",
        a = {
          name = "+cursor-and-rename",
        },
        e = {
          name = "+operator",
        },
      },
      e = {
        name = "+register",
      },
      m = {
        name = "+muren",
      },
      t = {
        name = "+search-and-replace",
      },
      y = {
        name = "+yank",
      },
    },
    s = {
      name = "+session",
    },
    w = {
      name = "+web-dev",
      r = {
        name = "+rest",
      },
    },
  }, { prefix = "<leader>" })

  wk.register({
    b = {
      name = "+buffer-manager",
      o = {
        name = "+open",
      },
    },
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
    o = {
      name = "+open-ui",
      l = {
        name = "+locationlist",
      },
      q = {
        name = "+quickfix",
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
    t = {
      name = "+tab-manager",
    },
    w = {
      name = "+window-split-manager",
    },
  }, { prefix = "<localleader>" })
end
