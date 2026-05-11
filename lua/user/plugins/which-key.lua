return function()
  local wk = require("which-key")

  wk.setup({})

  -- Group descriptions for which-key popup hints.
  --
  -- Sourced from lua/user/core/mappings.lua (single source of truth) plus
  -- inline `desc = "..."` entries declared by plugins in plugins/init.lua.
  -- Only prefixes with ≥2 child keys are declared as groups; single-key
  -- mappings use `desc = "..."` on the mapping itself.
  wk.add({
    -- ─── <leader> groups ─────────────────────────────────────────────────────
    { "<leader>a",         group = "ai" },
    { "<leader>c",         group = "code" },
    { "<leader>cd",        group = "documentation" },
    { "<leader>cm",        group = "markdown" },
    { "<leader>ct",        group = "trouble" },
    { "<leader>d",         group = "debugger" },
    { "<leader>e",         group = "explorer" },
    { "<leader>f",         group = "file" },
    { "<leader>fd",        group = "finder" },
    { "<leader>fdg",       group = "finder: git" },
    { "<leader>fdl",       group = "finder: lsp" },
    { "<leader>fr",        group = "root dir" },
    { "<leader>fy",        group = "yank file path" },
    { "<leader>g",         group = "git" },
    { "<leader>gc",        group = "commit" },
    { "<leader>gh",        group = "hunk" },
    { "<leader>ght",       group = "hunk: toggle" },
    { "<leader>G",         desc  = "grep operator" },
    { "<leader>h",         group = "harpoon" },
    { "<leader>i",         group = "ui interface" },
    { "<leader>im",        group = "minimap" },
    { "<leader>l",         group = "lsp" },
    { "<leader>m",         group = "misc" },
    { "<leader>mc",        group = "cellular automaton" },
    { "<leader>o",         group = "open external" },
    { "<leader>p",         group = "plugin manager" },
    { "<leader>r",         group = "text edit", mode = { "n", "v", "x" } },
    { "<leader>ra",        group = "align" },
    { "<leader>raa",       group = "align after" },
    { "<leader>rc",        group = "text case" },
    { "<leader>rca",       group = "case: cursor & rename" },
    { "<leader>rce",       group = "case: operator" },
    { "<leader>re",        group = "register" },
    { "<leader>rm",        group = "muren" },
    { "<leader>rt",        group = "search & replace" },
    { "<leader>ry",        group = "yank file" },
    { "<leader>s",         group = "session" },
    { "<leader>t",         group = "tools", mode = { "n", "v" } },
    { "<leader>ta",        group = "tools: ai" },
    { "<leader>td",        group = "tools: diff", mode = { "n", "v" } },
    { "<leader>tr",        group = "tools: repl" },
    { "<leader>ts",        group = "tools: code runner", mode = { "n", "v" } },
    { "<leader>w",         group = "web dev" },
    { "<leader>wr",        group = "rest client" },
    { "<leader>z",         desc  = "toggle fold" },
    { "<leader>Z",         desc  = "focus current fold" },

    -- ─── <leader><leader> ────────────────────────────────────────────────────
    { "<leader><leader>",  group = "swap splits" },

    -- ─── <localleader> groups ────────────────────────────────────────────────
    { "<localleader>b",    group = "buffer manager" },
    { "<localleader>bo",   group = "buffer: open all" },
    { "<localleader>n",    group = "notetaker" },
    { "<localleader>nn",   group = "neorg" },
    { "<localleader>nnf",  group = "neorg: finder" },
    { "<localleader>nnj",  group = "neorg: journal" },
    { "<localleader>no",   group = "obsidian" },
    { "<localleader>o",    group = "open UI" },
    { "<localleader>ol",   group = "loclist" },
    { "<localleader>oq",   group = "quickfix" },
    { "<localleader>s",    group = "settings toggle" },
    { "<localleader>sd",   group = "diminactive" },
    { "<localleader>sl",   group = "settings: lsp" },
    { "<localleader>t",    group = "tab manager" },
    { "<localleader>w",    group = "window splits" },
  })
end
