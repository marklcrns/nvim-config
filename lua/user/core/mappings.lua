-- n, v, i, t = mode names

local M = {}

local default_opts = {
  noremap = true,
  silent = true,
  nowait = true,
}

-- GENERAL MAPPINGS

M.general = {
  i = {
    -- Misc
    -- ["<Tab>"] = { "<cmd>lua Config.lib.full_indent()<CR>", "indent", opts = default_opts },
  },

  n = {
    -- UI
    ["<A-S-D>"] = { "<cmd>lua Config.fn.toggle_diagnostics()<CR>", "toggle diagnostics", opts = default_opts },
    ["<C-M-o>"] = { "<cmd>lua Config.fn.toggle_outline()<CR>", "toggle outline", opts = default_opts },
    ["<M-CR>"] = { "<cmd>lua Config.fn.update_messages_win()<CR>", "open messages win", opts = default_opts },
    ["<M-q>"] = { "<cmd>lua Config.fn.toggle_quickfix()<CR>", "toggle quickfix", opts = default_opts },

    -- LSP
    ["gd"] = {
      "<cmd>lua vim.lsp.buf.definition()<CR>",
      "goto definition",
      opts = {
        noremap = false,
        silent = true,
      },
    },
    ["gD"] = {
      "<cmd>lua vim.lsp.buf.declaration()<CR>",
      "goto declaration",
      opts = {
        noremap = false,
        silent = true,
      },
    },
    ["gy"] = {
      "<cmd>lua vim.lsp.buf.type_definition()<CR>",
      "goto type definition",
      opts = { noremap = false, silent = true },
    },
    ["gi"] = {
      "<cmd>lua vim.lsp.buf.implementation()<CR>",
      "goto implementation",
      opts = { noremap = false, silent = true },
    },
    ["<leader>."] = { "<cmd>lua vim.lsp.buf.code_action()<CR>", "code action", opts = default_opts },
    ["<leader>cf"] = { "<cmd>lua vim.lsp.buf.format({ async = true })<CR>", "code format async", opts = default_opts },
    ["<leader>cr"] = { "<cmd>lua vim.lsp.buf.rename()<CR>", "code rename", opts = default_opts },

    -- Seek motions
    ["[d"] = {
      "<cmd>exe 'lua vim.diagnostic.goto_prev({ float = false })'<CR>zz",
      "prev diagnostics",
      opts = default_opts,
    },
    ["]d"] = {
      "<cmd>exe 'lua vim.diagnostic.goto_next({ float = false })'<CR>zz",
      "next diagnostics",
      opts = default_opts,
    },
    ["[q"] = { "<cmd>cp<CR>zz", "prev quickfix", opts = default_opts },
    ["]q"] = { "<cmd>cn<CR>zz", "next quickfix", opts = default_opts },
    ["[l"] = { "<cmd>cp<CR>zz", "prev loclist", opts = default_opts },
    ["]l"] = { "<cmd>cn<CR>zz", "next loclist", opts = default_opts },
    ["[r"] = {
      [[v:lua.Config.lib.expr.next_reference(v:true)]],
      "prev reference",
      opts = { expr = true, noremap = true, silent = true },
    },
    ["]r"] = {
      [[v:lua.Config.lib.expr.next_reference()]],
      "next reference",
      opts = { expr = true, noremap = true, silent = true },
    },

    -- Misc
    ["<F10>"] = { "<cmd>lua require'user.lib'.print_syn_group()<CR>", "show cursor hi group", opts = default_opts },

    -- Terminal
    ["<C-\\>"] = { "<cmd>TermToggle<CR>", "toggle terminal", opts = default_opts },
  },

  v = {
    -- LSP
    ["<leader>."] = { ":lua vim.lsp.buf.range_code_action()<CR>", "code action range", opts = default_opts },
    ["<leader>cf"] = {
      "<Esc><cmd>lua vim.lsp.buf.format({ range = {} })<CR>",
      "code format range",
      opts = default_opts,
    },
    -- Misc
    ["@"] = { ":<C-u>lua Config.lib.execute_macro_over_visual_range()<CR>", "execute macro range", opts = default_opts },
  },

  t = {
    -- Terminal
    ["<C-\\>"] = { "<cmd>TermToggle<CR>", "toggle terminal", opts = default_opts },
    ["<C-M-l>"] = {
      "<C-a><C-k>clear<CR><cmd>setl scrollback=1 so=0 <bar> setl scrollback=10000 so<<CR>",
      "clear terminal",
      default_opts,
    },
  },
}

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

-- PLUGIN MAPPINGS

M.abolish = {
  plugin = true,

  n = {
    ["<leader>rs"] = { ":<C-u>%Subvert//g<Left><Left>", "subvert /{pat}/{sub}/[flags]", opts = default_opts },
    ["<leader>rp"] = {
      "yap}pV`[v`]:Subvert//g<bar>norm`.$<Left><Left><Left><Left><Left><Left><Left><Left><Left><Left>",
      "duplicate block and subvert /{pat}/{sub}/[flags]",
      opts = default_opts,
    },
  },
  v = {
    ["<leader>rs"] = { ":Subvert//g<Left><Left>", "subvert", opts = default_opts },
    ["<leader>rp"] = {
      "y`]p`[v`]:Subvert//g<Left><Left>",
      "duplicate select subvert /{pat}/{sub}/[flags]",
      opts = default_opts,
    },
  },
}

M.cellular_automaton = {
  plugin = true,

  n = {
    ["<leader>mcm"] = { "<cmd>CellularAutomaton make_it_rain<CR>", "make it rain animation", opts = default_opts },
    ["<leader>mcg"] = { "<cmd>CellularAutomaton game_of_life<CR>", "game of life animation", opts = default_opts },
  },
}

M.chatgpt = {
  plugin = true,

  n = {
    ["<leader>ac"] = { "<cmd>ChatGPT<CR>", "open ChatGPT", opts = default_opts },
  },

  v = {
    ["<leader>ac"] = {
      function()
        require("chatgpt").edit_with_instructions()
      end,
      "ChatGPT edit with instructions",
      opts = default_opts,
    },
  },
}

M.codewindow = {
  plugin = true,

  n = {
    ["<leader>imm"] = {
      "<cmd>lua require('codewindow').toggle_minimap()<CR>",
      "toggle minimap window",
      opts = default_opts,
    },
    ["<leader>imf"] = {
      "<cmd>lua require('codewindow').toggle_focus()<CR>",
      "toggle minimap focus",
      opts = default_opts,
    },
  },
}

M.colorizer = {
  plugin = true,

  n = {
    ["<localleader>sx"] = { "<cmd>ColorizerToggle<CR>", "toggle colorizer", opts = default_opts },
  },
}

M.dial = {
  plugin = true,

  n = {
    ["<C-a>"] = { [[<Plug>(dial-increment)]], "increment next", opts = { noremap = false, silent = true } },
    ["<C-x>"] = { [[<Plug>(dial-decrement)]], "decrement next", opts = { noremap = false, silent = true } },
  },
  v = {
    ["<C-a>"] = { [[<Plug>(dial-increment)]], "increment next", opts = { noremap = false, silent = true } },
    ["<C-x>"] = { [[<Plug>(dial-decrement)]], "decrement next", opts = { noremap = false, silent = true } },
    ["g<C-a>"] = { [[g<Plug>(dial-increment)]], "increment next", opts = { noremap = false, silent = true } },
    ["g<C-x>"] = { [[g<Plug>(dial-decrement)]], "decrement next", opts = { noremap = false, silent = true } },
  },
}

M.diffview = {
  plugin = true,

  n = {
    ["<leader>idd"] = { "<cmd>DiffviewOpen<CR>", "diff git", opts = default_opts },
    ["<leader>idf"] = { "<cmd>DiffviewFileHistory %<CR>", "diff buffer unsaved", opts = default_opts },
  },
}

M.dropbar = {
  plugin = true,

  n = {
    ["<leader>fdd"] = { "<cmd>lua require('dropbar.api').pick()<CR>", "toggle dropbar picker", opts = default_opts },
  },
}

M.focus = {
  plugin = true,

  n = {
    ["<localleader>sf"] = { "<cmd>FocusToggle<CR>", "toggle focus", opts = default_opts },
    ["<C-w>z"] = { "<cmd>FocusMaxOrEqual<CR>", "toggle maximize-equalize", opts = default_opts },
  },
}

M.frecency = {
  plugin = true,

  n = {
    ["<leader>fdo"] = { "<cmd>Telescope frecency<CR>", "find frecency", opts = default_opts },
  },
}

M.fugitive = {
  plugin = true,

  n = {
    ["<leader>gg"] = {
      "<cmd>lua Config.plugin.fugitive.status_open('tab', { use_last = true })<CR>",
      "git status last tab",
      opts = default_opts,
    },
    ["<leader>gs"] = {
      "<cmd>lua Config.plugin.fugitive.status_open('split')<CR>",
      "git status",
      opts = default_opts,
    },
    ["<leader>gl"] = {
      "<cmd>exe 'Flogsplit -max-count=256' <bar> wincmd J<CR>",
      "git log",
      opts = default_opts,
    },
    ["<leader>gL"] = {
      function()
        vim.fn.execute("Flogsplit -path=" .. vim.fn.fnamemodify(vim.fn.expand("%"), ":~:."))
      end,
      "git log current buffer",
      opts = default_opts,
    },
    ["<leader>ga"] = {
      "<cmd>silent exe '!git add %' <bar> lua Config.common.notify.git('Staged ' .. Config.common.utils.str_quote(pl:vim_expand('%:.')))<CR>",
      "git add buffer",
      opts = default_opts,
    },
    ["<leader>gA"] = {
      "<cmd>silent exe '!git add .' <bar>lua Config.common.notify.git('Staged ' .. Config.common.utils.str_quote(pl:vim_fnamemodify('.', ':~')))<CR> ",
      "git add all",
      opts = default_opts,
    },
    ["<leader>gcc"] = {
      "<cmd>Git commit <bar> wincmd J<CR>",
      "git commit",
      opts = default_opts,
    },
    ["<leader>gca"] = {
      "<cmd>Git commit --amend <bar> wincmd J<CR>",
      "git commit --amend",
      opts = default_opts,
    },
    ["<leader>gC"] = {
      "<cmd>Git commit -a <bar> wincmd J<CR>",
      "git commit",
      opts = default_opts,
    },
    ["<leader>gb"] = {
      "<cmd>Git blame <bar> wincmd p<CR>",
      "git blame",
      opts = default_opts,
    },
    ["<leader>go"] = {
      "<cmd>GBrowse<CR>",
      "open git repo in browser",
      opts = default_opts,
    },
    ["<leader>gd"] = {
      "<cmd>DiffviewOpen<CR>",
      "git diff",
      opts = default_opts,
    },
  },
}

M.gitignore = {
  plugin = true,

  n = {
    ["<leader>gi"] = { "<cmd>Gitignore<CR>", "generate gitignore", opts = default_opts },
  },
}

M.gitsigns = {
  plugin = true,

  n = {
    ["<Leader>ghb"] = {
      "<cmd>lua require'gitsigns'.blame_line{full=true}<CR>",
      "git blame hunk cursor",
      opts = default_opts,
    },
    ["<Leader>ghd"] = { "<cmd>Gitsigns diffthis<CR>", "git diff hunk", opts = default_opts },
    ["<Leader>ghD"] = { "<cmd>lua require'gitsigns'.diffthis('~')<CR>", "git diff hunk", opts = default_opts },
    ["<Leader>ghp"] = { "<cmd>Gitsigns preview_hunk<CR>", "git preview hunk", opts = default_opts },
    ["<Leader>ghr"] = { "<cmd>Gitsigns reset_hunk<CR>", "git reset hunk", opts = default_opts },
    ["<Leader>ghR"] = { "<cmd>Gitsigns reset_buffer<CR>", "git reset entire buffer", opts = default_opts },
    ["<Leader>ghs"] = { "<cmd>Gitsigns stage_hunk<CR>", "git stage hunk", opts = default_opts },
    ["<Leader>ghu"] = { "<cmd>Gitsigns undo_stage_hunk<CR>", "git undo stage hunk", opts = default_opts },
    ["<Leader>ghtb"] = {
      "<cmd>Gitsigns toggle_current_line_blame<CR>",
      "git toggle blame current line",
      opts = default_opts,
    },
    ["<Leader>ghtd"] = { "<cmd>Gitsigns toggle_deleted<CR>", "git toggle show deleted hunk", opts = default_opts },
    ["]c"] = {
      function()
        if vim.wo.diff then
          vim.cmd("norm! ]c")
        else
          require("gitsigns").next_hunk({ wrap = false })
        end
      end,
      "next git hunk",
    },
    ["[c"] = {
      function()
        if vim.wo.diff then
          vim.cmd("norm! [c")
        else
          require("gitsigns").prev_hunk({ wrap = false })
        end
      end,
      "prev git hunk",
    },
  },

  v = {
    ["<Leader>ghr"] = { ":Gitsigns reset_hunk<CR>", "git reset hunk", opts = default_opts },
    ["<Leader>ghs"] = { ":Gitsigns stage_hunk<CR>", "git stage hunk", opts = default_opts },
    ["ih"] = { ":<C-U>Gitsigns select_hunk<CR>", "git select hunk", opts = default_opts },
  },
}

M.hardtime = {
  plugin = true,

  n = {
    ["<LocalLeader>sh"] = { "<cmd>Hardtime toggle<CR>", "toggle hardtime", opts = default_opts },
  },
}

M.harpoon = {
  plugin = true,

  n = {
    ["<Leader>ha"] = { "<cmd>lua require('harpoon.mark').add_file()<CR>", "mark file", opts = default_opts },
    ["<Leader>hf"] = {
      "<cmd>lua require('harpoon.ui').toggle_quick_menu()<CR>",
      "quick menu toggle",
      opts = default_opts,
    },
    ["<Leader>hh"] = { "<cmd>lua require('harpoon.ui').nav_prev()<CR>", "navigate to prev mark", opts = default_opts },
    ["<Leader>hl"] = { "<cmd>lua require('harpoon.ui').nav_next()<CR>", "navigate to next mark", opts = default_opts },
    ["<leader>fdh"] = { "<cmd>Telescope harpoon marks<CR>", "find harpoon marks", opts = default_opts },
  },
}

M.hlslens = {
  plugin = true,
  n = {
    ["n"] = {
      [[<cmd>execute('normal! ' . v:count1 . 'nzz')<CR><cmd>lua require('hlslens').start()<CR>]],
      "next search fancy",
      opts = default_opts,
    },
    ["N"] = {
      [[<cmd>execute('normal! ' . v:count1 . 'Nzz')<CR><cmd>lua require('hlslens').start()<CR>]],
      "previous search fancy",
      opts = default_opts,
    },
    ["*"] = { [[*<cmd>lua require('hlslens').start()<CR>]], "start search fancy", opts = default_opts },
    ["#"] = { [[#<cmd>lua require('hlslens').start()<CR>]], "start search fancy", opts = default_opts },
    ["g*"] = { [[g*<cmd>lua require('hlslens').start()<CR>]], "start search fancy", opts = default_opts },
    ["g#"] = { [[g#<cmd>lua require('hlslens').start()<CR>]], "start search fancy", opts = default_opts },
  },
}

M.inc_rename = {
  plugin = true,

  n = {
    ["<leader>rn"] = {
      function()
        return ":IncRename " .. vim.fn.expand("<cword>")
      end,
      "incremental rename",
      opts = { expr = true, noremap = true, silent = true },
    },
  },
}

M.leetbuddy = {
  plugin = true,

  n = {
    ["<leader>ilq"] = { "<cmd>LBQuestion<CR>", "close leetbuddy", opts = default_opts },
    ["<leader>ilv"] = { "<cmd>LBQuestion<CR>", "view question", opts = default_opts },
    ["<leader>ill"] = { "<cmd>LBQuestions<CR>", "list all questions", opts = default_opts },
    ["<leader>ilr"] = { "<cmd>LBReset<CR>", "reset code", opts = default_opts },
    ["<leader>ils"] = { "<cmd>LBSubmit<CR>", "submit code", opts = default_opts },
    ["<leader>ilt"] = { "<cmd>LBTest<CR>", "test code", opts = default_opts },
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
    ["<leader>lr"] = { "<cmd>LspRestart<CR>", "restart LSP", opts = default_opts },
    ["<leader>ls"] = { "<cmd>LspStart<CR>", "start LSP", opts = default_opts },
  },
}

M.markdown_preview = {
  plugin = true,

  n = {
    ["<leader>cmp"] = { "<cmd>MarkdownPreviewToggle<CR>", "toggle markdown preview", opts = default_opts },
  },
}

M.markdown_toc = {
  plugin = true,

  n = {
    ["<leader>cmt"] = { "<cmd>GenTocGFM<CR>", "generate markdown TOC GFM style", opts = default_opts },
  },
}

M.mason = {
  plugin = true,

  n = {
    ["<leader>lp"] = { "<cmd>Mason<CR>", "open LSP installer", opts = default_opts },
  },
}

M.muren = {
  plugin = true,

  n = {
    ["<leader>rmm"] = { "<cmd>MurenToggle<CR>", "toggle multiple search/replace", opts = default_opts },
    ["<leader>rmu"] = { "<cmd>MurenUnique<CR>", "open unique multiple search/replace", opts = default_opts },
    ["<leader>rmr"] = { "<cmd>MurenFresh<CR>", "open new multiple search/replace", opts = default_opts },
  },
}

M.neogen = {
  plugin = true,

  n = {
    ["<Leader>cdc"] = {
      "<cmd>lua require('neogen').generate({ type = 'class' })<CR>",
      "generate class docs",
      opts = default_opts,
    },
    ["<Leader>cdf"] = {
      "<cmd>lua require('neogen').generate({ type = 'func' })<CR>",
      "generate function docs",
      opts = default_opts,
    },
    ["<Leader>cdt"] = {
      "<cmd>lua require('neogen').generate({ type = 'type' })<CR>",
      "generate type docs",
      opts = default_opts,
    },
    ["<Leader>cdp"] = {
      "<cmd>lua require('neogen').generate({ type = 'file' })<CR>",
      "generate file docs",
      opts = default_opts,
    },
    ["<Leader>cdd"] = { "<cmd>lua require('neogen').generate()<CR>", "generate docs", opts = default_opts },
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

M.neorg = {
  plugin = true,

  n = {
    ["<LocalLeader>nnw"] = { "<cmd>Neorg index<CR>", "open default workspace index", opts = default_opts },
    ["<LocalLeader>nnjj"] = { "<cmd>Neorg journal today<CR>", "open workspace journal today", opts = default_opts },
    ["<LocalLeader>nnjJ"] = { "<cmd>Neorg journal toc<CR>", "open workspace journal toc", opts = default_opts },
    ["<LocalLeader>nnjo"] = {
      "<cmd>Neorg journal toc<CR>",
      "open workspace journal index",
      opts = default_opts,
    },
    ["<LocalLeader>nnjt"] = {
      "<cmd>Neorg journal tomorrow<CR>",
      "open workspace journal tomorrow",
      opts = default_opts,
    },
    ["<LocalLeader>nnjy"] = {
      "<cmd>Neorg journal yesterday<CR>",
      "open workspace journal yesterday",
      opts = default_opts,
    },
  },
}

M.neorg_telescope = {
  plugin = true,

  n = {
    ["<LocalLeader>nnff"] = { "<cmd>Telescope neorg find_norg_files<CR>", "find files", opts = default_opts },
    ["<LocalLeader>nnfh"] = {
      "<cmd>Telescope neorg search_headings<CR>",
      "find neorg buffer headings",
      opts = default_opts,
    },
    ["<LocalLeader>nnfl"] = { "<cmd>Telescope neorg find_linkable<CR>", "find linkables", opts = default_opts },
    ["<LocalLeader>nnfi"] = { "<cmd>Telescope neorg insert_link<CR>", "insert link", opts = default_opts },
    ["<LocalLeader>nnfI"] = {
      "<cmd>Telescope insert_file_link<CR>",
      "insert neorg file link",
      opts = default_opts,
    },
    ["<LocalLeader>nnfw"] = {
      "<cmd>Telescope neorg switch_workspace<CR>",
      "switch neorg workspace",
      opts = default_opts,
    },
  },
}

M.niceblock = {
  plugin = true,

  v = {
    ["I"] = { [[<Plug>(niceblock-I)]], "niceblock I", opts = default_opts },
    ["gI"] = { [[<Plug>(niceblock-gI)]], "niceblock gI", opts = default_opts },
    ["A"] = { [[<Plug>(niceblock-A)]], "niceblock A", opts = default_opts },
  },
}

M.nvim_dap = {
  plugin = true,
  n = {
    ["<F5>"] = { "<cmd>lua require('dap').continue()<CR>", "debugger run/continue", opts = default_opts },
    ["<F10>"] = { "<cmd>lua require('dap').step_over()<CR>", "debugger step over", opts = default_opts },
    ["<F11>"] = { "<cmd>lua require('dap').step_into()<CR>", "debugger step into", opts = default_opts },
    ["<F12>"] = { "<cmd>lua require('dap').step_out()<CR>", "debugger step out", opts = default_opts },
    ["<Leader>db"] = {
      "<cmd>lua require('dap').toggle_breakpoint()<CR>",
      "toggle line breakpoint",
      opts = default_opts,
    },
    ["<Leader>dB"] = { "<cmd>lua require('dap').clear_breakpoints()<CR>", "clear all breakpoint", opts = default_opts },
    ["<Leader>dc"] = { "<cmd>lua require('dap').continue()<CR>", "run/continue <F5>", opts = default_opts },
    ["<Leader>dC"] = { "<cmd>lua require('dap').reverse_continue()<CR>", "reverse continue", opts = default_opts },
    ["<Leader>dh"] = {
      "<cmd>lua require('dapui').eval(vim.call('expand','<cword>'), {enter=true})<CR>",
      "evaluate word under cursor",
      opts = default_opts,
    },
    ["<Leader>dl"] = { "<cmd>lua require('dap').run_last()<CR>", "run last debug init", opts = default_opts },
    ["<Leader>di"] = { "<cmd>lua require('dap').step_into()<CR>", "step into <F11>", opts = default_opts },
    ["<Leader>do"] = { "<cmd>lua require('dap').step_out()<CR>", "step out <F12>", opts = default_opts },
    ["<Leader>dO"] = { "<cmd>lua require('dap').step_over()<CR>", "step over <F10>", opts = default_opts },
    ["<Leader>dr"] = { "<cmd>lua require('dap').repl.open()<CR>", "open REPL", opts = default_opts },
    ["<Leader>dq"] = { "<cmd>lua require('dap').terminate()<CR>", "close debugger", opts = default_opts },
  },
}

M.nvim_dap_ui = {
  plugin = true,
  n = {
    ["<Leader>dd"] = { "<cmd>lua require('dapui').toggle()<CR>", "toggle debugger UI", opts = default_opts },
  },
}

M.nvim_window_picker = {
  plugin = true,

  n = {
    ["<C-w>f"] = {
      function()
        local picked_window_id = require("window-picker").pick_window({ hint = "floating-big-letter" })
          or vim.api.nvim_get_current_win()
        vim.api.nvim_set_current_win(picked_window_id)
      end,
      "pick window",
    },
  },
}

M.regexplainer = {
  plugin = true,

  n = {
    ["<leader>cx"] = { "<cmd>RegexplainerToggle<CR>", "toggle regexplainer under cursor", opts = default_opts },
  },
}

M.smartq = {
  plugin = true,

  n = {
    ["<leader>fq"] = { "<cmd>SmartQSave<CR>", "smart save and quit" },
    ["<leader>wq"] = { "<cmd>SmartQCloseSplits<CR>", "close all splits" },
    ["q"] = { [[<Plug>(smartq_this)]], "smart quit", opts = { noremap = false, silent = true } },
  },
}

M.SmoothCursor = {
  plugin = true,

  n = {
    ["<LocalLeader>sc"] = { "<cmd>SmoothCursorToggle<CR>", "toggle SmoothCursor", opts = default_opts },
  },
}

M.spectre = {
  plugin = true,

  n = {
    ["<leader>rtt"] = { "<cmd>lua require('spectre').toggle()<CR>", "toggle spectre", opts = default_opts },
    ["<leader>rtw"] = {
      "<cmd>lua require('spectre').open_visual({select_word=true})<CR>",
      "search current word",
      opts = default_opts,
    },
    ["<leader>rtf"] = {
      "<cmd>lua require('spectre').open_file_search({select_word=true})<CR>",
      "search on current file",
      opts = default_opts,
    },
  },

  v = {
    ["<leader>rtw"] = {
      "<esc><cmd>lua require('spectre').open_visual()<CR>",
      "search current word",
      opts = default_opts,
    },
  },
}

M.symbols_outline = {
  plugin = true,

  n = {
    ["<leader>cO"] = { "<cmd>SymbolsOutline<CR>", "toggle code outline", opts = default_opts },
  },
}

M.tabular = {
  plugin = true,

  n = {
    ["<leader>ra\\"] = { "<cmd>Tabularize /\\\\\\<CR>", "tabularize \\", opts = default_opts },
    ["<leader>ra/"] = { "<cmd>Tabularize ////<CR>", "tabularize //", opts = default_opts },
    ["<leader>ra|"] = { "<cmd>Tabularize /|<CR>", "tabularize |", opts = default_opts },
    ["<leader>ra&"] = { "<cmd>Tabularize /&<CR>", "tabularize &", opts = default_opts },
    ["<leader>ra,"] = { "<cmd>Tabularize /,\zs<CR>", "tabularize ,", opts = default_opts },
    ["<leader>ra:"] = { "<cmd>Tabularize /:\zs<CR>", "tabularize :", opts = default_opts },
    ["<leader>ra<Space>"] = { "<cmd>Tabularize /\\s\\+<CR>", "tabularize spaces", opts = default_opts },
    ["<leader>ra="] = { "<cmd>Tabularize /=<CR>", "tabularize =", opts = default_opts },
    ["<leader>ra{"] = { "<cmd>Tabularize /{<CR>", "tabularize {", opts = default_opts },
  },
  v = {
    ["<leader>ra\\"] = { ":Tabularize /\\\\\\<CR>", "tabularize \\", opts = default_opts },
    ["<leader>ra/"] = { ":Tabularize ////<CR>", "tabularize //", opts = default_opts },
    ["<leader>ra|"] = { ":Tabularize /|<CR>", "tabularize |", opts = default_opts },
    ["<leader>ra&"] = { ":Tabularize /&<CR>", "tabularize &", opts = default_opts },
    ["<leader>ra,"] = { ":Tabularize /,\zs<CR>", "tabularize ,", opts = default_opts },
    ["<leader>ra:"] = { ":Tabularize /:\zs<CR>", "tabularize :", opts = default_opts },
    ["<leader>ra<Space>"] = { ":Tabularize /\\s\\+<CR>", "tabularize spaces", opts = default_opts },
    ["<leader>ra="] = { ":Tabularize /=<CR>", "tabularize =", opts = default_opts },
    ["<leader>ra{"] = { ":Tabularize /{<CR>", "tabularize {", opts = default_opts },
  },
}

M.telescope = {
  plugin = true,

  n = {
    -- LSP
    ["z="] = { "<cmd>Telescope spell_suggest theme=get_cursor<CR>", "spell suggest cursor" },
    ["gr"] = { "<cmd>Telescope lsp_references<CR>", "find cursor reference" },
    -- Telescope
    ["<leader>fdb"] = { "<cmd>Telescope buffers<CR>", "find buffers", opts = default_opts },
    ["<leader>fdc"] = { "<cmd>Telescope commands<CR>", "find commands", opts = default_opts },
    ["<leader>fdf"] = { "<cmd>Telescope find_files<CR>", "find files", opts = default_opts },
    -- Replaced by harpoon marks
    -- ["<leader>fdh"] = { "<cmd>Telescope help_tags<CR>", "find help tags", opts = default_opts },
    ["<leader>fdi"] = { "<cmd>Telescope media_files<CR>", "find images", opts = default_opts },
    ["<leader>fdj"] = { "<cmd>Telescope jumplist<CR>", "find jumplist", opts = default_opts },
    ["<leader>fdk"] = { "<cmd>Telescope keymaps<CR>", "find keymappings", opts = default_opts },
    ["<leader>fdm"] = { "<cmd>Telescope marks<CR>", "find marks", opts = default_opts },
    ["<leader>fdn"] = { "<cmd>Telescope notify<CR>", "find notification", opts = default_opts },
    -- Replaced by telescope-frecency
    -- ["<leader>fdo"] = { "<cmd>Telescope oldfiles<CR>", "find oldfiles", opts = default_opts },
    ["<leader>fdp"] = { "<cmd>Telescope projects<CR>", "find projects", opts = default_opts },
    ["<leader>fdr"] = { "<cmd>Telescope live_grep<CR>", "find word", opts = default_opts },
    ["<leader>fds"] = { "<cmd>Telescope grep_string<CR>", "find string grep", opts = default_opts },
    ["<leader>fdS"] = {
      "<cmd>Telescope current_buffer_fuzzy_find<CR>",
      "find string grep in buffer",
      opts = default_opts,
    },
    ["<leader>fdz"] = { "<cmd>Telescope colorscheme<CR>", "pick colorscheme", opts = default_opts },
    ["<leader>fdu"] = { "<cmd>Telescope undo<CR>", "find undo", opts = default_opts },
    ["<leader>fdlo"] = { "<cmd>Telescope lsp_document_symbols<CR>", "find lsp doc symbols", opts = default_opts },
    ["<leader>fdlO"] = {
      "<cmd>Telescope lsp_dynamic_workspace_symbols<CR>",
      "find lsp workspace symbols",
      opts = default_opts,
    },
    ["<leader>fdld"] = { "<cmd>Telescope diagnostics<CR>", "find lsp doc diagnostics", opts = default_opts },
    ["<leader>fdgC"] = { "<cmd>Telescope git_bcommits<CR>", "find git branch commits", opts = default_opts },
    ["<leader>fdgb"] = { "<cmd>Telescope git_branches<CR>", "find git branches", opts = default_opts },
    ["<leader>fdgc"] = { "<cmd>Telescope git_commits<CR>", "find git commits", opts = default_opts },
    ["<leader>fdgf"] = { "<cmd>Telescope git_files<CR>", "find git files", opts = default_opts },
    ["<leader>fdgs"] = { "<cmd>Telescope git_status<CR>", "find git status", opts = default_opts },
  },
}

M.text_case = {
  n = {
    ["<leader>rcau"] = {
      "<cmd>lua require('textcase').current_word('to_upper_case')<CR>",
      "TO UPPER CASE",
      opts = default_opts,
    },
    ["<leader>rcal"] = {
      "<cmd>lua require('textcase').current_word('to_lower_case')<CR>",
      "to lower case",
      opts = default_opts,
    },
    ["<leader>rcas"] = {
      "<cmd>lua require('textcase').current_word('to_snake_case')<CR>",
      "to_snake_case",
      opts = default_opts,
    },
    ["<leader>rca-"] = {
      "<cmd>lua require('textcase').current_word('to_dash_case')<CR>",
      "to-dash-case",
      opts = default_opts,
    },
    ["<leader>rcan"] = {
      "<cmd>lua require('textcase').current_word('to_constant_case')<CR>",
      "TO_CONSTANT_CASE",
      opts = default_opts,
    },
    ["<leader>rca."] = {
      "<cmd>lua require('textcase').current_word('to_dot_case')<CR>",
      "to.dot.case",
      opts = default_opts,
    },
    ["<leader>rcaa"] = {
      "<cmd>lua require('textcase').current_word('to_phrase_case')<CR>",
      "To phrase case",
      opts = default_opts,
    },
    ["<leader>rcac"] = {
      "<cmd>lua require('textcase').current_word('to_camel_case')<CR>",
      "toCamelCase",
      opts = default_opts,
    },
    ["<leader>rcap"] = {
      "<cmd>lua require('textcase').current_word('to_pascal_case')<CR>",
      "ToPascalCase",
      opts = default_opts,
    },
    ["<leader>rcat"] = {
      "<cmd>lua require('textcase').current_word('to_title_case')<CR>",
      "To Title Case",
      opts = default_opts,
    },
    ["<leader>rca/"] = {
      "<cmd>lua require('textcase').current_word('to_path_case')<CR>",
      "to/path/case",
      opts = default_opts,
    },

    ["<leader>rcaU"] = {
      "<cmd>lua require('textcase').lsp_rename('to_upper_case')<CR>",
      "TO UPPER CASE",
      opts = default_opts,
    },
    ["<leader>rcaL"] = {
      "<cmd>lua require('textcase').lsp_rename('to_lower_case')<CR>",
      "to lower case",
      opts = default_opts,
    },
    ["<leader>rcaS"] = {
      "<cmd>lua require('textcase').lsp_rename('to_snake_case')<CR>",
      "to_snake_case",
      opts = default_opts,
    },
    ["<leader>rca_"] = {
      "<cmd>lua require('textcase').lsp_rename('to_dash_case')<CR>",
      "to-dash-case",
      opts = default_opts,
    },
    ["<leader>rcaN"] = {
      "<cmd>lua require('textcase').lsp_rename('to_constant_case')<CR>",
      "toConstantCase",
      opts = default_opts,
    },
    ["<leader>rca>"] = {
      "<cmd>lua require('textcase').lsp_rename('to_dot_case')<CR>",
      "to.dot.case",
      opts = default_opts,
    },
    ["<leader>rcaA"] = {
      "<cmd>lua require('textcase').lsp_rename('to_phrase_case')<CR>",
      "To phrase case",
      opts = default_opts,
    },
    ["<leader>rcaC"] = {
      "<cmd>lua require('textcase').lsp_rename('to_camel_case')<CR>",
      "toCamelCase",
      opts = default_opts,
    },
    ["<leader>rcaP"] = {
      "<cmd>lua require('textcase').lsp_rename('to_pascal_case')<CR>",
      "ToPascalCase",
      opts = default_opts,
    },
    ["<leader>rcaT"] = {
      "<cmd>lua require('textcase').lsp_rename('to_title_case')<CR>",
      "To Title Case",
      opts = default_opts,
    },
    ["<leader>rca?"] = {
      "<cmd>lua require('textcase').lsp_rename('to_path_case')<CR>",
      "to/path/case",
      opts = default_opts,
    },

    ["<leader>rceu"] = {
      "<cmd>lua require('textcase').operator('to_upper_case')<CR>",
      "TO UPPER CASE",
      opts = default_opts,
    },
    ["<leader>rcel"] = {
      "<cmd>lua require('textcase').operator('to_lower_case')<CR>",
      "to lower case",
      opts = default_opts,
    },
    ["<leader>rces"] = {
      "<cmd>lua require('textcase').operator('to_snake_case')<CR>",
      "to_snake_case",
      opts = default_opts,
    },
    ["<leader>rce-"] = {
      "<cmd>lua require('textcase').operator('to_dash_case')<CR>",
      "to-dash-case",
      opts = default_opts,
    },
    ["<leader>rcen"] = {
      "<cmd>lua require('textcase').operator('to_constant_case')<CR>",
      "TO_CONSTANT_CASE",
      opts = default_opts,
    },
    ["<leader>rce."] = {
      "<cmd>lua require('textcase').operator('to_dot_case')<CR>",
      "to.dot.case",
      opts = default_opts,
    },
    ["<leader>rcea"] = {
      "<cmd>lua require('textcase').operator('to_phrase_case')<CR>",
      "To phrase case",
      opts = default_opts,
    },
    ["<leader>rcec"] = {
      "<cmd>lua require('textcase').operator('to_camel_case')<CR>",
      "toCamelCase",
      opts = default_opts,
    },
    ["<leader>rcep"] = {
      "<cmd>lua require('textcase').operator('to_pascal_case')<CR>",
      "ToPascalCase",
      opts = default_opts,
    },
    ["<leader>rcet"] = {
      "<cmd>lua require('textcase').operator('to_title_case')<CR>",
      "To Title Case",
      opts = default_opts,
    },
    ["<leader>rce/"] = {
      "<cmd>lua require('textcase').operator('to_path_case')<CR>",
      "to/path/case",
      opts = default_opts,
    },
  },
}

M.tint = {
  plugin = true,

  n = {
    ["<localleader>sd"] = { "<cmd>lua require('tint').toggle()<CR>", "toggle diminactive", opts = default_opts },
  },
}

M.todo_comments = {
  plugin = true,

  n = {
    ["<leader>fdt"] = { "<cmd>TodoTelescope<CR>", "find todo comments", opts = default_opts },
    ["<leader>ctT"] = { "<cmd>TodoTrouble<CR>", "toggle todo quickfix", opts = default_opts },
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

M.transparent = {
  plugin = true,

  n = {
    ["<localleader>st"] = { "<cmd>TransparentToggle<CR>", "toggle transparent bg", opts = default_opts },
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

M.true_zen = {
  plugin = true,

  n = {
    ["<localleader>szn"] = { "<cmd>TZNarrow<CR>", "toggle true zen narrow", opts = default_opts },
    ["<localleader>szf"] = { "<cmd>TZFocus<CR>", "toggle true zen focus", opts = default_opts },
    ["<localleader>szm"] = { "<cmd>TZMinimalist<CR>", "toggle true zen minimalist", opts = default_opts },
    ["<localleader>sza"] = { "<cmd>TZAtaraxis<CR>", "toggle true zen ataraxis", opts = default_opts },
  },

  v = {
    ["<localleader>szn"] = { ":'<,'>TZNarrow<CR>", "toggle true zen narrow", opts = default_opts },
  },
}

M.spider = {
  plugin = true,

  n = {
    ["w"] = { "<cmd>lua require('spider').motion('w')<CR>", "spider-w", opts = default_opts },
    ["e"] = { "<cmd>lua require('spider').motion('e')<CR>", "spider-e", opts = default_opts },
    ["b"] = { "<cmd>lua require('spider').motion('b')<CR>", "spider-b", opts = default_opts },
    ["ge"] = { "<cmd>lua require('spider').motion('ge')<CR>", "spider-ge", opts = default_opts },
  },

  o = {
    ["w"] = { "<cmd>lua require('spider').motion('w')<CR>", "spider-w", opts = default_opts },
    ["e"] = { "<cmd>lua require('spider').motion('e')<CR>", "spider-e", opts = default_opts },
    ["b"] = { "<cmd>lua require('spider').motion('b')<CR>", "spider-b", opts = default_opts },
    ["ge"] = { "<cmd>lua require('spider').motion('ge')<CR>", "spider-ge", opts = default_opts },
  },

  x = {
    ["w"] = { "<cmd>lua require('spider').motion('w')<CR>", "spider-w", opts = default_opts },
    ["e"] = { "<cmd>lua require('spider').motion('e')<CR>", "spider-e", opts = default_opts },
    ["b"] = { "<cmd>lua require('spider').motion('b')<CR>", "spider-b", opts = default_opts },
    ["ge"] = { "<cmd>lua require('spider').motion('ge')<CR>", "spider-ge", opts = default_opts },
  },
}

M.trouble = {
  plugin = true,

  n = {
    ["<leader>ctt"] = { "<cmd>TroubleToggle<CR>", "toggle trouble", opts = default_opts },
    ["<leader>ctw"] = { "<cmd>TroubleToggle workspace_diagnostics<CR>", "toggle workspace", opts = default_opts },
    ["<leader>ctd"] = { "<cmd>TroubleToggle document_diagnostics<CR>", "toggle document", opts = default_opts },
    ["<leader>ctl"] = { "<cmd>TroubleToggle loclist<CR>", "toggle loclist", opts = default_opts },
    ["<leader>ctq"] = { "<cmd>TroubleToggle quickfix<CR>", "toggle quickfix", opts = default_opts },
    ["<leader>ctr"] = { "<cmd>TroubleToggle lsp_references<CR>", "toggle references", opts = default_opts },
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
    ["<C-w>m"] = { "<cmd>WinShift<CR>", "", opts = default_opts },
  },
}

M.you_autocorrect = {
  plugin = true,

  n = {
    ["<localleader>sa"] = { "<cmd>call ToggleAutoCorrect()<CR>", "toggle autocorrect", opts = default_opts },
  },
}

M.zen_mode = {
  plugin = true,

  n = {
    ["<localleader>sz"] = { "<cmd>ZenMode<CR>", "toggle zen mode", opts = default_opts },
  },
}

return M
