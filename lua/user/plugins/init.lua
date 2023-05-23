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
  -- UTILS
  "nvim-lua/popup.nvim",
  "nvim-lua/plenary.nvim",
  "MunifTanjim/nui.nvim",
  {
    "rcarriga/nvim-notify",
    event = "VimEnter",
    config = conf("nvim-notify"),
  },
  -- {
  --   -- Overriding lsp_signature. See usr/lsp/init.lua
  --   "folke/noice.nvim",
  --   event = "VimEnter",
  --   config = conf("noice"),
  --   dependencies = {
  --     "MunifTanjim/nui.nvim",
  --     "rcarriga/nvim-notify",
  --   },
  -- },
  -- {
  --   "mrded/nvim-lsp-notify",
  --   after = { "nvim-lspconfig" },
  --   event = "VimEnter",
  --   config = function()
  --     -- require("lsp-notify").setup({ notify = require("notify") })
  --     require("lsp-notify").setup()
  --   end,
  -- },

  -- COLORSCHEMES
  { "folke/tokyonight.nvim", config = conf("tokyonight"), },
  { "catppuccin/nvim", config = conf("catppuccin"), name = "catppuccin" },
  { "EdenEast/nightfox.nvim", config = conf("nightfox"), },
  { "rebelot/kanagawa.nvim", config = conf("kanagawa"), },
  { "AlexvZyl/nordic.nvim", config = conf("nordic"), },
  { "rose-pine/neovim", config = conf("rose-pine"), name = "rose-pine" },
  { "Mofiqul/vscode.nvim", config = conf("vscode"), },
  "sindrets/oxocarbon-lua.nvim",

  -- STARTUP
  { "goolord/alpha-nvim", config = conf("alpha"), event = "VimEnter" },

  -- BEHAVIOR
  {
    "marklcrns/vim-smartq",
    init = utils.load_mappings("smartq"),
    event = "VimEnter",
    config = conf("vim-smartq"),
  },
  {
    "chrisgrieser/nvim-spider",
    init = utils.load_mappings("spider"),
    config = function()
      require("spider").setup({
        skipInsignificantPunctuation = true,
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
  -- TODO: map
  { "kevinhwang91/nvim-bqf", config = conf("nvim-bqf") },
  {
    "sindrets/winshift.nvim",
    init = utils.load_mappings("winshift"),
    cmd = "WinShift",
    config = conf("winshift"),
  },
  {
    "beauwilliams/focus.nvim",
    init = utils.load_mappings("focus"),
    event = "VimEnter",
    config = conf("focus"),
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
  { "kyazdani42/nvim-web-devicons", config = conf("nvim-web-devicons") },
  {
    "lukas-reineke/indent-blankline.nvim",
    init = utils.lazy_load("indent-blankline.nvim"),
    config = conf("indent-blankline"),
  },
  {
    "Darazaki/indent-o-matic",
    init = utils.lazy_load("indent-o-matic"),
    config = conf("indent-o-matic"),
  },
  {
    "akinsho/bufferline.nvim",
    event = "VimEnter",
    dependencies = "kyazdani42/nvim-web-devicons",
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
  { "debugloop/telescope-undo.nvim" },
  {
    "nvim-neo-tree/neo-tree.nvim",
    cmd = "Neotree",
    init = utils.load_mappings("neo_tree"),
    config = conf("neo-tree"),
    dependencies = {
      {
        "s1n7ax/nvim-window-picker",
        init = utils.load_mappings("nvim_window_picker"),
        version = "1.*",
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
    config = function()
      require("Comment").setup()
    end,
  },
  {
    "kylechui/nvim-surround",
    init = utils.lazy_load("nvim-surround"),
    config = function()
      require("nvim-surround").setup()
    end,
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
    "danymat/neogen",
    init = utils.load_mappings("neogen"),
    cmd = "Neogen",
    config = function()
      require("neogen").setup({
        enabled = true,
        -- snippet_engine = "luasnip",
      })
    end,
  },
  {
    "RRethy/vim-illuminate",
    event = "VeryLazy",
    config = conf("vim-illuminate"),
  },
  {
    "andymass/vim-matchup",
    event = "VeryLazy",
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
        init = function()
          vim.g.flog_default_opts = { max_count = 512 }
          vim.g.flog_override_default_mappings = {}
          vim.g.flog_jumplist_default_mappings = {}
          vim.g.flog_use_internal_lua = true
        end,
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
  {
    "jackMort/ChatGPT.nvim",
    event = "VeryLazy",
    init = utils.load_mappings("chatgpt"),
    config = conf("ChatGPT"),
    dependencies = {
      "MunifTanjim/nui.nvim",
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
    },
  },

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
    config = conf("nvim-ts-autotag"),
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
  {
    "chrisbra/csv.vim",
    ft = "csv",
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
    cmd = { "TroubleToggle", "Trouble" },
    config = conf("trouble"),
    dependencies = "nvim-web-devicons",
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
    -- config = function()
    --   require("neodev").setup({})
    -- end,
  },
  {
    "iamcco/markdown-preview.nvim",
    init = utils.load_mappings("markdown_preview"),
    build = "cd app && yarn install",
    ft = { "markdown", "pandoc.markdown", "rmd" },
    config = conf("markdown-preview"),
  },
  {
    "mzlogin/vim-markdown-toc",
    init = utils.load_mappings("markdown_toc"),
    ft = { "markdown", "pandoc.markdown", "rmd" },
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
      -- {
      --   "saadparwaiz1/cmp_luasnip",
      --   dependencies = {
      --     {
      --       "L3MON4D3/LuaSnip",
      --       version = "<CurrentMajor>.*",
      --       config = conf("LuaSnip"),
      --       dependencies = "rafamadriz/friendly-snippets",
      --     },
      --   },
      -- },
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
    "lervag/vimtex",
    ft = { "plaintex", "tex", "latex", "markdown" },
    config = conf("vimtex"),
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
    init = function()
      conf("vim-you-autocorrect")()
      utils.load_mappings("you_autocorrect")
    end,
  },
}, require("user.plugins.lazy_nvim"))
