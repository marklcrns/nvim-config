return function()
  require("zen-mode").setup({
    window = {
      backdrop = 0.95,
      width = 120,
      -- width = 120,
      height = 1,
      options = {
        -- signcolumn = 'no', -- disable signcolumn
        -- number = false, -- disable number column
        -- relativenumber = false, -- disable relative numbers
        -- cursorline = false, -- disable cursorline
        -- cursorcolumn = false, -- disable cursor column
        -- foldcolumn = '0', -- disable fold column
        -- list = false, -- disable whitespace characters
      },
    },
    plugins = {
      -- disable some global vim options (vim.o...)
      -- comment the lines to not apply the options
      options = {
        enabled = true,
        ruler = false, -- disables the ruler text in the cmd line area
        showcmd = false, -- disables the command in the last line of the screen
      },
      gitsigns = { enabled = false },
      tmux = { enabled = false },
    },
  })
end
