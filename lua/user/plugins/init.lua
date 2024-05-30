
-- TODO:
-- - Move all `utils.load_mappings()` out of `init` and into the
--   plugin's `config` or conf()

---Use local development version if it exists.
---NOTE: Remember to run `:PackerClean :PackerInstall` to update symlinks.
---@param spec table|string
local function use_local(spec)
  local name

  if type(spec) ~= "table" then
    spec = { spec }
  end

  ---@cast spec table
  if spec.name then
    name = spec.name
  else
    name = spec[1]:match(".*/(.*)")
    name = name:gsub("%.git$", "")
  end

  local local_path = spec.local_path or vim.env.NVIM_LOCAL_PLUGINS or (vim.env.HOME .. "/Documents/dev/my-repos")
  local path = local_path .. "/" .. name

  if vim.fn.isdirectory(path) == 1 then
    spec.dir = path
  end

  return spec
end

local utils = require("user.core.utils")
local sys = Config.common.sys

local function conf(config_name, mappings_name)
  if mappings_name then
    utils.load_mappings(mappings_name)
  end

  local config_path = string.format("user.plugins.%s", config_name)

  -- If config is not in path
  if not pcall(require, config_path) then
    -- Generic fallback config setup if config file not found
    return function()
      require(config_name).setup({})
    end
  end

  -- Else, return the config in path
  return require(config_path)
end

require("lazy").setup({
  -- SYNTAX & FILETYPE PLUGINS
  {
    "lervag/vimtex",
    ft = { "plaintex", "tex", "latex", "markdown", "vimwiki" },
    config = conf("vimtex"),
  },
  {
    "chrisbra/csv.vim",
    ft = "csv",
  },
  -- {
  --   "aliou/bats.vim",
  --   ft = "bats",
  -- },
  -- {
  --   "fei6409/log-highlight.nvim",
  --   ft = { "log", "txt" },
  --   config = conf("log-highlight"),
  -- },

  -- UTILS
  "nvim-lua/popup.nvim",
  "nvim-lua/plenary.nvim",
  "MunifTanjim/nui.nvim",
  {
    "vhyrro/luarocks.nvim",
    priority = 1000,
    config = true,
  },
  {
    "tpope/vim-eunuch",
    event = "VimEnter",
    config = conf("eunuch"),
  },
  {
    "rcarriga/nvim-notify",
    cond = not vim.g.low_performance_mode,
    event = "VimEnter",
    config = conf("nvim-notify"),
  },
  -- {
  --   -- INFO: Need to enable Cursor highlight in colorscheme.lua.
  --   -- i.e. comment out `hi_clear({ "Cursor", "TermCursor" })`
  --   -- (DEPRECATED INFO) Overriding lsp_signature. See usr/lsp/init.lua
  --   "folke/noice.nvim",
  --   cond = not sys.is_gui() and not vim.g.low_performance_mode,
  --   event = "VeryLazy",
  --   config = conf("noice"),
  --   dependencies = {
  --     "MunifTanjim/nui.nvim",
  --     "rcarriga/nvim-notify",
  --   },
  -- },
  -- {
  --   "mrded/nvim-lsp-notify",
  --   event = "VimEnter",
  --   config = function()
  --     -- require("lsp-notify").setup({ notify = require("notify") })
  --     require("lsp-notify").setup()
  --   end,
  --   dependencies = {
  --     "neovim/nvim-lspconfig",
  --   },
  -- },
  {
    "xiyaowong/transparent.nvim",
    init = utils.load_mappings("transparent"),
    lazy = false,
  },

  -- COLORSCHEMES
  { "AlexvZyl/nordic.nvim", config = conf("nordic"), lazy = false },
  { "EdenEast/nightfox.nvim", config = conf("nightfox"), lazy = false },
  { "Mofiqul/vscode.nvim", config = conf("vscode"), lazy = false },
  { "catppuccin/nvim", config = conf("catppuccin"), name = "catppuccin", lazy = false },
  { "folke/tokyonight.nvim", config = conf("tokyonight"), lazy = false },
  { "mcchrish/zenbones.nvim", dependencies = "rktjmp/lush.nvim", lazy = false },
  { "rebelot/kanagawa.nvim", config = conf("kanagawa"), lazy = false },
  { "rose-pine/neovim", config = conf("rose-pine"), name = "rose-pine", lazy = false },
  { "sainnhe/gruvbox-material", config = conf("gruvbox-material"), lazy = false },
  { "sindrets/oxocarbon-lua.nvim", lazy = false },

  -- STARTUP
  { "goolord/alpha-nvim", config = conf("alpha"), event = "VimEnter" },

  -- BEHAVIOR
  {
    "marklcrns/vim-smartq",
    init = function()
      utils.load_mappings("smartq")
      conf("vim-smartq")()
    end,
    event = "VimEnter",
  },
  {
    "chrisgrieser/nvim-spider",
    cond = not vim.g.low_performance_mode,
    event = "VimEnter",
    -- NOTE: using conf("spider", "spider") does not work as the plugin is loaded to boot
    config = function()
      utils.load_mappings("spider")
      require("spider").setup({
        skipInsignificantPunctuation = false,
      })
    end,
  },
  {
    "kevinhwang91/nvim-ufo",
    -- cond = not vim.g.low_performance_mode,
    init = utils.lazy_load("nvim-ufo"),
    config = conf("nvim-ufo"),
    dependencies = {
      "kevinhwang91/promise-async",
    },
  },
  -- {
  --   "kevinhwang91/nvim-hlslens",
  --   init = utils.lazy_load("nvim-hlslens"),
  --   config = conf("nvim-hlslens", "hlslens"),
  -- },
  {
    "yorickpeterse/nvim-pqf",
    ft = { "qf" },
    config = function()
      require("pqf").setup({
        signs = {
          error = "",
          warning = "",
          info = "",
          hint = "",
        },
      })
    end,
  },
  -- TODO: map
  {
    "kevinhwang91/nvim-bqf",
    ft = { "qf" },
    config = conf("nvim-bqf"),
  },
  {
    "sindrets/winshift.nvim",
    init = utils.load_mappings("winshift"),
    cmd = "WinShift",
    config = conf("winshift"),
  },
  {
    "nvim-focus/focus.nvim",
    cond = not vim.g.low_performance_mode,
    event = "VimEnter",
    config = conf("focus", "focus"),
  },
  {
    "levouh/tint.nvim",
    cond = not vim.g.low_performance_mode,
    event = "VimEnter",
    config = conf("tint", "tint"),
  },
  -- {
  --   "TaDaa/vimade",
  --   cond = not sys.is_gui(),
  --   init = function()
  --     utils.lazy_load("vimade")
  --     utils.load_mappings("vimade")
  --   end,
  --   config = conf("vimade"),
  -- },
  -- {
  --   "marklcrns/lens.vim",
  --   cond = not sys.is_gui(),
  --   init = function()
  --     utils.lazy_load("lens.vim")
  --     utils.load_mappings("lens")
  --   end,
  --   config = conf("lens"),
  --   dependencies = {
  --     {
  --       "camspiers/animate.vim",
  --       cond = not sys.is_gui(),
  --       config = conf("animate"),
  --     },
  --   },
  -- },
  -- {
  --   "karb94/neoscroll.nvim",
  --   cond = not sys.is_gui(),
  --   init = utils.lazy_load("neoscroll.nvim"),
  --   config = conf("neoscroll"),
  -- },
  {
    "gen740/SmoothCursor.nvim",
    cond = not sys.is_gui(),
    event = "VimEnter",
    init = utils.load_mappings("SmoothCursor"),
    config = conf("SmoothCursor"),
  },
  {
    "mvllow/modes.nvim",
    init = utils.lazy_load("modes.nvim"),
    config = conf("modes"),
  },

  -- UI STYLE
  { "nvim-tree/nvim-web-devicons", config = conf("nvim-web-devicons") },
  {
    "HiPhish/rainbow-delimiters.nvim",
    event = "BufRead",
    config = conf("rainbow-delimiters"),
    dependencies = { "nvim-treesitter/nvim-treesitter" },
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    init = utils.lazy_load("indent-blankline.nvim"),
    main = "ibl",
    config = conf("indent-blankline"),
    -- WARN: Integration with rainbow-delimiters degrades performance
    -- dependencies = { "HiPhish/rainbow-delimiters.nvim" },
  },
  {
    "Darazaki/indent-o-matic",
    event = "VimEnter",
    config = conf("indent-o-matic"),
  },
  {
    "akinsho/bufferline.nvim",
    event = "VimEnter",
    dependencies = "nvim-tree/nvim-web-devicons",
    config = conf("bufferline"),
  },
  {
    "feline-nvim/feline.nvim",
    event = "VimEnter",
    config = conf("feline"),
  },

  -- UI INTERFACE
  {
    -- Needed by common.utils
    "sindrets/diffview.nvim",
    init = utils.load_mappings("diffview"),
    config = conf("diffview"),
  },
  {
    "AndrewRadev/linediff.vim",
    init = utils.load_mappings("linediff"),
    cmd = { "Linediff" },
  },
  {
    "folke/which-key.nvim",
    keys = { "<leader>", "<localleader>", "]", "[" },
    config = conf("which-key"),
  },
  -- {
  --   "folke/zen-mode.nvim",
  --   cmd = "ZenMode",
  --   init = utils.load_mappings("zen_mode"),
  --   config = conf("zen-mode"),
  -- },
  -- {
  --   "Pocco81/true-zen.nvim",
  --   cmd = { "TZAtaraxis", "TZMinimalist", "TZFocus", "TZNarrow" },
  --   init = utils.load_mappings("true_zen"),
  --   config = conf("true-zen"),
  -- },
  -- WARN: Disabled because it affects startup time by good amount
  -- {
  --   "Bekaboo/dropbar.nvim",
  --   cond = not sys.is_gui() and not vim.g.low_performance_mode,
  --   event = "VimEnter",
  --   config = conf("dropbar", "dropbar"),
  --   dependencies = {
  --     "nvim-telescope/telescope-fzf-native.nvim",
  --   },
  -- },

  -- FILE NAVIGATION
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    config = conf("telescope", "telescope"),
  },
  { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
  { "nvim-telescope/telescope-media-files.nvim" },
  { "nvim-telescope/telescope-ui-select.nvim" },
  -- {
  --   "nvim-telescope/telescope-frecency.nvim",
  --   init = utils.load_mappings("frecency"),
  --   dependencies = { "kkharji/sqlite.lua" },
  -- },
  { "debugloop/telescope-undo.nvim" },
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    cmd = "Neotree",
    init = utils.load_mappings("neo_tree"),
    config = conf("neo-tree"),
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
      {
        "s1n7ax/nvim-window-picker",
        init = utils.load_mappings("nvim_window_picker"),
        version = "v2.*",
        config = conf("nvim-window-picker"),
      },
    },
  },
  {
    "kshenoy/vim-signature",
    init = utils.lazy_load("vim-signature"),
    config = conf("vim-signature"),
  },

  -- PROJECT MANAGER
  -- INFO: Unused plugin
  -- {
  --   "ahmedkhalf/project.nvim",
  --   event = "VimEnter",
  --   config = conf("project"),
  -- },

  -- CODING HELPER
  -- DEPRECATED as of Neovim 0.10.0. Made built-in
  {
    "numToStr/Comment.nvim",
    init = utils.lazy_load("Comment.nvim"),
    config = true,
  },
  {
    "kylechui/nvim-surround",
    init = utils.lazy_load("nvim-surround"),
    config = conf("nvim-surround"),
  },
  {
    "windwp/nvim-autopairs",
    init = utils.lazy_load("nvim-autopairs"),
    config = conf("nvim-autopairs"),
  },
  {
    "windwp/nvim-ts-autotag",
    init = utils.lazy_load("nvim-ts-autotag"),
    ft = {
      "html",
      "javascript",
      "typescript",
      "javascriptreact",
      "typescriptreact",
      "svelte",
      "vue",
      "tsx",
      "jsx",
      "rescript",
      "xml",
      "php",
      "glimmer",
      "handlebars",
      "hbs",
    },
    config = conf("nvim-ts-autotag"),
  },
  {
    "Wansmer/treesj",
    init = utils.load_mappings("treesj"),
    event = "BufRead",
    config = conf("treesj"),
  },
  {
    "monaqa/dial.nvim",
    init = utils.load_mappings("dial"),
    event = "BufRead",
    config = conf("dial"),
  },
  {
    "tpope/vim-abolish",
    init = utils.load_mappings("abolish"),
    event = "BufRead",
  },
  {
    "godlygeek/tabular",
    init = function()
      utils.load_mappings("tabular")
    end,
    cmd = "Tabularize",
  },
  {
    "kana/vim-niceblock",
    init = function()
      utils.lazy_load("vim-niceblock")
      utils.load_mappings("niceblock")
      vim.g.niceblock_use_default_mappings = 0
    end,
  },
  {
    "RRethy/vim-illuminate",
    event = "BufRead",
    config = conf("vim-illuminate"),
  },
  {
    "andymass/vim-matchup",
    cond = not vim.g.low_performance_mode,
    event = "BufRead",
    config = conf("vim-matchup"),
  },
  {
    "bennypowers/nvim-regexplainer",
    init = utils.load_mappings("regexplainer"),
    cmd = "RegexplainerToggle",
    config = function()
      require("regexplainer").setup({ auto = false })
    end,
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "MunifTanjim/nui.nvim",
    },
  },
  {
    "nvim-pack/nvim-spectre",
    event = "VeryLazy",
    init = utils.load_mappings("spectre"),
    config = conf("nvim-spectre"),
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
  },
  -- INFO: Disabled since its not working properly
  -- {
  --   "smjonas/inc-rename.nvim",
  --   init = utils.load_mappings("inc_rename"),
  --   cmd = "IncRename",
  --   config = true,
  -- },
  {
    "johmsalas/text-case.nvim",
    event = "BufRead",
    init = utils.load_mappings("text_case"),
  },
  -- {
  --   "mfussenegger/nvim-dap",
  --   event = "VimEnter",
  --   init = utils.load_mappings("nvim_dap"),
  --   config = conf("nvim-dap"),
  --   dependencies = {
  --     -- "mfussenegger/nvim-dap-python",
  --     {
  --       "theHamsta/nvim-dap-virtual-text",
  --       config = conf("nvim-dap-virtual-text"),
  --     },
  --     {
  --       "rcarriga/nvim-dap-ui",
  --       init = utils.load_mappings("nvim_dap_ui"),
  --       config = conf("nvim-dap-ui"),
  --       dependencies = {
  --         "folke/neodev.nvim",
  --       },
  --     },
  --   },
  -- },
  -- {
  --   "jay-babu/mason-nvim-dap.nvim",
  --   event = "VimEnter",
  --   config = conf("mason-nvim-dap"),
  --   dependencies = {
  --     "williamboman/mason.nvim",
  --   },
  -- },

  -- CODE NAVIGATION
  -- {
  --   "gorbit99/codewindow.nvim",
  --   cond = not vim.g.low_performance_mode,
  --   event = "VimEnter",
  --   config = conf("codewindow", "codewindow"),
  -- },
  {
    "simrat39/symbols-outline.nvim",
    init = utils.load_mappings("symbols_outline"),
    cmd = { "SymbolsOutline", "SymbolsOutlineOpen", "SymbolsOutlineClose" },
    config = conf("symbols-outline"),
  },
  {
    "ggandor/leap.nvim",
    keys = { "s", "S" },
    config = conf("leap"),
  },

  -- VCS
  {
    "TimUntersberger/neogit",
    cmd = "Neogit",
    branch = "nightly",
    init = utils.load_mappings("neogit"),
    config = conf("neogit"),
  },
  {
    "sindrets/vim-fugitive",
    init = function()
      utils.lazy_load("vim-fugitive")
      utils.load_mappings("fugitive")
    end,
    config = conf("vim-fugitive"),
    dependencies = {
      "tpope/vim-rhubarb",
      {
        "rbong/vim-flog",
        config = conf("vim-flog"),
      },
    },
  },
  {
    "lewis6991/gitsigns.nvim",
    init = function()
      utils.lazy_load("gitsigns.nvim")
      utils.load_mappings("gitsigns")
    end,
    config = conf("gitsigns"),
  },
  {
    "wintermute-cell/gitignore.nvim",
    init = utils.load_mappings("gitignore"),
    cmd = "Gitignore",
    dependencies = {
      "nvim-telescope/telescope.nvim",
    },
  },

  -- INTEGRATIONS
  {
    "alexghergh/nvim-tmux-navigation",
    event = "VimEnter",
    config = conf("nvim-tmux-navigation"),
  },
  -- Disabled because I ran out of free OpenAI API credits
  -- {
  --   "jackMort/ChatGPT.nvim",
  --   event = "VeryLazy",
  --   init = utils.load_mappings("chatgpt"),
  --   config = conf("ChatGPT"),
  --   dependencies = {
  --     "MunifTanjim/nui.nvim",
  --     "nvim-lua/plenary.nvim",
  --     "nvim-telescope/telescope.nvim",
  --   },
  -- },

  -- SYNTAX & FILETYPE PLUGINS
  {
    "nvim-treesitter/nvim-treesitter",
    init = utils.lazy_load("nvim-treesitter"),
    cmd = { "TSInstall", "TSBufEnable", "TSBufDisable", "TSModuleInfo" },
    build = ":TSUpdate",
    config = conf("nvim-treesitter"),
    dependencies = {},
  },
  {
    "RRethy/nvim-treesitter-textsubjects",
    init = utils.lazy_load("nvim-treesitter-textsubjects"),
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    init = utils.lazy_load("nvim-treesitter-textobjects"),
    config = conf("nvim-treesitter-textobjects"),
  },
  {
    "nvim-treesitter/nvim-treesitter-context",
    cond = not vim.g.low_performance_mode,
    cmd = { "TSContextEnable", "TSContextToggle" },
    event = "VeryLazy",
    config = conf("nvim-treesitter-context", "treesitter_context"),
  },
  {
    "RRethy/nvim-treesitter-endwise",
    init = utils.lazy_load("nvim-treesitter-endwise"),
  },
  {
    "folke/todo-comments.nvim",
    init = utils.lazy_load("todo-comments.nvim"),
    config = conf("todo-comments", "todo_comments"),
  },
  {
    "NvChad/nvim-colorizer.lua",
    cond = not vim.g.low_performance_mode,
    init = utils.lazy_load("nvim-colorizer.lua"),
    config = function(_, opts)
      utils.load_mappings("colorizer")
      require("colorizer").setup(opts)
      -- execute colorizer as soon as possible
      vim.defer_fn(function()
        require("colorizer").attach_to_buffer(0)
      end, 0)
    end,
  },

  -- LANGUAGE SERVER PROTOCOL + TOOLS
  {
    "neovim/nvim-lspconfig",
    init = utils.load_mappings("lsp"),
  },
  {
    "jose-elias-alvarez/null-ls.nvim",
    config = conf("null-ls"),
  },
  {
    "williamboman/mason.nvim",
    build = ":MasonUpdate",
    init = utils.load_mappings("mason"),
    dependencies = { { "williamboman/mason-lspconfig.nvim", config = false } },
    config = false,
  },
  {
    "jayp0521/mason-null-ls.nvim",
    event = "VimEnter",
    config = conf("mason-null-ls"),
  },
  {
    "ray-x/lsp_signature.nvim",
    cond = not vim.g.low_performance_mode,
    event = "InsertEnter",
    config = conf("lsp_signature"),
  },
  {
    "WhoIsSethDaniel/toggle-lsp-diagnostics.nvim",
    cmd = { "ToggleDiagOn", "ToggleDiagOff" },
    init = utils.load_mappings("toggle_lsp_diagnostics"),
    config = conf("toggle-lsp-diagnostics"),
  },
  {
    "folke/trouble.nvim",
    init = utils.load_mappings("trouble"),
    event = "VimEnter", -- NOTE: This is needed to load Config.fn.toggle_diagnostics()
    config = conf("trouble"),
    dependencies = "nvim-tree/nvim-web-devicons",
  },

  -- LANGUAGES + TOOLS
  {
    "folke/neodev.nvim",
    -- NOTE: Defined in lua/init.lua
    -- config = true,
    dependencies = {
      "neovim/nvim-lspconfig",
      "nvim-treesitter/nvim-treesitter",
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
    },
  },
  {
    "iamcco/markdown-preview.nvim",
    init = utils.load_mappings("markdown_preview"),
    build = "cd app && yarn install",
    ft = { "markdown", "pandoc.markdown", "rmd", "vimwiki" },
    config = conf("markdown-preview"),
  },
  {
    "mzlogin/vim-markdown-toc",
    init = utils.load_mappings("markdown_toc"),
    ft = { "markdown", "pandoc.markdown", "rmd", "vimwiki" },
    config = function()
      vim.cmd([[
        let g:vmt_fence_text = 'TOC'
        let g:vmt_fence_closing_text = '/TOC'
        let g:vmt_auto_update_on_save = 1
        let g:vmt_list_item_char = '-'
      ]])
    end,
  },

  -- COMPLETION
  {
    "hrsh7th/nvim-cmp",
    init = utils.lazy_load("nvim-cmp"),
    event = "InsertEnter",
    config = conf("nvim-cmp"),
    dependencies = {
      { "hrsh7th/cmp-nvim-lsp" },
      { "hrsh7th/cmp-path" },
      { "hrsh7th/cmp-buffer" },
      { "hrsh7th/cmp-cmdline" },
      -- { "f3fora/cmp-spell" },
      { "hrsh7th/cmp-emoji" },
      { "davidsierradz/cmp-conventionalcommits" },
      {
        "petertriho/cmp-git",
        config = function()
          require("cmp_git").setup({
            filetypes = { "NeogitCommitMessage", "gitcommit", "octo" },
          })
        end,
      },
      {
        "quangnguyen30192/cmp-nvim-ultisnips",
        cond = function()
          return vim.g.snippet_engine == "ultisnips"
        end,
        config = function()
          require("cmp_nvim_ultisnips").setup({
            filetype_source = "treesitter",
            show_snippets = "all",
            documentation = function(snippet)
              return snippet.value
            end,
          })
        end,
        dependencies = {
          {
            "SirVer/ultisnips",
            config = conf("ultisnips"),
            dependencies = {
              "honza/vim-snippets",
            },
          },
        },
      },
      {
        "saadparwaiz1/cmp_luasnip",
        cond = function()
          return vim.g.snippet_engine == "luasnip"
        end,
        dependencies = {
          {
            "L3MON4D3/LuaSnip",
            event = "BufReadPre",
            version = "v2.*",
            build = "sudo make install_jsregexp",
            config = conf("LuaSnip"),
            dependencies = "rafamadriz/friendly-snippets",
          },
        },
      },
      {
        "zbirenbaum/copilot-cmp",
        config = conf("copilot-cmp"),
        dependencies = {
          {
            -- Make sure to run `:Copilot auth` after install
            "zbirenbaum/copilot.lua",
            cmd = "Copilot",
            config = conf("copilot"),
          },
        },
      },
      -- {
      --   "Exafunction/codeium.nvim",
      --   config = conf("codeium"),
      -- },
    },
  },
  {
    "danymat/neogen",
    init = utils.load_mappings("neogen"),
    cmd = "Neogen",
    config = function()
      require("neogen").setup({
        enabled = true,
        snippet_engine = "luasnip",
      })
    end,
  },
  -- {
  --   "smjonas/snippet-converter.nvim",
  --   cmd = { "ConvertSnippets" },
  --   config = conf("snippet-converter"),
  -- },

  -- CODE RUNNER
  -- {
  --   "michaelb/sniprun",
  --   build = "sh install.sh",
  --   cmd = { "SnipRun", "SnipLive", "SnipInfo" },
  --   config = conf("sniprun", "sniprun"),
  -- },
  {
    "Vigemus/iron.nvim",
    version = "3.*",
    cmd = { "IronRepl" },
    config = conf("iron", "iron"),
  },

  -- WEB DEVELOPMENT
  {
    "rest-nvim/rest.nvim",
    ft = { "http" },
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    config = conf("rest", "rest"),
  },

  -- NOTETAKING
  {
    "nvim-neorg/neorg-telescope",
    init = utils.load_mappings("neorg_telescope"),
    config = conf("neorg-telescope"),
    dependencies = "nvim-telescope/telescope.nvim",
  },
  {
    "nvim-neorg/neorg",
    init = utils.load_mappings("neorg"),
    ft = "norg",
    cmd = { "Neorg", "NeorgOpen", "NeorgNew", "NeorgDoc", "NeorgHelp" },
    config = conf("neorg"),
    dependencies = {
      "vhyrro/luarocks.nvim",
      "nvim-neorg/neorg-telescope",
    },
  },
  {
    "vimwiki/vimwiki",
    branch = "dev",
    cond = vim.fn.expand("%:p:h"):find("/Documents/my%-wiki/") ~= nil, -- NOTE: '-' is a special character and needs to be escaped
    cmd = { "VimwikIndex", "VimwikiDiaryIndex", "VimwikiUISelect" },
    lazy = false,
    init = function()
      utils.load_mappings("vimwiki")
      conf("vimwiki")()
    end,
  },
  {
    "epwalsh/obsidian.nvim",
    -- cond = vim.fn.expand("%:p:h"):find("/obsidian/") ~= nil,
    ft = { "markdown" },
    cmd = { "ObsidianOpen", "ObsidianSearch", "ObsidianQuickSwitch" },
    init = function()
      utils.load_mappings("obsidian")
      conf("obsidian")()
    end,
  },
  -- {
  --   "sedm0784/vim-you-autocorrect",
  --   cond = not vim.g.low_performance_mode,
  --   ft = { "markdown", "vimwiki", "norg" },
  --   cmd = { "EnableAutocorrect", "DisableAutocorrect" },
  --   init = function()
  --     utils.load_mappings("you_autocorrect")
  --     conf("vim-you-autocorrect")()
  --   end,
  -- },

  -- MISC
  -- {
  --   "ThePrimeagen/harpoon",
  --   event = "VimEnter",
  --   init = utils.load_mappings("harpoon"),
  --   config = true,
  -- },
  {
    "m4xshen/hardtime.nvim",
    cond = not vim.g.low_performance_mode,
    event = "VimEnter",
    init = utils.load_mappings("hardtime"),
    config = conf("hardtime"),
    dependencies = { "MunifTanjim/nui.nvim", "nvim-lua/plenary.nvim" },
  },
  {
    "Eandrju/cellular-automaton.nvim",
    cmd = { "CellularAutomaton" },
    init = utils.load_mappings("cellular_automaton"),
  },
  {
    "kawre/leetcode.nvim",
    cmd = "Leet",
    lazy = "leetcode.nvim" ~= vim.fn.argv()[1],
    build = ":TSUpdate html",
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "nvim-lua/plenary.nvim", -- required by telescope
      "MunifTanjim/nui.nvim",
      -- optional
      "nvim-treesitter/nvim-treesitter",
      "rcarriga/nvim-notify",
      "nvim-tree/nvim-web-devicons",
    },
    config = conf("leetcode"),
  }
}, require("user.plugins.lazy_nvim"))
