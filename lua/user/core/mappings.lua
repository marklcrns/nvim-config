-- n, v, i, t = mode names

local M = {}

local default_opts = {
  noremap = true,
  silent = true,
  nowait = true,
}

-- GENERAL MAPPING

M.general = {}

-- PLUGIN MAPPING

M.lazy_nvim = {
  n = {
    ["<leader>pU"] = { "<cmd>Lazy update<CR>", "update and lock", opts = default_opts },
    ["<leader>pc"] = { "<cmd>Lazy check<CR>", "check updates", opts = default_opts },
    ["<leader>ph"] = { "<cmd>Lazy health<CR>", "checkhealth plugins", opts = default_opts },
    ["<leader>pl"] = { "<cmd>Lazy log<CR>", "open log", opts = default_opts },
    ["<leader>pp"] = { "<cmd>Lazy profile<CR>", "profile plugins", opts = default_opts },
    ["<leader>pr"] = { "<cmd>Lazy restore<CR>", "restore plugins from lockfile", opts = default_opts },
    ["<leader>pu"] = { "<cmd>Lazy sync<CR>", "install, clean, and update", opts = default_opts },
  },
}

--------------------------------------------------------------------------------

M.dial = {
  plugin = true,

  n = {
    ["<C-a>"] = { "require('dial.map').inc_normal()", "increment next", opts = default_opts },
    ["<C-x>"] = { "require('dial.map').dec_normal()", "decrement next", opts = default_opts },
  },
  v = {
    ["<C-a>"] = { "require('dial.map').inc_visual()", "increment next", opts = default_opts },
    ["<C-x>"] = { "require('dial.map').dec_visual()", "decrement next", opts = default_opts },
    ["g<C-a>"] = { "require('dial.map').inc_gvisual()", "increment next", opts = default_opts },
    ["g<C-x>"] = { "require('dial.map').dec_gvisual()", "decrement next", opts = default_opts },
  },
}

M.diffview = {
  plugin = true,

  n = {
    ["<leader>idd"] = { "<cmd>DiffviewOpen<CR>", "diff git", opts = default_opts },
    ["<leader>idf"] = { "<cmd>DiffviewFileHistory %<CR>", "diff buffer unsaved", opts = default_opts },
  },
}

M.focus = {
  plugin = true,

  n = {
    ["<localleader>sf"] = { "<cmd>FocusToggle<CR>", "toggle window focus", opts = default_opts },
  },
}

M.lens = {
  plugin = true,

  n = {
    ["<localleader>sr"] = { "<cmd>call lens#toggle()<CR>", "toggle auto-resize", opts = default_opts },
  },
}

M.lsp = {
  plugin = true,

  n = {
    ["<leader>lS"] = { "<cmd>LspStop<CR>", "stop LSP", opts = default_opts },
    ["<leader>li"] = { "<cmd>LspInfo<CR>", "open LSP info", opts = default_opts },
    ["<leader>ll"] = { "<cmd>LspLog<CR>", "open LSP log", opts = default_opts },
    ["<leader>ls"] = { "<cmd>LspStart<CR>", "start LSP", opts = default_opts },
    ["<leader>lr"] = { "<cmd>LspRestart<CR>", "stop LSP", opts = default_opts },
  },
}

M.mason = {
  plugin = true,

  n = {
    ["<leader>lp"] = { "<cmd>Mason<CR>", "open LSP installer", opts = default_opts },
  },
}

M.neogit = {
  plugin = true,

  n = {
    ["<leader>gn"] = { "<cmd>Neogit<CR>", "open neogit", opts = default_opts },
  },
}

M.neo_tree = {
  n = {
    ["<leader>ee"] = { "<cmd>Neotree filesystem toggle<CR>", "toggle file explorer", opts = default_opts },
    ["<leader>ef"] = { "<cmd>Neotree filesystem reveal<CR>", "toggle file exprorer focus buffer", opts = default_opts },
    ["<leader>eb"] = { "<cmd>Neotree buffers<CR>", "toggle buffer explorer", opts = default_opts },
    ["<leader>eg"] = { "<cmd>Neotree git_status<CR>", "toggle git status explorer", opts = default_opts },
  },
}

M.nvim_window_picker = {
  plugin = true,

  n = {
    ["<C-w>f"] = {
      function()
        local picked_window_id = require("window-picker").pick_window() or vim.api.nvim_get_current_win()
        vim.api.nvim_set_current_win(picked_window_id)
      end,
      "pick window",
    },
  },
}

M.smartq = {
  plugin = true,

  n = {
    ["<leader>fq"] = { "<cmd>SmartQ<CR>", "smart save and quit" },
    ["<leader>wq"] = { "<cmd>SmartQ<CR>", "close all splits" },
  },
}

M.symbols_outline = {
  plugin = true,

  n = {
    ["<leader>cO"] = { "<cmd>SymbolsOutline<CR>", "toggle code outline", opts = default_opts },
  },
}

M.telescope = {
  plugin = true,

  n = {
    ["<leader>fdb"] = { "<cmd>Telescope buffers<CR>", "find buffers", opts = default_opts },
    ["<leader>fdc"] = { "<cmd>Telescope colorscheme<CR>", "pick colorscheme", opts = default_opts },
    ["<leader>fdf"] = { "<cmd>Telescope find_files<CR>", "find files", opts = default_opts },
    ["<leader>fdg"] = { "<cmd>Telescope grep_string<CR>", "find grep string ", opts = default_opts },
    ["<leader>fdh"] = { "<cmd>Telescope help_tags<CR>", "find help tags", opts = default_opts },
    ["<leader>fdi"] = { "<cmd>Telescope media_files<CR>", "find images", opts = default_opts },
    ["<leader>fdj"] = { "<cmd>Telescope jumplist<CR>", "find jumplist", opts = default_opts },
    ["<leader>fdk"] = { "<cmd>Telescope keymaps<CR>", "find keymappings", opts = default_opts },
    ["<leader>fdm"] = { "<cmd>Telescope marks<CR>", "find marks", opts = default_opts },
    ["<leader>fdn"] = { "<cmd>Telescope notify<CR>", "find notification", opts = default_opts },
    ["<leader>fdr"] = { "<cmd>Telescope oldfiles<CR>", "find oldfiles", opts = default_opts },
    ["<leader>fdp"] = { "<cmd>Telescope projects<CR>", "find projects", opts = default_opts },
    ["<leader>fdu"] = { "<cmd>Telescope ui-select<CR>", "find ui", opts = default_opts },
    ["<leader>fdw"] = { "<cmd>Telescope live_grep<CR>", "find word", opts = default_opts },
    ["<leader>fdgC"] = { "<cmd>Telescope git_bcommits<CR>", "find git branch commits", opts = default_opts },
    ["<leader>fdgb"] = { "<cmd>Telescope git_branches<CR>", "find git branches", opts = default_opts },
    ["<leader>fdgc"] = { "<cmd>Telescope git_commits<CR>", "find git commits", opts = default_opts },
    ["<leader>fdgf"] = { "<cmd>Telescope git_files<CR>", "find git files", opts = default_opts },
    ["<leader>fdgs"] = { "<cmd>Telescope git_status<CR>", "find git status", opts = default_opts },
  },
}

M.toggle_lsp_diagnostics = {
  plugin = true,

  n = {
    ["<localleader>sldd"] = { "<Plug>(toggle-lsp-diag)", "toggle LSP diagnostics", opts = default_opts },
    ["<localleader>sldp"] = {
      "<Plug>(toggle-lsp-diag-update_in_insert)",
      "toggle LSP diagnostics update on insert",
      opts = default_opts,
    },
    ["<localleader>slds"] = { "<Plug>(toggle-lsp-diag-signs)", "toggle LSP diagnostics signs", opts = default_opts },
    ["<localleader>sldu"] = {
      "<Plug>(toggle-lsp-diag-underline)",
      "toggle LSP diagnostics underline",
      opts = default_opts,
    },
    ["<localleader>sldv"] = {
      "<Plug>(toggle-lsp-diag-vtext)",
      "toggle LSP diagnostics virtualtext",
      opts = default_opts,
    },
  },
}

M.treesj = {
  plugin = true,

  n = {
    ["<leader>cs"] = {
      "<cmd>lua require('treesj').toggle({ split = { recursive = true } })<CR>",
      "toggle split/join context",
    },
  },
}

M.vimade = {
  plugin = true,

  n = {
    ["<localleader>sdB"] = { "<cmd>VimadeBufDisable<CR>", "disable dim on buffer", opts = default_opts },
    ["<localleader>sdS"] = { "<cmd>VimadeWinDisable<CR>", "disable dim on split", opts = default_opts },
    ["<localleader>sdb"] = { "<cmd>VimadeBufEnable<CR>", "enable dim on buffer", opts = default_opts },
    ["<localleader>sdd"] = { "<cmd>VimadeToggle<CR>", "toggle diminactive", opts = default_opts },
    ["<localleader>sds"] = { "<cmd>VimadeWinEnable<CR>", "enable dim on split", opts = default_opts },
  },
}

M.vim_mundo = {
  plugin = true,

  n = {
    ["<leader>iu"] = { "<cmd>MundoToggle<CR>", "toggle undo tree", opts = default_opts },
  },
}

M.vimwiki = {
  plugin = true,

  n = {
    ["<localleader>nww"] = { "<cmd>VimwikiUISelect<CR>", "open vimwiki index", opts = default_opts },
    ["<localleader>nwd"] = { "<cmd>VimwikiDiaryIndex<CR>", "open vimwiki diary", opts = default_opts },
    ["<localleader>nwh"] = { "<cmd>Vimwiki2HTML<CR>", "convert vimwiki to html", opts = default_opts },
    ["<localleader>nwH"] = { "<cmd>Vimwiki2HTMLBrowse<CR>", "convert vimwiki to html and browse", opts = default_opts },
    ["<localleader>nwl"] = { "<cmd>VimwikiGenerateLinks<CR>", "generate vimwiki links", opts = default_opts },
  },
}

M.winshift = {
  plugin = true,

  n = {
    ["<C-w>H"] = { "<cmd>WinShift left<CR>", "", opts = default_opts },
    ["<C-w>J"] = { "<cmd>WinShift down<CR>", "", opts = default_opts },
    ["<C-w>K"] = { "<cmd>WinShift up<CR>", "", opts = default_opts },
    ["<C-w>L"] = { "<cmd>WinShift right<CR>", "", opts = default_opts },
    ["<C-w>m"] = { "<cmd>WinShift swap<CR>", "", opts = default_opts },
    ["<C-w>M"] = { "<cmd>WinShift<CR>", "", opts = default_opts },
  },
}

M.zen_mode = {
  plugin = true,

  n = {
    ["<localleader>sz"] = { "<cmd>ZenMode<CR>", "toggle zen mode", opts = default_opts },
  },
}

return M
