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
    ["<C-M-q>"] = { "<cmd>lua Config.fn.toggle_diagnostics()<CR>", "toggle diagnostics", opts = default_opts },
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
    ["<leader>ca"] = { "<cmd>lua vim.lsp.buf.code_action({apply=true})<CR>", "code action", opts = default_opts },
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

    -- Picker
    ["<M-f>"] = { "<cmd>lua require('user.lib').workspace_files()<CR>", "show workspace files", opts = default_opts },
    ["<M-F>"] = { "<cmd>lua require('user.lib').workspace_files({ all = true })<CR>", "show all workspace files", opts = default_opts },
    ["<M-b>"] = { "<cmd>lua Snacks.picker.buffers({ sort_lastused = true })<CR>", "show last used buffers picker", opts = default_opts },
    ["<M-r>"] = { "<cmd>lua Snacks.picker.grep({ hidden = true })<CR>", "show grep picker", opts = default_opts },
    ["<M-O>"] = { "<cmd>lua Snacks.picker.lsp_workspace_symbols()<CR>", "show lsp workspace symbols picker", opts = default_opts },
    ["<M-o>"] = { "<cmd>lua Snacks.picker.lsp_symbols()<CR>", "show lsp symbols picker", opts = default_opts },
    ["<M-d>"] = { "<cmd>lua Snacks.picker.diagnostics_buffer()<CR>", "show diagnostics buffer picker", opts = default_opts },
    ["z="] = { '<cmd>lua Snacks.picker.spelling({ layout = { preset = "select", layout = { relative = "cursor", row = 1, max_width = 45, max_height = 10 } } })<CR>', "show spelling picker", opts = default_opts },
    ["<leader>fl"] = { '<cmd>lua Snacks.picker.lines({ layout = { preset = "ivy", preview = "" } })<CR>', "show lines picker", opts = default_opts },
    [";;"] = { "<cmd>lua Snacks.picker.resume()<CR>", "resume last picker", opts = default_opts },

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
    -- Use "x register to store yanked line(s)
    ["<leader>rp"] = {
      '"xyap}"xpV`[v`]:Subvert//g<bar>norm`.$<Left><Left><Left><Left><Left><Left><Left><Left><Left><Left>',
      "duplicate block and subvert /{pat}/{sub}/[flags]",
      opts = default_opts,
    },
  },
  v = {
    ["<leader>rs"] = { ":Subvert//g<Left><Left>", "subvert", opts = default_opts },
    -- Use "x register to store yanked line(s)
    ["<leader>rp"] = {
      '"xy`]"xp`[v`]:Subvert//g<Left><Left>',
      "duplicate select subvert /{pat}/{sub}/[flags]",
      opts = default_opts,
    },
  },
}

M.amazonq = {
  plugin = true,

  -- TODO: Fix this. The invoke completion works but there is no way to select any suggestions
  i = {
    -- Manually invoke AmazonQ completion (inline-suggestions)
    ["<c-q>"] = {
      function()
        local client = vim.lsp.get_clients({ bufnr = 0, name = 'amazonq-completion' })[1]
        if not client then
          vim.notify('Amazon Q not enabled for this buffer')
          return
        end
        vim.lsp.completion.enable(true, client.id, 0)
        vim.notify('Amazon Q: working...')
        vim.lsp.completion.get()
        -- vim.cmd[[redraw | echo '']]
      end,
      "invoke AmazonQ completion",
      opts = default_opts,
    },
  },

  -- NOTE: You can highlight a text then hit `zq` to bring the selected text to AmazonQ
  n = {
    ["<leader>taq"] = { "<cmd>AmazonQ<CR>", "open AmazonQ", opts = default_opts },
    ["<leader>taa"] = { "<cmd>AmazonQ toggle<CR>", "toggle AmazonQ", opts = default_opts },
    ["<leader>tae"] = { "<cmd>AmazonQ explain<CR>", "explain AmazonQ", opts = default_opts },
    ["<leader>tal"] = { "<cmd>AmazonQ login<CR>", "login AmazonQ", opts = default_opts },
  },
  v = {
    ["<leader>taq"] = { ":AmazonQ<CR>", "open AmazonQ", opts = default_opts },
    ["<leader>taa"] = { ":AmazonQ toggle<CR>", "toggle AmazonQ", opts = default_opts },
    ["<leader>tae"] = { ":AmazonQ explain<CR>", "explain AmazonQ", opts = default_opts },
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

M.conform = {
  plugin = true,

  n = {
    ["<leader>cf"] = {
      function()
        require("conform").format({ async = true }, function(err)
          if not err then
            local mode = vim.api.nvim_get_mode().mode
            if vim.startswith(string.lower(mode), "v") then
              vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", true)
            end
          end
        end)
      end,
      "conform format",
      opts = default_opts,
    },
  },
  v = {
    ["<leader>cf"] = {
      function()
        require("conform").format({ async = true }, function(err)
          if not err then
            local mode = vim.api.nvim_get_mode().mode
            if vim.startswith(string.lower(mode), "v") then
              vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", true)
            end
          end
        end)
      end,
      "conform format",
      opts = default_opts,
    },
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
    ["<leader>tdb"] = { "<cmd>DiffviewFileHistory<CR>", "git diff branch history", opts = default_opts },
    ["<leader>tdd"] = { "<cmd>DiffviewOpen<CR>", "git diff", opts = default_opts },
    ["<leader>tdD"] = {
      "<cmd>call feedkeys(':DiffviewOpen<Space><Tab>','t')<CR>",
      "git diff select",
      opts = default_opts,
    },
    ["<leader>tde"] = { "<cmd>DiffviewToggleFiles<CR>", "git diff toggle file panel", opts = default_opts },
    ["<leader>tdf"] = { "<cmd>DiffviewFileHistory %<CR>", "git diff file history", opts = default_opts },
    ["<leader>tdp"] = {
      "<cmd>DiffviewOpen origin/HEAD...HEAD --imply-local<CR>",
      "git diff pr against base",
      opts = default_opts,
    },
    ["<leader>tdP"] = {
      "<cmd>DiffviewFileHistory --range=origin/HEAD...HEAD --right-only --no-merges<CR>",
      "git diff pr commits against base",
      opts = default_opts,
    },
    ["<leader>tdq"] = { "<cmd>DiffviewClose<CR>", "git diff clost ", opts = default_opts },
    ["<leader>tdr"] = { "<cmd>DiffviewRefresh<CR>", "git diff refresh", opts = default_opts },
    ["<leader>tds"] = { "<cmd>DiffviewFileHistory -g --range=stash<CR>", "git diff stash history", opts = default_opts },
  },
  v = {
    ["<leader>tdf"] = { ":DiffviewFileHistory<CR>", "git diff file range history", opts = default_opts },
  },
}

M.dropbar = {
  plugin = true,

  n = {
    ["<leader>fdd"] = { "<cmd>lua require('dropbar.api').pick()<CR>", "toggle dropbar picker", opts = default_opts },
  },
}

M.fastaction = {
  plugin = true,

  n = {
    ["<leader>ca"] = { "<cmd>lua require('fastaction').code_action()<CR>", "code action", opts = default_opts },
  },

  v = {
    ["<leader>ca"] = { "<cmd>lua require('fastaction').range_code_action()<CR>", "range code action", opts = default_opts },
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
    -- ["<leader>gg"] = {
    --   "<cmd>lua Config.plugin.fugitive.status_open('tab', { use_last = true })<CR>",
    --   "git status last tab",
    --   opts = default_opts,
    -- },
    ["<leader>gs"] = {
      "<cmd>lua Config.plugin.fugitive.status_open('split', { use_last = true })<CR>",
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

  v = {
    ["<leader>go"] = {
      ":GBrowse<CR>",
      "open git repo in browser",
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

M.goto_preview = {
  plugin = true,

  n = {
    -- remove "p" in the mappings
    ["gpd"] = { function() require("goto-preview").goto_preview_definition() end, "goto definition", opts = default_opts, },
    ["gpD"] = { function() require("goto-preview").goto_preview_declaration() end, "goto declaration", opts = default_opts, },
    ["gpy"] = { function() require("goto-preview").goto_preview_type_definition() end, "goto type definition", opts = default_opts, },
    ["gpi"] = { function() require("goto-preview").goto_preview_implementation() end, "goto implementation", opts = default_opts, },
    ["gpr"] = { function() require("goto-preview").goto_preview_references() end, "goto references", opts = default_opts, },
    ["gP"] = { function() require("goto-preview").close_all_win() end, "close all goto preview windows", opts = default_opts, },
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

M.iron = {
  plugin = true,

  n = {
    ["<Leader>trr"] = { "<cmd>IronRepl<CR><Esc><C-w>w", "start REPL", opts = default_opts },
    ["<Leader>trR"] = { "<cmd>IronRestart<CR><Esc><C-w>w", "restart REPL", opts = default_opts },
    ["<Leader>trf"] = { "<cmd>IronFocus<CR>", "focus on REPL", opts = default_opts },
    ["<Leader>trh"] = { "<cmd>IronHide<CR>", "hide REPL", opts = default_opts },
  },
}

M.lens = {
  plugin = true,

  n = {
    ["<localleader>sr"] = { "<cmd>call lens#toggle()<CR>", "toggle auto-resize", opts = default_opts },
  },
}

M.linediff = {
  plugin = true,

  n = {
    ["<leader>tdl"] = { "<cmd>Linediff<CR>", "toggle linediff", opts = default_opts },
  },

  v = {
    ["<leader>tdl"] = { ":Linediff<CR>", "toggle linediff", opts = default_opts },
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

M.markview = {
  plugin = true,

  n = {
    ["<localleader>sm"] = { "<cmd>Markview toggle<CR>", "toggle markview", opts = default_opts },
  },
}

M.mason = {
  plugin = true,

  n = {
    ["<leader>pm"] = { "<cmd>Mason<CR>", "open Mason LSP installer", opts = default_opts },
  },
}

M.mini_files = {
  plugin = true,

  n = {
    ["<leader>ef"] = {
      function()
        require("mini.files").open(vim.api.nvim_buf_get_name(0), true)
      end,
      "open files", opts = default_opts
    },
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
    ["<leader>gg"] = { "<cmd>Neogit<CR>", "open neogit", opts = default_opts },
  },
}

M.neo_tree = {
  n = {
    -- Using mini.files instead here
    -- ["<leader>ee"] = { "<cmd>Neotree filesystem toggle<CR>", "toggle file explorer", opts = default_opts },
    ["<leader>ee"] = { "<cmd>Neotree filesystem reveal<CR>", "toggle file explorer focus buffer", opts = default_opts },
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

  x = {
    ["I"]  = { [[<Plug>(niceblock-I)]],  "niceblock I",  opts = default_opts },
    ["gI"] = { [[<Plug>(niceblock-gI)]], "niceblock gI", opts = default_opts },
    ["A"]  = { [[<Plug>(niceblock-A)]],  "niceblock A",  opts = default_opts },
  },
}

M.winshift = {
  plugin = true,

  n = {
    ["<C-w>H"] = { "<cmd>WinShift left<CR>",  "winshift: far left",  opts = default_opts },
    ["<C-w>J"] = { "<cmd>WinShift down<CR>",  "winshift: far down",  opts = default_opts },
    ["<C-w>K"] = { "<cmd>WinShift up<CR>",    "winshift: far up",    opts = default_opts },
    ["<C-w>L"] = { "<cmd>WinShift right<CR>", "winshift: far right", opts = default_opts },
    ["<C-w>m"] = { "<cmd>WinShift<CR>",       "winshift: mode",      opts = default_opts },
  },
}

M.nvim_notify = {
  plugin = true,

  n = {
    ["<leader><Space>"] = {
      function()
        require("notify").dismiss()
        -- Clear search highlighting
        vim.cmd("nohlsearch")
      end,
      "clear screen", opts = default_opts },
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

M.obsidian = {
  plugin = true,

  n = {
    ["<LocalLeader>noS"] = { "<cmd>ObsidianQuickSwitch<CR>", "quick switch", opts = default_opts },
    ["<LocalLeader>nob"] = { "<cmd>ObsidianBacklinks<CR>", "backlinks", opts = default_opts },
    ["<LocalLeader>non"] = { "<cmd>ObsidianNew<CR>", "new note", opts = default_opts },
    ["<LocalLeader>noo"] = { "<cmd>ObsidianOpen<CR>", "open note", opts = default_opts },
    ["<LocalLeader>nor"] = { ":ObsidianRename ", "rename note", opts = default_opts },
    ["<LocalLeader>nos"] = { "<cmd>ObsidianSearch<CR>", "search notes", opts = default_opts },
    ["<LocalLeader>now"] = { "<cmd>ObsidianWorkspace<CR>", "open workspace", opts = default_opts },
  },

  v = {
    ["<LocalLeader>nol"] = { ":ObsidianLink<CR>", "link text selection", opts = default_opts },
  },
}

M.outline = {
  plugin = true,

  n = {
    ["<leader>cO"] = { "<cmd>Outline<CR>", "toggle outline", opts = default_opts },
  },
}

M.regexplainer = {
  plugin = true,

  n = {
    ["<leader>cx"] = { "<cmd>RegexplainerToggle<CR>", "toggle regexplainer under cursor", opts = default_opts },
  },
}

M.render_markdown = {
  plugin = true,

  n = {
    ["<leader>cmr"] = { "<cmd>RenderMarkdownToggle<CR>", "toggle render markdown", opts = default_opts },
  },
}

M.rest = {
  plugin = true,

  n = {
    ["<leader>wrr"] = { [[<Plug>RestNvim]], "run request under cursor", opts = default_opts },
    ["<leader>wrp"] = { [[<Plug>RestNvimPreview]], "preview request cURL command", opts = default_opts },
    ["<leader>wrl"] = { [[<Plug>RestNvimLast]], "run last request", opts = default_opts },
  },
}

M.smart_splits = {
  plugin = true,

  n = {
    -- Resizing splits
    ["<C-M-h>"] = {
      "<cmd>lua require('smart-splits').resize_left()<CR>",
      "resize split left",
      opts = default_opts
    },
    ["<C-M-j>"] = {
      "<cmd>lua require('smart-splits').resize_down()<CR>",
      "resize split down",
      opts = default_opts
    },
    ["<C-M-k>"] = { 
      "<cmd>lua require('smart-splits').resize_up()<CR>",
      "resize split up",
      opts = default_opts 
    },
    ["<C-M-l>"] = {
      "<cmd>lua require('smart-splits').resize_right()<CR>",
      "resize split right",
      opts = default_opts
    },

    -- Moving between splits
    ["<M-h>"] = {
      "<cmd>lua require('smart-splits').move_cursor_left()<CR>",
      "move to left split",
      opts = default_opts
    },
    ["<M-j>"] = {
      "<cmd>lua require('smart-splits').move_cursor_down()<CR>",
      "move to below split",
      opts = default_opts
    },
    ["<M-k>"] = {
      "<cmd>lua require('smart-splits').move_cursor_up()<CR>",
      "move to above split",
      opts = default_opts
    },
    ["<M-l>"] = {
      "<cmd>lua require('smart-splits').move_cursor_right()<CR>",
      "move to right split",
      opts = default_opts
    },
    ["<M-\\>"] = {
      "<cmd>lua require('smart-splits').move_cursor_previous()<CR>",
      "move to previous split",
      opts = default_opts
    },
    ["<leader><leader>h"] = {
      "<cmd>lua require('smart-splits').swap_buf_left()<CR>",
      "swap with split left",
      opts = default_opts
    },
    ["<leader><leader>j"] = {
      "<cmd>lua require('smart-splits').swap_buf_down()<CR>",
      "swap with split below",
      opts = default_opts
    },
    ["<leader><leader>k"] = {
      "<cmd>lua require('smart-splits').swap_buf_up()<CR>",
      "swap with split above",
      opts = default_opts
    },
    ["<leader><leader>l"] = {
      "<cmd>lua require('smart-splits').swap_buf_right()<CR>",
      "swap with split right",
      opts = default_opts
    },
  }
}

M.smartq = {
  plugin = true,

  n = {
    ["<leader>fq"] = { "<cmd>SmartQSave<CR>", "smart save and quit" },
    ["<localleader>wq"] = { "<cmd>SmartQCloseSplits<CR>", "close all splits" },
    ["q"] = { [[<Plug>(smartq_this)]], "smart quit", opts = { noremap = false, silent = true } },
  },
}

M.SmoothCursor = {
  plugin = true,

  n = {
    ["<LocalLeader>sc"] = { "<cmd>SmoothCursorToggle<CR>", "toggle SmoothCursor", opts = default_opts },
  },
}

M.sniprun = {
  plugin = true,

  n = {
    ["<leader>tsc"] = { "<cmd>SnipClose<CR>", "close code runner", opts = default_opts },
    ["<leader>tsl"] = { "<cmd>SnipLive<CR>", "start live code runner", opts = default_opts },
    ["<leader>tsi"] = { "<cmd>SnipInfo<CR>", "code runner info", opts = default_opts },
    ["<leader>tss"] = { "<cmd>SnipRun<CR>", "run code under cursor", opts = default_opts },
    ["<leader>tsr"] = { "<cmd>SnipReset<CR>", "reset code runner", opts = default_opts },
  },
  v = {
    ["<leader>tss"] = { ":SnipRun<CR>", "run selected code", opts = default_opts },
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

M.tabular = {
  plugin = true,

  n = {
    ["<leader>ra\\"] = { "<cmd>Tabularize /\\\\\\<CR>", "tabularize \\\\", opts = default_opts },
    ["<leader>ra/"] = { "<cmd>Tabularize ////<CR>", "tabularize //", opts = default_opts },
    ["<leader>ra|"] = { "<cmd>Tabularize /|<CR>", "tabularize |", opts = default_opts },
    ["<leader>ra&"] = { "<cmd>Tabularize /&<CR>", "tabularize &", opts = default_opts },
    ["<leader>ra,"] = { "<cmd>Tabularize /,<CR>", "tabularize ,", opts = default_opts },
    ["<leader>ra:"] = { "<cmd>Tabularize /:<CR>", "tabularize :", opts = default_opts },
    ["<leader>ra;"] = { "<cmd>Tabularize /;<CR>", "tabularize ;", opts = default_opts },
    ["<leader>ra<Space>"] = { "<cmd>Tabularize /\\s\\+<CR>", "tabularize spaces", opts = default_opts },
    ["<leader>ra="] = { "<cmd>Tabularize /=<CR>", "tabularize =", opts = default_opts },
    ["<leader>ra-"] = { "<cmd>Tabularize /--<CR>", "tabularize --", opts = default_opts },
    ["<leader>ra{"] = { "<cmd>Tabularize /{<CR>", "tabularize {", opts = default_opts },
    ["<leader>ra#"] = { "<cmd>Tabularize /#<CR>", "tabularize #", opts = default_opts },
    -- tabularize after the symbol
    ["<leader>raa\\"] = { "<cmd>Tabularize /\\\\\\\\zs<CR>", "tabularize after \\\\", opts = default_opts },
    ["<leader>raa/"] = { "<cmd>Tabularize ////\\zs<CR>", "tabularize after //", opts = default_opts },
    ["<leader>raa|"] = { "<cmd>Tabularize /|\\zs<CR>", "tabularize after |", opts = default_opts },
    ["<leader>raa&"] = { "<cmd>Tabularize /&\\zs<CR>", "tabularize after &", opts = default_opts },
    ["<leader>raa,"] = { "<cmd>Tabularize /,\\zs<CR>", "tabularize after ,", opts = default_opts },
    ["<leader>raa:"] = { "<cmd>Tabularize /:\\zs<CR>", "tabularize after :", opts = default_opts },
    ["<leader>raa;"] = { "<cmd>Tabularize /;\\zs<CR>", "tabularize after ;", opts = default_opts },
    ["<leader>raa<Space>"] = { "<cmd>Tabularize /\\s\\+\\zs<CR>", "tabularize after spaces", opts = default_opts },
    ["<leader>raa="] = { "<cmd>Tabularize /=\\zs<CR>", "tabularize after =", opts = default_opts },
    ["<leader>raa-"] = { "<cmd>Tabularize /--\\zs<CR>", "tabularize after --", opts = default_opts },
    ["<leader>raa{"] = { "<cmd>Tabularize /{\\zs<CR>", "tabularize after {", opts = default_opts },
    ["<leader>raa#"] = { "<cmd>Tabularize /#\\zs<CR>", "tabularize after #", opts = default_opts },
  },
  v = {
    ["<leader>ra\\"] = { ":Tabularize /\\\\\\<CR>", "tabularize \\\\", opts = default_opts },
    ["<leader>ra/"] = { ":Tabularize ////<CR>", "tabularize //", opts = default_opts },
    ["<leader>ra|"] = { ":Tabularize /|<CR>", "tabularize |", opts = default_opts },
    ["<leader>ra&"] = { ":Tabularize /&<CR>", "tabularize &", opts = default_opts },
    ["<leader>ra,"] = { ":Tabularize /,\\zs<CR>", "tabularize ,", opts = default_opts },
    ["<leader>ra:"] = { ":Tabularize /:\\zs<CR>", "tabularize :", opts = default_opts },
    ["<leader>ra;"] = { ":Tabularize /;\\zs<CR>", "tabularize ;", opts = default_opts },
    ["<leader>ra<Space>"] = { ":Tabularize /\\s\\+<CR>", "tabularize spaces", opts = default_opts },
    ["<leader>ra="] = { ":Tabularize /=<CR>", "tabularize =", opts = default_opts },
    ["<leader>ra-"] = { ":Tabularize /--<CR>", "tabularize --", opts = default_opts },
    ["<leader>ra("] = { ":Tabularize /(<CR>", "tabularize (", opts = default_opts },
    ["<leader>ra["] = { ":Tabularize /[<CR>", "tabularize [", opts = default_opts },
    ["<leader>ra{"] = { ":Tabularize /{<CR>", "tabularize {", opts = default_opts },
    ["<leader>ra#"] = { ":Tabularize /#<CR>", "tabularize #", opts = default_opts },
    -- tabularize after the symbol
    ["<leader>raa\\"] = { ":Tabularize /\\\\\\\\zs<CR>", "tabularize after \\\\", opts = default_opts },
    ["<leader>raa/"] = { ":Tabularize ////\\zs<CR>", "tabularize after //", opts = default_opts },
    ["<leader>raa|"] = { ":Tabularize /|\\zs<CR>", "tabularize after |", opts = default_opts },
    ["<leader>raa&"] = { ":Tabularize /&\\zs<CR>", "tabularize after &", opts = default_opts },
    ["<leader>raa,"] = { ":Tabularize /,\\zs<CR>", "tabularize after ,", opts = default_opts },
    ["<leader>raa:"] = { ":Tabularize /:\\zs<CR>", "tabularize after :", opts = default_opts },
    ["<leader>raa;"] = { ":Tabularize /;\\zs<CR>", "tabularize after ;", opts = default_opts },
    ["<leader>raa<Space>"] = { ":Tabularize /\\s\\+\\zs<CR>", "tabularize after spaces", opts = default_opts },
    ["<leader>raa="] = { ":Tabularize /=\\zs<CR>", "tabularize after =", opts = default_opts },
    ["<leader>raa-"] = { ":Tabularize /--\\zs<CR>", "tabularize after --", opts = default_opts },
    ["<leader>raa{"] = { ":Tabularize /{\\zs<CR>", "tabularize after {", opts = default_opts },
    ["<leader>raa#"] = { ":Tabularize /#\\zs<CR>", "tabularize after #", opts = default_opts },
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

M.todo_comments = {
  plugin = true,

  n = {
    ["<leader>fdt"] = { "<cmd>TodoTelescope<CR>", "find todo comments", opts = default_opts },
    ["<leader>ctT"] = { "<cmd>TodoTrouble<CR>", "toggle todo quickfix", opts = default_opts },
  },
}

M.transparent = {
  plugin = true,

  n = {
    ["<localleader>sT"] = { "<cmd>TransparentToggle<CR>", "toggle transparent bg", opts = default_opts },
  },
}

M.treesitter_context = {
  n = {
    ["<localleader>slc"] = { "<cmd>TSContextToggle<CR>", "toggle treesitter context", opts = default_opts },
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

M.twilight = {
  plugin = true,

  n = {
    ["<localleader>st"] = { "<cmd>Twilight<CR>", "toggle twilight dimming", opts = default_opts },
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

--------------------------------------------------------------------------------
-- BASIC / CORE MAPPINGS (merged from core/mappings_vim.lua)
-- Helpers, leaders, and autocmds live in lua/user/core/mappings_helpers.lua
--------------------------------------------------------------------------------

M.exit = {
  n = {
    ["Q"] = { "q", "start macro record", opts = default_opts },
    ["<Leader>q"] = { ":q!<CR>", "force quit", opts = { silent = true } },
    ["<Leader>Q"] = { ":qa!<CR>", "force quit all", opts = { silent = true } },
    ["<leader>fs"] = { ":CustomBufferWrite<CR>", "save buffer", opts = { silent = true } },
    ["<leader>fa"] = { ":CustomBufferWrite a<CR>", "save all buffers", opts = { silent = true } },
    ["<leader>fw"] = { ":bw<CR>", "wipe buffer", opts = { silent = true } },
    ["<leader>fQ"] = { ":confirm wqa!<CR>", "save all + quit" },
  },
  x = {
    ["<Leader>q"] = { "<Esc>:q!<CR>", "force quit", opts = { silent = true } },
    ["<Leader>Q"] = { "<Esc>:qa!<CR>", "force quit all", opts = { silent = true } },
    ["<leader>fs"] = { "<Esc>:CustomBufferWrite<CR>", "save buffer", opts = { silent = true } },
    ["<leader>fa"] = { "<Esc>:CustomBufferWrite a<CR>", "save all buffers", opts = { silent = true } },
    ["<leader>fw"] = { ":<Esc>bw<CR>", "wipe buffer", opts = { silent = true } },
    ["<leader>fQ"] = { ":<Esc>confirm wqa!<CR>", "save all + quit" },
  },
}

M.operator = {
  o = {
    ["in("] = { ":<C-u>normal! f(vi(<CR>", "inside next ()", opts = default_opts },
    ["il("] = { ":<C-u>normal! F)vi(<CR>", "inside last ()", opts = default_opts },
    ["an("] = { ":<C-u>normal! f(va(<CR>", "around next ()", opts = default_opts },
    ["al("] = { ":<C-u>normal! F)va(<CR>", "around last ()", opts = default_opts },
  },
}

M.emacs_like = {
  i = {
    ["<C-a>"] = { "<Home>", "cursor home", opts = { silent = true } },
    ["<C-e>"] = {
      function() return vim.fn.pumvisible() == 1 and "<C-e>" or "<End>" end,
      "cursor end / dismiss popup",
      opts = { expr = true, silent = true },
    },
    ["<C-p>"] = { "<Up>", "cursor up", opts = { silent = true } },
    ["<C-n>"] = { "<Down>", "cursor down", opts = { silent = true } },
    ["<C-b>"] = { "<Left>", "cursor left", opts = { silent = true } },
    ["<C-f>"] = { "<Right>", "cursor right", opts = { silent = true } },
    ["<M-f>"] = { "<Esc>lwi", "next word", opts = { silent = true } },
    ["<M-b>"] = { "<Esc>bi", "prev word", opts = { silent = true } },
    ["<M-S-f>"] = { "<Esc>lWi", "next WORD", opts = { silent = true } },
    ["<M-S-b>"] = { "<Esc>Bi", "prev WORD", opts = { silent = true } },
    ["<M-a>"] = { "<Esc>`^(i", "prev sentence", opts = { silent = true } },
    ["<M-e>"] = { "<Esc>`^)i", "next sentence", opts = { silent = true } },
  },
  c = {
    ["<C-p>"] = { "<Up>", "history back", opts = default_opts },
    ["<C-n>"] = { "<Down>", "history forward", opts = default_opts },
    ["<C-b>"] = { "<Left>", "cursor left", opts = default_opts },
    ["<C-f>"] = { "<Right>", "cursor right", opts = default_opts },
    ["<C-k>"] = { "<C-f>D<C-c><C-c>:<Up>", "cut to eol (history back)", opts = default_opts },
  },
}

M.session = {
  n = {
    ["<Leader>ss"] = { ":<C-u>SeshSave<Space>", "session save" },
    ["<Leader>sl"] = { [[:<C-u>call feedkeys(':SeshLoad<Space><Tab>','t')<CR>]], "session load" },
    ["<Leader>sD"] = { [[:<C-u>call feedkeys(':SeshDelete<Space><Tab>','t')<CR>]], "session delete" },
    ["<Leader>sL"] = { ":<C-u>SeshList<CR>", "session list" },
    ["<Leader>sq"] = { ":<C-u>SeshClose<CR>", "session close" },
    ["<Leader>sd"] = { ":<C-u>SeshDetach<CR>", "session detach" },
  },
}

M.folds = {
  n = {
    ["<Leader>z"] = { "za", "toggle fold", opts = default_opts },
    ["<Leader>Z"] = { "zMzvzt", "focus current fold", opts = default_opts },
    ["zm"] = {
      function() return vim.wo.foldlevel ~= 0 and "zM" or "zR" end,
      "toggle fold all",
      opts = { expr = true },
    },
    ["zj"] = { function() vim.fn.NextClosedFold("j") end, "next closed fold", opts = { silent = true } },
    ["zk"] = { function() vim.fn.NextClosedFold("k") end, "prev closed fold", opts = { silent = true } },
    ["zn"] = { function() vim.fn.NextOpenFold("j") end, "next open fold", opts = { silent = true } },
    ["zp"] = { function() vim.fn.NextOpenFold("k") end, "prev open fold", opts = { silent = true } },
  },
}

M.improved_default = {
  n = {
    ["@"] = {
      function() _G.LazyNorm(vim.v.count1 .. "@" .. vim.fn.getcharstr()) end,
      "replay macro (lazyredraw)",
    },
    ["@@"] = {
      function() _G.LazyNorm(vim.v.count1 .. "@@") end,
      "replay last macro (lazyredraw)",
    },
    ["Y"] = { "y$", "yank to end of line" },
    ["J"] = {
      function()
        local p = vim.fn.getpos(".")
        vim.cmd("join")
        vim.fn.setpos(".", p)
      end,
      "join lines (keep cursor)",
      opts = { silent = true },
    },
    ["zl"] = { "z4l", "scroll right 4", opts = default_opts },
    ["zh"] = { "z4h", "scroll left 4", opts = default_opts },
    ["go"] = { ":vertical wincmd f<CR>", "open file under cursor (vsplit)", opts = default_opts },
    ["}"] = {
      function() vim.cmd("keepjumps norm! " .. vim.v.count1 .. "}") end,
      "paragraph down (keep jumps)",
      opts = { silent = true },
    },
    ["{"] = {
      function() vim.cmd("keepjumps norm! " .. vim.v.count1 .. "{") end,
      "paragraph up (keep jumps)",
      opts = { silent = true },
    },
    ["<C-S-a>"] = {
      function()
        _G.AddSubtract(vim.api.nvim_replace_termcodes("<C-a>", true, false, true), "b")
      end,
      "increment previous number",
      opts = { silent = true },
    },
    ["<C-S-x>"] = {
      function()
        _G.AddSubtract(vim.api.nvim_replace_termcodes("<C-x>", true, false, true), "b")
      end,
      "decrement previous number",
      opts = { silent = true },
    },
  },
  v = {
    ["y"] = { "ygv<Esc>", "yank (keep selection)" },
    ["j"] = {
      function() return vim.v.count == 0 and "gj" or "j" end,
      "down (respect wrap)",
      opts = { silent = true, expr = true },
    },
    ["k"] = {
      function() return vim.v.count == 0 and "gk" or "k" end,
      "up (respect wrap)",
      opts = { silent = true, expr = true },
    },
    ["<C-f>"] = {
      function()
        local n = math.max(vim.fn.winheight(0) - 2, 1)
        local tail = (vim.fn.line("w$") >= vim.fn.line("$")) and "L" or "M"
        return n .. "<C-d>" .. tail
      end,
      "smart page down",
      opts = { expr = true },
    },
    ["<C-b>"] = {
      function()
        local n = math.max(vim.fn.winheight(0) - 2, 1)
        local tail = (vim.fn.line("w0") <= 1) and "H" or "M"
        return n .. "<C-u>" .. tail
      end,
      "smart page up",
      opts = { expr = true },
    },
    ["<C-e>"] = {
      function() return (vim.fn.line("w$") >= vim.fn.line("$")) and "j" or "3<C-e>" end,
      "scroll down 3",
      opts = { expr = true },
    },
    ["<C-y>"] = {
      function() return (vim.fn.line("w0") <= 1) and "k" or "3<C-y>" end,
      "scroll up 3",
      opts = { expr = true },
    },
  },
  x = {
    ["p"] = { "pgvy", "paste (keep register)" },
    ["x"] = { [["_x]], "delete (blackhole)" },
    ["X"] = { [["_X]], "delete (blackhole)" },
    ["c"] = { [["_c]], "change (blackhole)" },
    ["C"] = { [["_C]], "change (blackhole)" },
    ["s"] = { [["_s]], "substitute (blackhole)" },
    ["S"] = { [["_S]], "substitute (blackhole)" },
    ["<"] = { "<gv", "indent left (keep selection)" },
    [">"] = { ">gv|", "indent right (keep selection)" },
    ["j"] = {
      function() return vim.v.count == 0 and "gj" or "j" end,
      "down (respect wrap)",
      opts = { silent = true, expr = true },
    },
    ["k"] = {
      function() return vim.v.count == 0 and "gk" or "k" end,
      "up (respect wrap)",
      opts = { silent = true, expr = true },
    },
  },
  -- n-mode blackhole variants for x/X/c/C/s/S
  -- put in a nested table so load_mappings iterates both modes
  i = {
    ["<M-o>"] = {
      function() return (vim.fn.pumvisible() == 1) and "<C-e><C-o>o" or "<C-o>o" end,
      "close popup + new line below",
      opts = { expr = true },
    },
    ["<M-O>"] = {
      function() return (vim.fn.pumvisible() == 1) and "<C-e><C-O>O" or "<C-O>O" end,
      "close popup + new line above",
      opts = { expr = true },
    },
  },
}

-- Separate section so n-mode blackhole x/X/c/C/s/S + j/k don't conflict with
-- hlslens/dial mappings already defined in M.general / M.hlslens
M.improved_default_n = {
  n = {
    ["x"] = { [["_x]], "delete char (blackhole)" },
    ["X"] = { [["_X]], "delete char back (blackhole)" },
    ["c"] = { [["_c]], "change (blackhole)", opts = { nowait = false } },
    ["C"] = { [["_C]], "change to eol (blackhole)" },
    ["s"] = { [["_s]], "substitute (blackhole)" },
    ["S"] = { [["_S]], "substitute line (blackhole)" },
    ["j"] = {
      function() return vim.v.count == 0 and "gj" or "j" end,
      "down (respect wrap)",
      opts = { silent = true, expr = true },
    },
    ["k"] = {
      function() return vim.v.count == 0 and "gk" or "k" end,
      "up (respect wrap)",
      opts = { silent = true, expr = true },
    },
    ["<C-f>"] = {
      function()
        local n = math.max(vim.fn.winheight(0) - 2, 1)
        local tail = (vim.fn.line("w$") >= vim.fn.line("$")) and "L" or "M"
        return n .. "<C-d>" .. tail
      end,
      "smart page down",
      opts = { expr = true },
    },
    ["<C-b>"] = {
      function()
        local n = math.max(vim.fn.winheight(0) - 2, 1)
        local tail = (vim.fn.line("w0") <= 1) and "H" or "M"
        return n .. "<C-u>" .. tail
      end,
      "smart page up",
      opts = { expr = true },
    },
    ["<C-e>"] = {
      function() return (vim.fn.line("w$") >= vim.fn.line("$")) and "j" or "3<C-e>" end,
      "scroll down 3",
      opts = { expr = true },
    },
    ["<C-y>"] = {
      function() return (vim.fn.line("w0") <= 1) and "k" or "3<C-y>" end,
      "scroll up 3",
      opts = { expr = true },
    },
  },
}

M.extended_basic = {
  t = {
    ["<Esc>"] = { [[<C-\><C-n>]], "exit terminal mode" },
  },
  i = {
    ["fd"] = { "<Esc>`^", "escape", opts = { remap = true } },
    ["kj"] = { "<Esc>`^", "escape", opts = { remap = true } },
    ["<S-Tab>"] = { "<C-v><Tab>", "insert literal tab" },
    ["<S-CR>"] = { "<C-o>o", "new line below" },
    ["<C-j>"] = {
      function() return vim.fn.pumvisible() == 1 and "<Down>" or "<C-j>" end,
      "popup next / literal <C-j>",
      opts = { expr = true },
    },
    ["<C-k>"] = {
      function() return vim.fn.pumvisible() == 1 and "<Up>" or "<C-k>" end,
      "popup prev / literal <C-k>",
      opts = { expr = true },
    },
  },
  v = {
    ["fd"] = { "<Esc>`<", "escape to selection start" },
    ["df"] = { "<Esc>`>", "escape to selection end" },
    ["<M-c>"] = { function() _G.VShiftCharAscii(1) end, "shift selection ASCII +1", opts = { silent = true } },
    ["<M-S-c>"] = { function() _G.VShiftCharAscii(-1) end, "shift selection ASCII -1", opts = { silent = true } },
  },
  c = {
    ["<C-[>"] = { "<C-c>", "cancel cmdline" },
    ["<C-g>"] = { "<C-c>", "cancel cmdline" },
  },
  n = {
    ["gh"] = { "g^", "go to visual line start" },
    ["gl"] = { "g$", "go to visual line end" },
    ["g<C-i>"] = { ":<C-u>call JumpBuffer(-1)<CR>", "jump buffer back" },
    ["g<C-o>"] = { ":<C-u>call JumpBuffer(1)<CR>", "jump buffer forward" },
    ["gp"] = {
      function() return "`[" .. vim.fn.getregtype():sub(1, 1) .. "`]" end,
      "select last paste",
      opts = { expr = true },
    },
    ["<C-o>"] = { "<C-o>zz", "jump back (centered)" },
    ["<C-i>"] = { "<C-i>zz", "jump forward (centered)" },
    ["<M-c>"] = {
      function()
        local line = vim.fn.getline(".")
        local col = vim.fn.col(".")
        local char = line:sub(col, col)
        if char ~= "" then _G.ShiftCharAscii(char, 1) end
      end,
      "shift char ASCII +1",
      opts = { silent = true },
    },
    ["<M-S-c>"] = {
      function()
        local line = vim.fn.getline(".")
        local col = vim.fn.col(".")
        local char = line:sub(col, col)
        if char ~= "" then _G.ShiftCharAscii(char, -1) end
      end,
      "shift char ASCII -1",
      opts = { silent = true },
    },
  },
}

M.file_path = {
  n = {
    ["<Leader>fye"] = {
      function()
        vim.cmd.echo(vim.fn.string("Yanked absolute file path without extension"))
        vim.fn.setreg("+", vim.fn.expand("%:p:r"))
      end,
      "yank absolute path (no ext)",
    },
    ["<Leader>fyE"] = {
      function()
        vim.cmd.echo(vim.fn.string("Yanked relative file path without extension"))
        vim.fn.setreg("+", vim.fn.expand("%:r"))
      end,
      "yank relative path (no ext)",
    },
    ["<Leader>fyp"] = {
      function()
        vim.cmd.echo(vim.fn.string("Yanked absolute file path"))
        vim.fn.setreg("+", vim.fn.expand("%:p"))
      end,
      "yank absolute path",
    },
    ["<Leader>fyP"] = {
      function()
        vim.cmd.echo(vim.fn.string("Yanked relative file path"))
        vim.fn.setreg("+", vim.fn.expand("%:~:."))
      end,
      "yank relative path",
    },
    ["<Leader>fyf"] = {
      function()
        vim.cmd.echo(vim.fn.string("Yanked file name without extension"))
        vim.fn.setreg("+", vim.fn.expand("%:t:r"))
      end,
      "yank filename (no ext)",
    },
    ["<Leader>fyF"] = {
      function()
        vim.cmd.echo(vim.fn.string("Yanked file name"))
        vim.fn.setreg("+", vim.fn.expand("%:t"))
      end,
      "yank filename",
    },
    ["<Leader>fyd"] = {
      function()
        vim.cmd.echo(vim.fn.string("Yanked absolute directory path"))
        vim.fn.setreg("+", vim.fn.expand("%:p:h"))
      end,
      "yank absolute dir",
    },
    ["<Leader>fyD"] = {
      function()
        vim.cmd.echo(vim.fn.string("Yanked relative directory path"))
        vim.fn.setreg("+", vim.fn.expand("%:p:h:t"))
      end,
      "yank relative dir",
    },
    ["<Leader>fyx"] = {
      function()
        vim.cmd.echo(vim.fn.string("Yanked file extension"))
        vim.fn.setreg("+", vim.fn.expand("%:e"))
      end,
      "yank file extension",
    },
    ["<Leader>fyo"] = {
      function()
        vim.cmd("e " .. vim.fn.getreg("+"))
        vim.cmd.echo(vim.fn.string("Opened " .. vim.fn.expand("%:p")))
      end,
      "open path from clipboard",
    },
    ["gyp"] = {
      function()
        local v = vim.fn.expand("%")
        vim.fn.setreg("+", v); vim.fn.setreg("0", v)
      end,
      "yank relative path (to + and 0)",
    },
    ["gyP"] = {
      function()
        local v = vim.fn.expand("%:p")
        vim.fn.setreg("+", v); vim.fn.setreg("0", v)
      end,
      "yank absolute path (to + and 0)",
    },
    ["gyl"] = {
      function()
        local v = string.format("%s:%d", vim.fn.expand("%"), vim.fn.getcurpos()[2])
        vim.fn.setreg("+", v); vim.fn.setreg("0", v)
      end,
      "yank relative path + line",
    },
    ["gyL"] = {
      function()
        local v = string.format("%s:%d", vim.fn.expand("%:p"), vim.fn.getcurpos()[2])
        vim.fn.setreg("+", v); vim.fn.setreg("0", v)
      end,
      "yank absolute path + line",
    },
  },
}

M.file_management = {
  n = {
    ["<Leader>fD"] = {
      function()
        local path = vim.fn.expand("%:p")
        vim.api.nvim_echo({ { "File " .. path .. " deleting...", "WarningMsg" } }, true, {})
        vim.fn.delete(vim.fn.expand("%"))
        vim.cmd("bdelete!")
      end,
      "delete file + buffer",
    },
    ["<Leader>frd"] = { ":cd %:p:h<CR>:pwd<CR>", "cd to file dir (all windows)" },
    ["<Leader>frl"] = { ":lcd %:p:h<CR>:pwd<CR>", "lcd to file dir (current window)" },
    ["<Leader>oo"] = {
      function() vim.cmd('silent !xdg-open "' .. vim.fn.expand("%:p") .. '" & disown') end,
      "open in xdg-open",
      opts = { silent = true },
    },
    ["<Leader>of"] = {
      function() vim.cmd('silent !firefox "' .. vim.fn.expand("%:p") .. '" & disown') end,
      "open in firefox",
      opts = { silent = true },
    },
    ["<Leader>og"] = {
      function() vim.cmd('silent !google-chrome "' .. vim.fn.expand("%:p") .. '" & disown') end,
      "open in chrome",
      opts = { silent = true },
    },
  },
}

M.windows_management = {
  n = {
    -- Tabs
    ["<LocalLeader>tn"] = { ":tabnew<CR>", "new tab", opts = { silent = true } },
    ["<LocalLeader>tN"] = { ":-tabnew<CR>", "new tab (before)", opts = { silent = true } },
    ["<LocalLeader>ts"] = { ":tab split<CR>", "tab split current", opts = { silent = true } },
    ["<LocalLeader>tq"] = { ":tabclose<CR>", "tab close", opts = { silent = true } },
    ["<LocalLeader>te"] = { ":tabedit<CR>", "tab edit", opts = { silent = true } },
    ["<LocalLeader>tm"] = { ":tabmove<CR>", "tab move", opts = { silent = true } },
    ["<LocalLeader>t>"] = { ":tabmove+<CR>", "tab move right", opts = { silent = true } },
    ["<LocalLeader>t<"] = { ":tabmove-<CR>", "tab move left", opts = { silent = true } },
    ["<LocalLeader>tl"] = {
      function() if vim.g.lasttab then vim.cmd("tabn " .. vim.g.lasttab) end end,
      "last active tab",
      opts = { silent = true },
    },
    ["[t"] = { ":tabprevious<CR>", "prev tab", opts = { silent = true } },
    ["]t"] = { ":tabnext<CR>", "next tab", opts = { silent = true } },
    ["[T"] = { ":tabfirst<CR>", "first tab", opts = { silent = true } },
    ["]T"] = { ":tablast<CR>", "last tab", opts = { silent = true } },
    ["<M-[>"] = { "<Cmd>tabp<CR>", "prev tab" },
    ["<M-]>"] = { "<Cmd>tabn<CR>", "next tab" },
    ["<leader>x"] = { "<Cmd>tabc<CR>", "close tab" },
    -- Buffers
    ["]b"] = { ":bnext<CR>", "next buffer", opts = { silent = true } },
    ["[b"] = { ":bprevious<CR>", "prev buffer", opts = { silent = true } },
    ["]B"] = { ":blast<CR>", "last buffer", opts = { silent = true } },
    ["[B"] = { ":bfirst<CR>", "first buffer", opts = { silent = true } },
    ["<LocalLeader>boh"] = { ":sba<CR>", "open all buffers (hsplit)", opts = { silent = true } },
    ["<LocalLeader>bov"] = { ":vert sba<CR>", "open all buffers (vsplit)", opts = { silent = true } },
    -- Window-control prefix
    ["[Window]"] = { "<Nop>", "window prefix" },
    ["<C-w>"] = { "[Window]", "window prefix", opts = { remap = true } },
    ["[Window]w"] = { "<C-w><C-w>", "next window" },
    ["[Window]<C-w>"] = { "<C-w><C-w>", "next window" },
    ["[Window]<C-p>"] = { "<C-w><C-p>", "previous window" },
    ["<C-q>"] = { ":<C-u>close<CR>", "close window", opts = { silent = true } },
    ["[Window]g"] = { ":<C-u>split<CR>", "split horizontal", opts = { silent = true } },
    ["[Window]v"] = { ":<C-u>vsplit<CR>", "split vertical", opts = { silent = true } },
    ["[Window]c"] = { ":<C-u>close<CR>", "close window", opts = { silent = true } },
    ["[Window]<C-v>"] = { ":vsplit<CR>:wincmd p<CR>", "vsplit stay", opts = { silent = true } },
    ["[Window]<C-g>"] = { ":split<CR>:wincmd p<CR>", "hsplit stay", opts = { silent = true } },
    ["<LocalLeader>wg"] = { ":<C-u>split<CR>", "split horizontal", opts = { silent = true } },
    ["<LocalLeader>wv"] = { ":<C-u>vsplit<CR>", "split vertical", opts = { silent = true } },
    ["<LocalLeader>wc"] = { ":<C-u>close<CR>", "close window", opts = { silent = true } },
    ["<LocalLeader>wV"] = { ":vsplit<CR>:wincmd p<CR>", "vsplit stay", opts = { silent = true } },
    ["<LocalLeader>wG"] = { ":split<CR>:wincmd p<CR>", "hsplit stay", opts = { silent = true } },
    -- Split nav
    ["[Window]h"] = { "<C-w>h", "window left", opts = { silent = true } },
    ["[Window]j"] = { "<C-w>j", "window down", opts = { silent = true } },
    ["[Window]k"] = { "<C-w>k", "window up", opts = { silent = true } },
    ["[Window]l"] = { "<C-w>l", "window right", opts = { silent = true } },
    ["[Window]\\"] = { "<C-w>p", "previous window", opts = { silent = true } },
    ["<C-h>"] = { "<C-w>h", "window left", opts = { silent = true } },
    ["<C-j>"] = { "<C-w>j", "window down", opts = { silent = true } },
    ["<C-k>"] = { "<C-w>k", "window up", opts = { silent = true } },
    ["<C-l>"] = { "<C-w>l", "window right", opts = { silent = true } },
    -- Arrow keys → resize
    ["<Up>"] = { ":resize -1<CR>", "resize up", opts = { silent = true } },
    ["<Down>"] = { ":resize +1<CR>", "resize down", opts = { silent = true } },
    ["<Left>"] = { ":vertical resize -2<CR>", "resize left", opts = { silent = true } },
    ["<Right>"] = { ":vertical resize +2<CR>", "resize right", opts = { silent = true } },
    -- Equalize
    ["[Window]="] = { ":tabdo wincmd =<CR>", "equalize splits (all tabs)", opts = { silent = true } },
  },
  v = {
    ["<LocalLeader>tl"] = {
      function() if vim.g.lasttab then vim.cmd("tabn " .. vim.g.lasttab) end end,
      "last active tab",
      opts = { silent = true },
    },
  },
}

M.utility = {
  n = {
    ["<Leader>ps"] = { "<cmd>source $MYVIMRC<CR>", "source vimrc" },
    ["[<space>"] = { "O<esc>j", "blank line above" },
    ["]<space>"] = { "o<esc>k", "blank line below" },
    ["<Leader>J"] = { ":m.+1<CR>", "move line down" },
    ["<Leader>K"] = { ":m.-2<CR>", "move line up" },
    ["<Leader>fg"] = { [[:call VimgrepWrapper("")<Left><Left>]], "vimgrep project" },
    ["<Leader>gD"] = { ":GitOpenDirty<CR>", "open git-dirty files" },
  },
  x = {
    ["<BS>"] = { "%", "jump to matching pair" },
  },
  i = {
    [","] = { ",<C-g>u", "undo breakpoint at ," },
    ["."] = { ".<C-g>u", "undo breakpoint at ." },
    ["!"] = { "!<C-g>u", "undo breakpoint at !" },
    ["?"] = { "?<C-g>u", "undo breakpoint at ?" },
    ["<M-v>"] = { "<ESC>v`[", "select last insert" },
  },
  v = {
    ["J"] = { ":m'>+1<CR>gv=gv", "move selection down" },
    ["K"] = { ":m'<-2<CR>gv=gv", "move selection up" },
  },
}

-- n-mode <BS>=% needs its own section (conflicts avoided via separate key)
M.utility_n = {
  n = {
    ["<BS>"] = { "%", "jump to matching pair" },
  },
}

M.commandline = {
  c = {
    ["<C-a>"] = { "<Home>", "cursor home" },
    ["<C-e>"] = { "<End>", "cursor end" },
    ["<C-d>"] = { "<Del>", "delete char" },
    ["<C-h>"] = { "<BS>", "backspace" },
    ["<C-t>"] = {
      function() return vim.fn.expand("%:p:h") .. "/" end,
      "insert current dir",
      opts = { expr = true },
    },
    ["<C-j>"] = {
      function()
        return vim.fn.pumvisible() == 1 and "<C-n>" or vim.fn.nr2char(vim.o.wildcharm)
      end,
      "wildmenu next",
      opts = { expr = true },
    },
    ["<C-k>"] = {
      function()
        return vim.fn.pumvisible() == 1 and "<C-p>" or vim.fn.nr2char(vim.o.wildcharm)
      end,
      "wildmenu prev",
      opts = { expr = true },
    },
    ["<Tab>"] = {
      function()
        if vim.fn.pumvisible() == 1 then
          return "<C-y>" .. vim.fn.nr2char(vim.o.wildcharm)
        end
        return vim.fn.nr2char(vim.o.wildcharm)
      end,
      "wildmenu accept / next",
      opts = { expr = true },
    },
    ["%%"] = {
      function() return vim.fn.fnameescape(vim.fn.expand("%:h")) .. "/" end,
      "expand to current file dir",
      opts = { expr = true },
    },
  },
  n = {
    ["<leader>ew"] = { ":e %%", "edit in current dir", opts = { remap = true } },
    ["<leader>ev"] = { ":vsplit %%", "vsplit in current dir", opts = { remap = true } },
    ["<leader>et"] = { ":tabe %%", "tabedit in current dir", opts = { remap = true } },
  },
  x = {
    ["<leader>ew"] = { ":e %%", "edit in current dir", opts = { remap = true } },
    ["<leader>ev"] = { ":vsplit %%", "vsplit in current dir", opts = { remap = true } },
    ["<leader>et"] = { ":tabe %%", "tabedit in current dir", opts = { remap = true } },
  },
  o = {
    ["<leader>ew"] = { ":e %%", "edit in current dir", opts = { remap = true } },
    ["<leader>ev"] = { ":vsplit %%", "vsplit in current dir", opts = { remap = true } },
    ["<leader>et"] = { ":tabe %%", "tabedit in current dir", opts = { remap = true } },
  },
}

M.yank_paste = {
  n = {
    ["<M-y>"] = { [["xyy"xp$]], "duplicate line at eol" },
  },
  i = {
    ["<M-y>"] = { [[<Esc>"xyy"xpgi]], "duplicate line inline" },
    ["<C-y>"] = {
      [[<Esc>"xyy"xpV:s//gI<bar>norm`.A<Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left>]],
      "duplicate + prompt substitute",
    },
  },
  v = {
    ["<M-y>"] = { [=["xy`]"xp`[V`]]=], "duplicate selection" },
  },
}

M.register = {
  n = {
    ["<Leader>rej"] = {
      [[:let @x=@k | let @k=@j | let @j=@b | let @b=@a | let @a=@+ | let @+=@x | reg +abjk<CR>]],
      "register cycle forward",
    },
    ["<Leader>rek"] = {
      [[:let @x=@+ | let @+=@a | let @a=@b | let @b=@j | let @j=@k | let @k=@x | reg +abjk<CR>]],
      "register cycle backward",
    },
    ["<Leader>reJ"] = {
      [[:let @x=@k | let @k=@j | let @j=@b | let @b=@a | let @a=@+ | let @+=@x | reg +abjk<CR>p]],
      "register cycle forward + paste",
    },
    ["<Leader>reK"] = {
      [[:let @x=@+ | let @+=@a | let @a=@b | let @b=@j | let @j=@k | let @k=@x | reg +abjk<CR>p]],
      "register cycle backward + paste",
    },
    ["<Leader>reg"] = { ":reg +abjk<CR>", "show registers +abjk" },
  },
  v = {
    ["<Leader>reJ"] = {
      [[:let @x=@k | let @k=@j | let @j=@b | let @b=@a | let @a=@+ | let @+=@x | reg +abjk<CR>p]],
      "register cycle forward + paste",
    },
    ["<Leader>reK"] = {
      [[:let @x=@+ | let @+=@a | let @a=@b | let @b=@j | let @j=@k | let @k=@x | reg +abjk<CR>p]],
      "register cycle backward + paste",
    },
    ["<Leader>rej"] = {
      [[y<ESC>:let @x=@k | let @k=@j | let @j=@b | let @b=@a | let @a=@+ | let @+=@x | reg +abjk<CR>]],
      "yank + register cycle forward",
    },
    ["<Leader>rek"] = {
      [[y<ESC>:let @x=@+ | let @+=@a | let @a=@b | let @b=@j | let @j=@k | let @k=@x | reg +abjk<CR>]],
      "yank + register cycle backward",
    },
  },
}

M.quickfix_loclist = {
  n = {
    ["[L"] = { ":lfirst<CR>", "first loclist", opts = { silent = true } },
    ["]L"] = { ":llast<CR>", "last loclist", opts = { silent = true } },
    ["[Q"] = { ":cfirst<CR>", "first quickfix", opts = { silent = true } },
    ["]Q"] = { ":clast<CR>", "last quickfix", opts = { silent = true } },
    ["<LocalLeader>oll"] = { ":call LocationlistToggle()<CR>", "toggle loclist", opts = { silent = true } },
    ["<LocalLeader>oqq"] = { ":call QuickfixToggle()<CR>", "toggle quickfix", opts = { silent = true } },
  },
}

M.diff = {
  n = {
    ["<Leader>tdv"] = {
      [[:call feedkeys(':vert diffsplit<Space><Tab>','t')<CR>]],
      "diff vert split prompt",
    },
    ["<Leader>tdh"] = {
      [[:call feedkeys(':diffsplit<Space><Tab>','t')<CR>]],
      "diff horizontal split prompt",
    },
    ["<Leader>tdV"] = {
      [[:call feedkeys(':vert diffsplit $HOME/<Tab>','t')<CR>]],
      "diff vert split $HOME prompt",
    },
    ["<Leader>tdH"] = {
      [[:call feedkeys(':diffsplit $HOME/<Tab>','t')<CR>]],
      "diff horizontal split $HOME prompt",
    },
    ["<Leader>tdo"] = {
      ":DiffOrig<CR>",
      "diff with original file",
      opts = { silent = true, remap = true },
    },
  },
}

M.text_manipulation = {
  n = {
    ["<Leader>r<Space>"] = { ":<C-u>WhitespaceErase<CR>", "erase trailing whitespace", opts = { silent = true } },
    ["<leader>rw"] = { "*``cgn", "change word forward (dot-repeat)" },
    ["<leader>rW"] = { "*``cgN", "change word backward (dot-repeat)" },
    ["<Leader>rR"] = { ":s//gc<Left><Left><Left>", "search/replace current line" },
    ["<Leader>rF"] = {
      [[:<C-u>call GetSelection('/')<CR>:%s/\V<C-R>=@/<CR>//gc<Left><Left><Left>]],
      "search/replace last selection",
    },
    ["<Leader>rL"] = { [[:%s/^/\=line('.').". "<CR>]], "enumerate all lines" },
    ["<Leader>ri"] = {
      [[:call Preserve("normal gg=G")<CR>]],
      "re-indent whole buffer",
      opts = { silent = true },
    },
    ["<Leader>rya"] = { ":%y<CR>", "yank entire file" },
    ["<Leader>ryp"] = {
      [[ggVGP:echom "Replaced all with yanked texts!"<CR>]],
      "replace all with yanked",
    },
    ["<Leader>rP"] = { "<cmd>call SmartPaste()<CR>", "smart paste + clean + reindent", opts = { silent = true } },
    ["<F11>"] = { ":set spell!<CR>", "toggle spell" },
  },
  v = {
    ["<Leader>r<Space>"] = { ":WhitespaceErase<CR>", "erase trailing whitespace", opts = { silent = true } },
    ["<leader>rn"] = {
      [[y/\V<C-r>=escape(@", '/')<CR><CR>``cgn]],
      "change selection forward (dot-repeat)",
    },
    ["<leader>rN"] = {
      [[y/\V<C-r>=escape(@", '/')<CR><CR>``cgN]],
      "change selection backward (dot-repeat)",
    },
    ["<Leader>rl"] = {
      [[:<C-U>let i=1 | '<,'>g/^/s//\=i.'. '/ | let i=i+1 | nohl<CR>]],
      "enumerate selected lines",
      opts = { silent = true },
    },
  },
  x = {
    ["<Leader>rr"] = { ":s//gc<Left><Left><Left>", "search/replace in selection" },
    ["<Leader>rF"] = {
      [[:<C-u>call GetSelection('/')<CR>:%s/\V<C-R>=@/<CR>//gc<Left><Left><Left>]],
      "search/replace last selection",
    },
  },
  i = {
    ["<C-s>"] = {
      [[<Esc>:set spell<bar>norm i<C-g>u<Esc>[s"syiW1z="tyiW:let @l=line('.')<bar>let @c=virtcol('.')<CR>``a<C-g>u<Esc>:echo getreg('l') . ":" . getreg('c') . " spell fixed (" . getreg('s') . " -> " . getreg('t') . ")"<CR>la]],
      "auto-fix previous misspelling",
    },
    ["<F11>"] = { "<C-o>:set spell!<CR>", "toggle spell" },
  },
}

-- n-mode <Leader>rn / rN and <Leader>rr are skipped due to conflicts with
-- M.inc_rename (<leader>rn) and M.abolish (<leader>rp → :Subvert pattern)

M.settings_toggle = {
  n = {
    ["<LocalLeader>se"] = { function() _G.ConfigToggles.conceal() end, "toggle conceal", opts = { silent = true } },
    ["<LocalLeader>ss"] = { function() _G.ConfigToggles.format_on_save() end, "toggle format on save", opts = { silent = true } },
    ["<LocalLeader>sF"] = { function() _G.ConfigToggles.foldcolumn1() end, "toggle foldcolumn", opts = { silent = true } },
    ["<LocalLeader>sg"] = { function() _G.ConfigToggles.gutter() end, "toggle sign gutter", opts = { silent = true } },
    ["<LocalLeader>sv"] = { function() _G.ConfigToggles.virtualedit() end, "toggle virtualedit", opts = { silent = true } },
    ["<LocalLeader>sW"] = { function() _G.ConfigToggles.text_wrapping() end, "toggle text wrapping (fo+t)", opts = { silent = true } },
    ["<LocalLeader>sb"] = { function() _G.ConfigToggles.background() end, "toggle dark/light bg", opts = { silent = true } },
    ["<LocalLeader>sL"] = { function() _G.ConfigToggles.low_performance_mode() end, "toggle low performance mode" },
    ["<LocalLeader>sw"] = { function() _G.ConfigToggles.smart_wrap() end, "smart wrap toggle" },
  },
}

M.elite_mode = {
  n = {
    ["<LocalLeader>sE"] = { function() _G.EliteModeToggle() end, "toggle elite mode (LSP+Copilot off)" },
  },
}

return M
