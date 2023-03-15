require("dashboard").setup({
  theme = "hyper",
  disable_move = true,
  config = {
    week_header = {
      enable = true,
    },
    packages = { enable = true },
    shortcut = {
      {
        icon = "",
        icon_hl = "@variable",
        desc = "New file",
        group = "@property",
        action = "enew",
        key = "e",
      },
      {
        icon = "",
        icon_hl = "@variable",
        desc = "Find",
        group = "@property",
        action = "Telescope find_files",
        key = "f",
      },
      {
        icon = "",
        icon_hl = "@variable",
        desc = "Git Status",
        group = "@property",
        action = "Neogit",
        key = "g",
      },
      {
        icon = "",
        icon_hl = "@variable",
        desc = "Open Session",
        group = "@property",
        action = "Telescope session-lens search_session",
        key = "s",
      },
      {
        icon = "",
        icon_hl = "@variable",
        desc = "Restore Session",
        group = "@property",
        action = "RestoreSession",
        key = "r",
      },
      {
        icon = "",
        icon_hl = "@variable",
        desc = "Start Session",
        group = "@property",
        action = "SaveSession",
        key = "S",
      },
      {
        icon = "",
        icon_hl = "@variable",
        desc = "Update",
        group = "@property",
        action = "call dein#update() | TSUpdate",
        key = "u",
      },
      {
        icon = "",
        icon_hl = "@variable",
        desc = "Check Health",
        group = "@property",
        action = "checkhealth",
        key = "x",
      },
      {
        icon = "",
        icon_hl = "@variable",
        desc = "Quit",
        group = "@property",
        action = "SmartQ",
        key = "q",
      },
    },
  },

  -- theme = "doom",
  -- config = {
  --   header = {
  --     "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
  --     "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣀⣼⣿⣦⢀⡐⠀⠀ ⠀⠀⠀⠀⠀⠀⠀⠀⠀",
  --     "⠀⠀⠀⠀⠀⠀⠠⢀⠠⢚⡉⠘⢰⣾⣿⣿⣿⣷⠀⠈⢈⠒⢀⠀⠀⠀⠀⠀⠀⠀⠀",
  --     "⠀⠀⠀⠀⢀⠠⠈⠑⣄⣠⠽⣰⣿⢿⣾⢾⣿⢻⣿⣰⠯⣀⣨⠋⢀⢀ ⠀⠀⠀⠀",
  --     "⠀⠀⢀⢠⠈⠈⢶⣔⠉⢳⣴⣿⣻⢰⢽⢼⠯⢼⢻⣿⣦⠾⠹⣠⠶⠁⠑⣀⡀⠀⠀",
  --     "⠀⠀⣀⠉⠐⣶⣉⣨⢻⣾⣿⠹⢤⢞⢸⢸⢏⡺⢼⢩⢿⣶⠛⢁⣩⣴⠊⢉⢀⠀⠀",
  --     "⠀⠨⢁⠒⢴⣭⣰⣉⣿⣟⢶⣴⣾⣾⣿⣿⣿⣿⣶⣬⠺⣻⣽⣉⣠⣬⡶⠒⠘⠀⠀",
  --     " ⢾⠴⠤⣯⣤⣴⣽⣻⣾⣿⠿⣿⠟⣿⣿⣿⢻⡿⠿⣿⣷⣝⣽⣤⢤⣽⠴⢴⢶⠀",
  --     "⠀⣌⣀⣠⣭⣴⣾⢿⢿⣷⣀⢀⠘⣶⣙⢟⣋⣾⠃⢀⣠⣾⣿⢿⣿⣦⣼⣠⣸⣠⠀",
  --     "⠀⢈⠠⢀⣿⣿⣉⣸⢤⢙⣻⢿⣶⣶⣭⣭⣭⣴⣶⠿⢯⢻⢴⣀⣹⢿⣿⡀⠀⠁⠀",
  --     "⠀ ⢡⣿⣾⠙⢙⣠⢜⢤⣰⢋⢾⣝⢹⢻⡟⣫⢵⢸⢼⢼⢺⣠⣩⢻⣾⣿⡘⠀⠀",
  --     "⠀⣰⣿⢿⣾⢿⣾⣿⣾⢿⣿⣾⣾⣾⣿⣾⢿⢾⣾⣿⣿⣿⣾⣿⣷⢿⢿⢿⢾⣄⠀",
  --     "⠀⠀⠀⠀⠨⢊⠠⢀⠾⢠⣠⠞⠀⣰⠐⢰⢀⣲⢀⢺⣐⠜⢶⠀⢀⠱⢀⠀⠀⠀⠀",
  --     "⠀⠀⠀⠀⠀⠀⠨⠒⠠⢀⠟⠀⢹⠉⠀⣿⠘⠸⠉⠀⠻⣐⠀⠒⠀⠀⠀⠀⠀⠀⠀",
  --     "⠀⠀⠀⠀⠀⠀⠀⠀⠀ ⠉⠀⠒⠐⠠⠿⠘⠐⢒⠈⠉⠑⠀⠀⠀⠀⠀⠀⠀⠀⠀",
  --   }, --your header
  --   center = {
  --     {
  --       icon = "  ",
  --       desc = "<f>iles                                 ",
  --       shortcut = "SPC f d f",
  --       action = "Telescope find_files",
  --     },
  --     {
  --       icon = "  ",
  --       desc = "<s>essions                              ",
  --       action = 'call feedkeys(":SeshLoad<Space><Tab>","t")',
  --       shortcut = "SPC s l  ",
  --     },
  --     {
  --       icon = "ﭯ  ",
  --       desc = "<h>istory                               ",
  --       action = "Telescope oldfiles",
  --       shortcut = "SPC f d h",
  --     },
  --     {
  --       icon = "  ",
  --       desc = "<m>arks                                 ",
  --       action = "Telescope marks",
  --       shortcut = "SPC f d m",
  --     },
  --     {
  --       icon = "  ",
  --       desc = "<t>o-Do daily                               ",
  --       action = "call DToday()",
  --       shortcut = "; w T",
  --     },
  --     {
  --       icon = "  ",
  --       desc = "<W>iki                                      ",
  --       action = "VimwikiUISelect",
  --       shortcut = "; W W",
  --     },
  --     {
  --       icon = "  ",
  --       desc = "<n>eorg                                     ",
  --       action = "Neorg workspace main",
  --       shortcut = "; n w",
  --     },
  --   },
  --   footer = {}, --your footer
  -- },
})

-- vim.cmd([[
--   augroup dashboard_enter
--     au!
--     autocmd FileType dashboard noremap <nowait><silent><buffer> e :enew<CR>
--     autocmd FileType dashboard noremap <nowait><silent><buffer> f :Telescope find_files<CR>
--     autocmd FileType dashboard noremap <nowait><silent><buffer> h :Telescope oldfiles<CR>
--     autocmd FileType dashboard noremap <nowait><silent><buffer> m :Telescope marks<CR>
--     autocmd FileType dashboard noremap <nowait><silent><buffer> s :<C-u>call feedkeys(':SeshLoad<Space><Tab>','t')<CR>
--     autocmd FileType dashboard noremap <nowait><silent><buffer> t :call DToday()<CR>
--     autocmd FileType dashboard noremap <nowait><silent><buffer> W :VimwikiUISelect<CR>
--     autocmd FileType dashboard noremap <nowait><silent><buffer> n :Neorg workspace main<CR>
--   augroup END
-- ]])
