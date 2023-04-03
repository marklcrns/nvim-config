return function()
  require("focus").setup({
    enable = true,
    treewidth = 30,
    signcolumn = true,
    hybridnumber = true,
    number = true,
    absolutenumber_unfocussed = true,
    -- autoresize = Config.common.sys.is_gui(),
    autoresize = true,
    -- width = vim.api.nvim_get_option("textwidth") + 10,
    -- height = 40,
    -- minwidth = 10,
    -- minheight = 10,
    colorcolumn = { enable = true, width = vim.api.nvim_get_option("textwidth") },
    bufnew = false,
    winhighlight = Config.common.sys.is_gui(),
    excluded_filetypes = {
      "NeogitCommitMessage",
      "NeogitStatus",
      "Outline",
      "dap-repl",
      "dapui_breakpoints",
      "dapui_console",
      "dapui_scopes",
      "dapui_stacks",
      "dapui_watches",
      "dashboard",
      "gina-commit",
      "gina-status",
      "help",
      "minimap",
      "qf",
      "toggleterm",
      "lspsagaoutline",
      "lspsagafinder",
      "neo-tree",
      "Trouble",
    },
    compatible_filetrees = { "neo-tree", "nvim-tree", "nerdtree", "chadtree", "fern" },
    -- Covered in core/filetype.vim
    cursorline = false,
    cursorcolumn = false,
  })
end
