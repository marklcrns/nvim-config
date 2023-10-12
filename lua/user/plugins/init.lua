local function conf(config_name)
  return require(string.format("user.plugins.%s", config_name))
end

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
  {
    "aliou/bats.vim",
    ft = "bats",
  },

  -- UTILS
  "nvim-lua/popup.nvim",
  "nvim-lua/plenary.nvim",
  "MunifTanjim/nui.nvim",
  {
    "tpope/vim-eunuch",
    event = "VimEnter",
    config = conf("eunuch"),
  },
  {
    "rcarriga/nvim-notify",
    event = "VimEnter",
    config = conf("nvim-notify"),
  },
  {
    -- Overriding lsp_signature. See usr/lsp/init.lua
    "folke/noice.nvim",
    cond = not sys.is_gui(),
    event = "VeryLazy",
    config = conf("noice"),
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
  },
  -- {
  --   "mrded/nvim-lsp-notify",
  --   after = { "nvim-lspconfig" },
  --   event = "VimEnter",
  --   config = function()
  --     -- require("lsp-notify").setup({ notify = require("notify") })
  --     require("lsp-notify").setup()
  --   end,
  -- },
  {
    "xiyaowong/transparent.nvim",
    cond = not sys.is_gui(),
    init = utils.load_mappings("transparent"),
    lazy = false,
  },

  -- COLORSCHEMES
  { "folke/tokyonight.nvim", config = conf("tokyonight"), lazy = false },
  { "catppuccin/nvim", config = conf("catppuccin"), name = "catppuccin", lazy = false },
  { "EdenEast/nightfox.nvim", config = conf("nightfox"), lazy = false },
  { "rebelot/kanagawa.nvim", config = conf("kanagawa"), lazy = false },
  { "AlexvZyl/nordic.nvim", config = conf("nordic"), lazy = false },
  { "rose-pine/neovim", config = conf("rose-pine"), name = "rose-pine", lazy = false },
  { "Mofiqul/vscode.nvim", config = conf("vscode"), lazy = false },
  { "sindrets/oxocarbon-lua.nvim", lazy = false },
  { "kvrohit/rasmus.nvim", lazy = false },
  { "mcchrish/zenbones.nvim", dependencies = "rktjmp/lush.nvim", lazy = false },

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
    init = utils.load_mappings("spider"),
    config = function()
      require("spider").setup({
        skipInsignificantPunctuation = false,
      })
    end,
    event = "VimEnter",
  },
  {
    "kevinhwang91/nvim-ufo",
    init = utils.lazy_load("nvim-ufo"),
    config = conf("nvim-ufo"),
    dependencies = {
      "kevinhwang91/promise-async",
    },
  },
  {
    "kevinhwang91/nvim-hlslens",
    init = utils.load_mappings("hlslens"),
    event = "BufRead",
    config = conf("nvim-hlslens"),
  },
  {
    url = "https://gitlab.com/yorickpeterse/nvim-pqf.git",
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
    init = utils.load_mappings("focus"),
    event = "VimEnter",
    config = conf("focus"),
  },
  {
    "levouh/tint.nvim",
    init = utils.load_mappings("tint"),
    event = "WinEnter",
    config = conf("tint"),
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
  {
    "karb94/neoscroll.nvim",
    cond = not sys.is_gui(),
    init = utils.lazy_load("neoscroll.nvim"),
    config = conf("neoscroll"),
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
    dependencies = { "HiPhish/rainbow-delimiters.nvim" },
  },
  {
    "Darazaki/indent-o-matic",
    init = utils.lazy_load("indent-o-matic"),
    config = conf("indent-o-matic"),
  },
  {
    "HiPhish/rainbow-delimiters.nvim",
    event = "BufRead",
    config = conf("rainbow-delimiters"),
    dependencies = { "nvim-treesitter/nvim-treesitter" },
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
  {
    "HampusHauffman/block.nvim",
    cmd = { "Block", "BlockOn" },
    config = true,
  },

  -- UI INTERFACE
  {
    -- Needed by common.utils
    "sindrets/diffview.nvim",
    init = utils.load_mappings("diffview"),
    config = conf("diffview"),
  },
  {
    "folke/which-key.nvim",
    keys = { "<leader>", "<localleader>", "]", "[" },
    config = conf("which-key"),
  },
  {
    "folke/zen-mode.nvim",
    cmd = "ZenMode",
    init = utils.load_mappings("zen_mode"),
    config = conf("zen-mode"),
  },
  {
    "gorbit99/codewindow.nvim",
    init = utils.load_mappings("codewindow"),
    event = "VimEnter",
    config = conf("codewindow"),
  },
  -- {
  --   "Pocco81/true-zen.nvim",
  --   cmd = { "TZAtaraxis", "TZMinimalist", "TZFocus", "TZNarrow" },
  --   init = utils.load_mappings("true_zen"),
  --   config = conf("true-zen"),
  -- },
  -- {
  --   "Bekaboo/dropbar.nvim",
  --   cond = not sys.is_gui(),
  --   init = utils.load_mappings("dropbar"),
  --   event = "VimEnter",
  --   config = conf("dropbar"),
  --   dependencies = {
  --     "nvim-tree/nvim-web-devicons",
  --   },
  -- },

  -- FILE NAVIGATION
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    init = utils.load_mappings("telescope"),
    config = conf("telescope"),
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
        version = "2.*",
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
  {
    "ahmedkhalf/project.nvim",
    event = "VimEnter",
    config = conf("project"),
  },

  -- CODING HELPER
  {
    "numToStr/Comment.nvim",
    init = utils.lazy_load("Comment.nvim"),
    config = true,
  },
  {
    "kylechui/nvim-surround",
    init = utils.lazy_load("nvim-surround"),
    config = true,
  },
  {
    "windwp/nvim-autopairs",
    init = utils.lazy_load("nvim-autopairs"),
    config = conf("nvim-autopairs"),
  },
  {
    "windwp/nvim-ts-autotag",
    init = utils.lazy_load("nvim-ts-autotag"),
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
    event = "BufRead",
    config = conf("vim-matchup"),
  },
  {
    "bennypowers/nvim-regexplainer",
    init = utils.load_mappings("regexplainer"),
    cmd = "RegexplainerToggle",
    conf = function()
      require("regexplainer").setup({ auto = false })
    end,
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "MunifTanjim/nui.nvim",
    },
  },
  {
    "AckslD/muren.nvim",
    init = utils.load_mappings("muren"),
    cmd = { "MurenToggle", "MurenOpen", "MurenUnique" },
    config = conf("muren"),
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
  {
    "smjonas/inc-rename.nvim",
    init = utils.load_mappings("inc_rename"),
    cmd = "IncRename",
    config = true,
  },

  -- VCS
  {
    "TimUntersberger/neogit",
    cmd = "Neogit",
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

  -- INTEGRATION
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
    event = "VeryLazy",
    config = conf("nvim-treesitter-context"),
  },
  {
    "RRethy/nvim-treesitter-endwise",
    init = utils.lazy_load("nvim-treesitter-endwise"),
  },
  {
    "folke/todo-comments.nvim",
    init = function()
      utils.load_mappings("todo_comments")
      utils.lazy_load("todo-comments.nvim")
    end,
    config = conf("todo-comments"),
  },
  {
    "NvChad/nvim-colorizer.lua",
    init = function()
      utils.lazy_load("nvim-colorizer.lua")
      utils.load_mappings("colorizer")
    end,
    config = function(_, opts)
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
    init = utils.load_mappings("mason"),
    build = ":MasonUpdate",
    cmd = { "Mason", "MasonInstall", "MasonInstallAll", "MasonUninstall", "MasonUninstallAll", "MasonLog" },
    config = conf("mason"),
  },
  {
    "williamboman/mason-lspconfig.nvim",
    event = "VimEnter",
    config = conf("mason-lspconfig"),
  },
  {
    "jayp0521/mason-null-ls.nvim",
    event = "VimEnter",
    config = conf("mason-null-ls"),
  },
  {
    "ray-x/lsp_signature.nvim",
    event = "InsertEnter",
    config = conf("lsp_signature"),
  },
  {
    init = utils.load_mappings("toggle_lsp_diagnostics"),
    "WhoIsSethDaniel/toggle-lsp-diagnostics.nvim",
    config = conf("toggle-lsp-diagnostics"),
  },
  {
    "folke/trouble.nvim",
    init = utils.load_mappings("trouble"),
    event = "VimEnter", -- NOTE: This is needed to load Config.fn.toggle_diagnostics()
    config = conf("trouble"),
    dependencies = "nvim-tree/nvim-web-devicons",
  },
  {
    "simrat39/symbols-outline.nvim",
    init = utils.load_mappings("symbols_outline"),
    cmd = { "SymbolsOutline", "SymbolsOutlineOpen", "SymbolsOutlineClose" },
    config = conf("symbols-outline"),
  },

  -- LANGUAGES + TOOLS
  {
    "folke/neodev.nvim",
    after = "nvim-lspconfig",
    -- NOTE: Defined in lua/init.lua
    -- config = true,
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
      { "f3fora/cmp-spell" },
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
            version = "<CurrentMajor>.*",
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
      {
        "windwp/nvim-autopairs",
        config = conf("nvim-autopairs"),
      },
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
  {
    "smjonas/snippet-converter.nvim",
    cmd = { "ConvertSnippets" },
    config = conf("snippet-converter"),
  },

  -- NOTETAKING
  {
    "nvim-neorg/neorg",
    init = utils.load_mappings("neorg"),
    build = ":Neorg sync-parsers",
    ft = "norg",
    cmd = { "Neorg", "NeorgOpen", "NeorgNew", "NeorgDoc", "NeorgHelp" },
    config = conf("neorg"),
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        "nvim-neorg/neorg-telescope",
        init = utils.load_mappings("neorg_telescope"),
        config = conf("neorg-telescope"),
        dependencies = "nvim-telescope/telescope.nvim",
      },
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
    "sedm0784/vim-you-autocorrect",
    ft = { "markdown", "vimwiki", "norg" },
    cmd = { "EnableAutocorrect", "DisableAutocorrect" },
    init = function()
      conf("vim-you-autocorrect")()
      utils.load_mappings("you_autocorrect")
    end,
  },
  {
    "jbyuki/venn.nvim",
    cmd = { "VBox", "VBoxD", "VBoxH", "VFill" },
    init = function()
      conf("venn")()
      utils.load_mappings("venn")
    end,
  },

  -- MISC
  {
    "Dhanus3133/LeetBuddy.nvim",
    cmd = { "LBQuestions" },
    init = utils.load_mappings("leetbuddy"),
    config = conf("leetbuddy"),
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
    },
  },
  {
    "ThePrimeagen/harpoon",
    event = "VimEnter",
    init = utils.load_mappings("harpoon"),
    config = true,
  },
  {
    "m4xshen/hardtime.nvim",
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
}, require("user.plugins.lazy_nvim"))
