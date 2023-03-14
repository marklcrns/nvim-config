require("focus").setup({
  enable = true,
  autoresize = true,
  hybridnumber = true,
  signcolumn = true,
  treewidth = 30,
  -- width = vim.api.nvim_get_option("textwidth") + 10,
  -- height = 40,
  -- minwidth = 10,
  -- minheight = 10,
  absolutenumber_unfocussed = true,
  colorcolumn = { enable = true, width = vim.api.nvim_get_option("textwidth") },
  bufnew = true,
  winhighlight = false,
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
  },
  compatible_filetrees = { "neo-tree", "nvim-tree", "nerdtree", "chadtree", "fern" },
  -- Covered in core/filetype.vim
  cursorline = false,
  cursorcolumn = false,
})
