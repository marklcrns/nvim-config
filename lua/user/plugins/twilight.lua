return function()
  require("twilight").setup({
    dimming = {
      alpha = 0.60, -- amount of dimming
      color = { "Normal", "#ffffff" }, -- color of the dimmed text
      term_bg = "#000000", -- background color for terminal
      inactive = false, -- whether to dim inactive windows
    },
    context = 20, -- number of lines to show in context
    treesitter = true, -- enable treesitter for context detection
    expand = { "function", "method", "class" }, -- expand context for these nodes
    exclude = {
      "Codewindow",
      "NeogitCommitMessage",
      "NeogitStatus",
      "NvimTree",
      "Outline",
      "TelescopePrompt",
      "Trouble",
      "dap-repl",
      "dapui_breakpoints",
      "dapui_console",
      "dapui_scopes",
      "dapui_stacks",
      "dapui_watches",
      "dashboard",
      "floggraph",
      "gina-commit",
      "gina-status",
      "git",
      "help",
      "lspsagafinder",
      "lspsagaoutline",
      "minimap",
      "neo-tree",
      "qf",
      "toggleterm",
      "dropbar_menu",
      "DiffviewFiles",
      "minifiles",
    }, -- list of filetypes to exclude from twilight
  })
end
