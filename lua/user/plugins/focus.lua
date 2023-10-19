return function()
  require("focus").setup({
    enable = true, -- Enable module
    commands = true, -- Create Focus commands
    autoresize = {
      -- enable = Config.common.sys.is_gui(),
      enable = true, -- Enable or disable auto-resizing of splits
      width = 0, -- Force width for the focused window
      height = 0, -- Force height for the focused window
      minwidth = 0, -- Force minimum width for the unfocused window
      minheight = 0, -- Force minimum height for the unfocused window
      height_quickfix = 10, -- Set the height of quickfix panel
    },
    split = {
      bufnew = false, -- Create blank buffer for new split windows
      tmux = false, -- Create tmux splits instead of neovim splits
    },
    ui = {
      number = true, -- Display line numbers in the focussed window only
      relativenumber = false, -- Display relative line numbers in the focussed window only
      hybridnumber = true, -- Display hybrid line numbers in the focussed window only
      absolutenumber_unfocussed = true, -- Preserve absolute numbers in the unfocussed windows

      -- Covered in core/filetype.vim
      cursorline = false, -- Display a cursorline in the focussed window only
      cursorcolumn = false, -- Display cursorcolumn in the focussed window only
      colorcolumn = {
        enable = true, -- Display colorcolumn in the foccused window only
        list = "+1", -- Set the comma-saperated list for the colorcolumn
      },
      signcolumn = true, -- Display signcolumn in the focussed window only
      winhighlight = false, -- Auto highlighting for focussed/unfocussed windows
    },
  })

  -- FileType/BufType to ignore

  local ignore_filetypes = {
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
  }
  local ignore_buftypes = {
    "help",
    "nofile",
    "nofile",
    "packer",
    "popup",
    "prompt",
    "terminal",
  }

  local augroup = vim.api.nvim_create_augroup("FocusDisable", { clear = true })

  vim.api.nvim_create_autocmd("WinEnter", {
    group = augroup,
    callback = function(_)
      if vim.tbl_contains(ignore_buftypes, vim.bo.buftype) then
        vim.w.focus_disable = true
      else
        vim.w.focus_disable = false
      end
    end,
    desc = "Disable focus autoresize for BufType",
  })

  vim.api.nvim_create_autocmd("FileType", {
    group = augroup,
    callback = function(_)
      if vim.tbl_contains(ignore_filetypes, vim.bo.filetype) then
        vim.w.focus_disable = true
      else
        vim.w.focus_disable = false
      end
    end,
    desc = "Disable focus autoresize for FileType",
  })
end
