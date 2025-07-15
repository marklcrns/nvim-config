return function()
  local wk = require("which-key")

  wk.setup({
    -- key_labels = {
    --   -- override the label used to display some keys. It doesn't effect WK in any other way.
    --   -- For example:
    --   ["<space>"] = "␣",
    --   ["<cr>"] = "↵",
    --   ["<tab>"] = "⇆",
    --   ["<S-tab>"] = "S⇆",
    -- },
    -- popup_mappings = {
    --   scroll_down = "<c-d>", -- binding to scroll down inside the popup
    --   scroll_up = "<c-u>", -- binding to scroll up inside the popup
    -- },
    -- window = {
    --   border = "none", -- none/single/double/shadow
    -- },
    -- layout = {
    --   spacing = 6, -- spacing between columns
    -- },
    -- hidden = { "<silent>", "<cmd>", "<Cmd>", "<CR>", "call", "lua", "^:", "^ " },
    -- triggers_blacklist = {
    --   -- list of mode / prefixes that should never be hooked by WhichKey
    --   i = { "j", "k", "f" },
    --   v = { "j", "k", "f", "d", "y" },
    --   n = { "j", "k", "f", "d", "y" },
    -- },
  })

  -- Using the new add function
  wk.add({
    -- Global
    { "<leader>a", group = "ai" },
    { "<leader>c", group = "code" },
    { "<leader>cd", group = "documentation" },
    { "<leader>cm", group = "markdown" },
    { "<leader>ct", group = "trouble" },
    { "<leader>cu", group = "ui" },
    { "<leader>d", group = "debugger" },
    { "<leader>e", group = "explorer" },
    { "<leader>f", group = "file-manager" },
    { "<leader>fd", group = "finder" },
    { "<leader>fdg", group = "git" },
    { "<leader>fdl", group = "lsp" },
    { "<leader>g", group = "git" },
    { "<leader>gc", group = "commit" },
    { "<leader>gh", group = "hunk" },
    { "<leader>ght", group = "toggle" },
    { "<leader>G", group = "grep-operator" },
    { "<leader>h", group = "harpoon" },
    { "<leader>i", group = "ui-interface" },
    { "<leader>im", group = "minimap" },
    { "<leader>l", group = "lsp" },
    { "<leader>m", group = "misc" },
    { "<leader>mc", group = "cellular-automaton" },
    { "<leader>o", group = "open" },
    { "<leader>p", group = "plugin-manager" },
    { "<leader>r", group = "text-editting" },
    { "<leader>ra", group = "align" },
    { "<leader>raa", group = "after" },
    { "<leader>rc", group = "text-case" },
    { "<leader>rca", group = "cursor-and-rename" },
    { "<leader>rce", group = "operator" },
    { "<leader>re", group = "register" },
    { "<leader>rm", group = "muren" },
    { "<leader>rt", group = "search-and-replace" },
    { "<leader>ry", group = "yank" },
    { "<leader>s", group = "session" },
    { "<leader>t", group = "tools" },
    { "<leader>ta", group = "ai" },
    { "<leader>td", group = "diff" },
    { "<leader>tl", group = "leetcode" },
    { "<leader>tr", group = "repl" },
    { "<leader>ts", group = "code-runner" },
    { "<leader>w", group = "web-dev" },
    { "<leader>wr", group = "rest" },
    { "<leader>z", desc = "toggle fold" },
    { "<leader>Z", desc = "fold all except current" },
    -- LocalLeader
    { "<localleader>b", group = "buffer-manager" },
    { "<localleader>bo", group = "open" },
    { "<localleader>n", group = "notetaker" },
    { "<localleader>nn", group = "neorg" },
    { "<localleader>nnf", group = "finder" },
    { "<localleader>nnj", group = "journal" },
    { "<localleader>nnm", group = "navigation-modes" },
    { "<localleader>no", group = "obsidian" },
    { "<localleader>nw", group = "vimwiki" },
    { "<localleader>o", group = "open-ui" },
    { "<localleader>ol", group = "locationlist" },
    { "<localleader>oq", group = "quickfix" },
    { "<localleader>s", group = "settings-toggle" },
    { "<localleader>sd", group = "diminactive" },
    { "<localleader>sl", group = "lsp" },
    { "<localleader>sld", group = "diagnostics" },
    { "<localleader>t", group = "tab-manager" },
    { "<localleader>w", group = "window-split-manager" },
    -- Visual mode
    {
      mode = { "v" },
      { "<leader>r", group = "text-editting" },
      { "<leader>t", group = "tools" },
      { "<leader>td", group = "diff" },
      { "<leader>ts", group = "code-runner" },
    },
  })

  
end
