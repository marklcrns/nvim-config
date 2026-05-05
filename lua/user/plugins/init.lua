
-- TODO:
-- - Move all `utils.load_mappings()` out of `init` and into the
--   plugin's `config` or conf()

--- Use local development version if it exists.
--- @param spec table|string
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

  if not pcall(require, config_path) then
    return function()
      require(config_name).setup({})
    end
  end

  return require(config_path)
end

-- Category switches (set in vimrc)
local lsp_enabled        = vim.g.lsp_enabled ~= false
local treesitter_enabled = vim.g.treesitter_enabled ~= false
local git_enabled        = vim.g.git_enabled ~= false
local notetaking_enabled = vim.g.notetaking_enabled ~= false

require("lazy").setup({

  -- ─── UTILS ────────────────────────────────────────────────────────────────
  "nvim-lua/popup.nvim",
  "nvim-lua/plenary.nvim",
  {
    "tpope/vim-eunuch",
    event = "VimEnter",
    config = conf("eunuch"),
  },
  {
    "rcarriga/nvim-notify",
    cond = not vim.g.low_performance_mode and not sys.is_firenvim(),
    event = "VimEnter",
    init = utils.load_mappings("nvim_notify"),
    config = conf("nvim-notify"),
  },
  {
    "MunifTanjim/nui.nvim",
    cond = not sys.is_firenvim(),
  },
  {
    "folke/snacks.nvim",
    priority = 1000,
    config = conf("snacks"),
    lazy = false,
  },

  -- ─── COLORSCHEMES ─────────────────────────────────────────────────────────
  { "folke/tokyonight.nvim",         config = conf("tokyonight"),       lazy = false },
  { "rebelot/kanagawa.nvim",         config = conf("kanagawa"),         lazy = false },
  { "mcchrish/zenbones.nvim",        dependencies = "rktjmp/lush.nvim", lazy = false },
  { "EdenEast/nightfox.nvim",        config = conf("nightfox"),         lazy = false },
  { "Mofiqul/vscode.nvim",           config = conf("vscode"),           lazy = false },
  { "catppuccin/nvim",               config = conf("catppuccin"),       name = "catppuccin", lazy = false },
  { "rose-pine/neovim",              config = conf("rose-pine"),        name = "rose-pine",  lazy = false },
  { "sainnhe/gruvbox-material",      config = conf("gruvbox-material"), lazy = false },
  { "sindrets/oxocarbon-lua.nvim",   lazy = false },
  { "dgox16/oldworld.nvim",          lazy = false },

  -- ─── UI STYLE ─────────────────────────────────────────────────────────────
  {
    "nvim-tree/nvim-web-devicons",
    config = conf("nvim-web-devicons"),
  },
  {
    "akinsho/bufferline.nvim",
    cond = not sys.is_firenvim(),
    event = "VimEnter",
    dependencies = "nvim-tree/nvim-web-devicons",
    config = conf("bufferline"),
  },
  {
    "feline-nvim/feline.nvim",
    cond = not sys.is_firenvim(),
    config = conf("feline"),
    event = "VeryLazy",
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    init = utils.lazy_load("indent-blankline.nvim"),
    main = "ibl",
    config = conf("indent-blankline"),
  },
  {
    "Darazaki/indent-o-matic",
    event = "VimEnter",
    config = conf("indent-o-matic"),
  },
  {
    "mvllow/modes.nvim",
    init = utils.lazy_load("modes.nvim"),
    config = conf("modes"),
  },
  {
    "folke/noice.nvim",
    cond = not vim.g.low_performance_mode and not sys.is_firenvim(),
    event = "VeryLazy",
    config = conf("noice"),
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
  },
  {
    "xiyaowong/transparent.nvim",
    cond = not vim.g.low_performance_mode and not sys.is_firenvim(),
    init = utils.load_mappings("transparent"),
    lazy = false,
  },

  -- ─── UI INTERFACE ─────────────────────────────────────────────────────────
  {
    "goolord/alpha-nvim",
    cond = not sys.is_firenvim(),
    config = conf("alpha"),
    event = "VimEnter",
  },
  {
    "folke/which-key.nvim",
    keys = { "<leader>", "<localleader>", "]", "[" },
    config = conf("which-key"),
  },
  {
    "folke/zen-mode.nvim",
    cond = not sys.is_firenvim(),
    cmd = "ZenMode",
    init = utils.load_mappings("zen_mode"),
    config = conf("zen-mode"),
  },
  {
    -- NOTE: when zen-mode activates, this will automatically enable
    "folke/twilight.nvim",
    init = utils.load_mappings("twilight"),
    cond = not sys.is_gui() and not vim.g.low_performance_mode and not sys.is_firenvim(),
    event = "VimEnter",
    config = conf("twilight"),
  },
  {
    "szw/vim-maximizer",
    cond = not sys.is_firenvim(),
    init = utils.load_mappings("vim_maximizer"),
    cmd = { "MaximizerToggle" },
    config = function()
      vim.g.maximizer_set_default_mapping = 0
    end,
  },
  {
    "sindrets/winshift.nvim",
    cond = not sys.is_firenvim(),
    init = utils.load_mappings("winshift"),
    cmd = "WinShift",
    config = conf("winshift"),
  },
  {
    "AndrewRadev/linediff.vim",
    init = utils.load_mappings("linediff"),
    cmd = { "Linediff" },
  },

  -- ─── BEHAVIOR ─────────────────────────────────────────────────────────────
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
    cond = not vim.g.low_performance_mode and not sys.is_firenvim(),
    event = "VimEnter",
    config = function()
      utils.load_mappings("spider")
      require("spider").setup({
        skipInsignificantPunctuation = false,
      })
    end,
  },
  {
    "echasnovski/mini.ai",
    event = "VeryLazy",
    config = conf("mini-ai"),
  },
  {
    "kevinhwang91/nvim-hlslens",
    cond = not sys.is_firenvim(),
    init = utils.lazy_load("nvim-hlslens"),
    config = conf("nvim-hlslens", "hlslens"),
  },
  {
    "yorickpeterse/nvim-pqf",
    cond = not sys.is_firenvim(),
    ft = { "qf" },
    config = function()
      require("pqf").setup({
        signs = { error = "", warning = "", info = "", hint = "" },
      })
    end,
  },
  {
    "kevinhwang91/nvim-bqf",
    cond = not sys.is_firenvim(),
    ft = { "qf" },
    config = conf("nvim-bqf"),
  },
  {
    "nvim-focus/focus.nvim",
    cond = not sys.is_gui() and not vim.g.low_performance_mode and not sys.is_firenvim(),
    event = "VimEnter",
    config = conf("focus", "focus"),
  },
  {
    "karb94/neoscroll.nvim",
    cond = not sys.is_gui() and not vim.g.low_performance_mode and not sys.is_firenvim(),
    init = utils.lazy_load("neoscroll.nvim"),
    config = conf("neoscroll"),
  },

  -- ─── FILE NAVIGATION ──────────────────────────────────────────────────────
  {
    "nvim-telescope/telescope.nvim",
    cond = not sys.is_firenvim(),
    cmd = "Telescope",
    config = conf("telescope", "telescope"),
  },
  {
    "nvim-telescope/telescope-fzf-native.nvim",
    cond = not sys.is_firenvim(),
    build = "make",
  },
  {
    "nvim-telescope/telescope-ui-select.nvim",
    cond = not sys.is_firenvim(),
  },
  {
    "debugloop/telescope-undo.nvim",
    cond = not sys.is_firenvim(),
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    cond = not sys.is_firenvim(),
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
    "echasnovski/mini.files",
    cond = not sys.is_firenvim(),
    init = utils.load_mappings("mini_files"),
    config = conf("mini-files"),
  },
  {
    "kshenoy/vim-signature",
    cond = not sys.is_firenvim(),
    init = utils.lazy_load("vim-signature"),
    config = conf("vim-signature"),
  },

  -- ─── CODING HELPER ────────────────────────────────────────────────────────
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
    cond = not sys.is_firenvim(),
    init = function() utils.load_mappings("tabular") end,
    cmd = "Tabularize",
  },
  {
    "kana/vim-niceblock",
    cond = not sys.is_firenvim(),
    init = function()
      utils.lazy_load("vim-niceblock")
      utils.load_mappings("niceblock")
      vim.g.niceblock_use_default_mappings = 0
    end,
  },
  {
    "nvim-pack/nvim-spectre",
    cond = not sys.is_firenvim(),
    event = "VeryLazy",
    init = utils.load_mappings("spectre"),
    config = conf("nvim-spectre"),
    dependencies = { "nvim-lua/plenary.nvim" },
  },
  {
    "johmsalas/text-case.nvim",
    cond = not sys.is_firenvim(),
    event = "BufRead",
    init = utils.load_mappings("text_case"),
  },
  {
    "NvChad/nvim-colorizer.lua",
    cond = not vim.g.low_performance_mode and not sys.is_firenvim(),
    init = utils.lazy_load("nvim-colorizer.lua"),
    config = function(_, opts)
      utils.load_mappings("colorizer")
      require("colorizer").setup(opts)
      vim.defer_fn(function()
        require("colorizer").attach_to_buffer(0)
      end, 0)
    end,
  },

  -- ─── CODE NAVIGATION ──────────────────────────────────────────────────────
  {
    "folke/flash.nvim",
    cond = not sys.is_firenvim(),
    event = "VeryLazy",
    keys = {
      { "s",     mode = { "n", "x", "o" }, function() require("flash").jump() end,              desc = "Flash" },
      { "S",     mode = { "n", "x", "o" }, function() require("flash").treesitter() end,         desc = "Flash Treesitter" },
      { "r",     mode = "o",               function() require("flash").remote() end,             desc = "Remote Flash" },
      { "R",     mode = { "o", "x" },      function() require("flash").treesitter_search() end,  desc = "Treesitter Search" },
      { "<c-s>", mode = { "c" },           function() require("flash").toggle() end,             desc = "Toggle Flash Search" },
    },
  },
  {
    "hedyhli/outline.nvim",
    cond = lsp_enabled and not sys.is_firenvim(),
    init = utils.load_mappings("outline"),
    config = conf("outline"),
    cmd = { "Outline", "OutlineClose", "OutlineOpen" },
  },

  -- ─── INTEGRATIONS ─────────────────────────────────────────────────────────
  {
    "alexghergh/nvim-tmux-navigation",
    event = "VimEnter",
    config = conf("nvim-tmux-navigation"),
  },
  {
    "mrjones2014/smart-splits.nvim",
    cond = not sys.is_firenvim(),
    event = "VimEnter",
    init = utils.load_mappings("smart_splits"),
  },
  {
    "glacambre/firenvim",
    lazy = false,
    build = ":call firenvim#install(0)",
    init = conf("firenvim"),
  },

  -- ─── TREESITTER ───────────────────────────────────────────────────────────
  -- Disable entire section: let g:treesitter_enabled = v:false
  {
    "nvim-treesitter/nvim-treesitter",
    -- Pinned to archived master branch. The new 'main' branch removed configs.setup() API.
    branch = "master",
    cond = treesitter_enabled and not sys.is_firenvim(),
    init = utils.lazy_load("nvim-treesitter"),
    cmd = { "TSInstall", "TSBufEnable", "TSBufDisable", "TSModuleInfo" },
    build = ":TSUpdate",
    config = conf("nvim-treesitter"),
    dependencies = {},
  },
  {
    "RRethy/nvim-treesitter-textsubjects",
    cond = treesitter_enabled and not sys.is_firenvim(),
    init = utils.lazy_load("nvim-treesitter-textsubjects"),
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    cond = treesitter_enabled and not sys.is_firenvim(),
    init = utils.lazy_load("nvim-treesitter-textobjects"),
    config = conf("nvim-treesitter-textobjects"),
  },
  {
    "nvim-treesitter/nvim-treesitter-context",
    cond = treesitter_enabled and not vim.g.low_performance_mode and not sys.is_firenvim(),
    cmd = { "TSContextEnable", "TSContextToggle" },
    event = "VeryLazy",
    config = conf("nvim-treesitter-context", "treesitter_context"),
  },
  {
    "RRethy/nvim-treesitter-endwise",
    cond = treesitter_enabled and not sys.is_firenvim(),
    init = utils.lazy_load("nvim-treesitter-endwise"),
  },
  -- Depends on treesitter
  {
    "HiPhish/rainbow-delimiters.nvim",
    cond = treesitter_enabled and not sys.is_firenvim(),
    submodules = false,
    event = "BufRead",
    config = conf("rainbow-delimiters"),
    dependencies = { "nvim-treesitter/nvim-treesitter" },
  },
  {
    "windwp/nvim-ts-autotag",
    cond = treesitter_enabled,
    init = utils.lazy_load("nvim-ts-autotag"),
    ft = {
      "html", "javascript", "typescript", "javascriptreact", "typescriptreact",
      "svelte", "vue", "tsx", "jsx", "rescript", "xml", "php",
      "glimmer", "handlebars", "hbs",
    },
    config = conf("nvim-ts-autotag"),
  },
  {
    "andymass/vim-matchup",
    cond = treesitter_enabled and not vim.g.low_performance_mode and not sys.is_firenvim(),
    event = "BufRead",
    config = conf("vim-matchup"),
  },
  {
    "gorbit99/codewindow.nvim",
    cond = treesitter_enabled and not vim.g.low_performance_mode and not sys.is_firenvim(),
    event = "VimEnter",
    config = conf("codewindow", "codewindow"),
  },
  {
    "kevinhwang91/nvim-ufo",
    cond = treesitter_enabled and not vim.g.low_performance_mode and not sys.is_firenvim(),
    init = utils.lazy_load("nvim-ufo"),
    config = conf("nvim-ufo"),
    dependencies = { "kevinhwang91/promise-async" },
  },
  {
    "folke/todo-comments.nvim",
    cond = treesitter_enabled and not sys.is_firenvim(),
    init = utils.lazy_load("todo-comments.nvim"),
    config = conf("todo-comments", "todo_comments"),
  },
  {
    "folke/ts-comments.nvim",
    cond = treesitter_enabled and not sys.is_firenvim(),
    opts = {},
    event = "VeryLazy",
    enabled = vim.fn.has("nvim-0.10.0") == 1,
  },

  -- ─── VCS ──────────────────────────────────────────────────────────────────
  -- Disable entire section: let g:git_enabled = v:false
  {
    "sindrets/diffview.nvim",
    cond = git_enabled and not sys.is_firenvim(),
    init = utils.load_mappings("diffview"),
    config = conf("diffview"),
  },
  {
    "TimUntersberger/neogit",
    cond = git_enabled and not sys.is_firenvim(),
    cmd = "Neogit",
    init = utils.load_mappings("neogit"),
    config = conf("neogit"),
  },
  {
    "sindrets/vim-fugitive",
    cond = git_enabled and not sys.is_firenvim(),
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
    cond = git_enabled and not sys.is_firenvim(),
    init = function()
      utils.lazy_load("gitsigns.nvim")
      utils.load_mappings("gitsigns")
    end,
    config = conf("gitsigns"),
  },

  -- ─── LSP ──────────────────────────────────────────────────────────────────
  -- Disable entire section: let g:lsp_enabled = v:false
  {
    "williamboman/mason-lspconfig.nvim",
    cond = lsp_enabled,
    dependencies = {
      {
        "mason-org/mason.nvim",
        build = ":MasonUpdate",
        config = conf("mason"),
      },
      "neovim/nvim-lspconfig",
    },
    opts = {
      automatic_enable = {
        exclude = { "ts_ls", "stylua", "lua_ls", "haxe_language_server" },
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    cond = lsp_enabled,
    init = utils.load_mappings("lsp"),
  },
  {
    "folke/lazydev.nvim",
    cond = lsp_enabled and not sys.is_firenvim(),
    ft = "lua",
    opts = {
      library = {
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    },
  },
  {
    "stevearc/conform.nvim",
    cond = lsp_enabled and not sys.is_firenvim(),
    event = "VeryLazy",
    init = utils.load_mappings("conform"),
    config = conf("conform"),
  },
  {
    "folke/trouble.nvim",
    cond = lsp_enabled and not sys.is_firenvim(),
    cmd = { "Trouble" },
    init = utils.load_mappings("trouble"),
    config = conf("trouble"),
    dependencies = "nvim-tree/nvim-web-devicons",
  },
  {
    "rmagatti/goto-preview",
    cond = lsp_enabled,
    dependencies = { "rmagatti/logger.nvim" },
    init = utils.load_mappings("goto_preview"),
    event = "BufEnter",
    config = true,
  },
  {
    "smjonas/inc-rename.nvim",
    cond = lsp_enabled and not sys.is_firenvim(),
    init = utils.load_mappings("inc_rename"),
    cmd = "IncRename",
    config = true,
  },
  {
    "pmizio/typescript-tools.nvim",
    cond = lsp_enabled and not sys.is_firenvim(),
    dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
  },
  {
    "mfussenegger/nvim-jdtls",
    cond = lsp_enabled and not sys.is_firenvim(),
  },

  -- ─── COMPLETION ───────────────────────────────────────────────────────────
  {
    "Saghen/blink.cmp",
    cond = lsp_enabled and not sys.is_firenvim(),
    dependencies = {
      { "saghen/blink.lib" },
      {
        "saghen/blink.compat",
        lazy = true,
        opts = { impersonate_nvim_cmp = false },
        version = "*",
      },
      "rafamadriz/friendly-snippets",
      "ribru17/blink-cmp-spell",
    },
    build = "cargo build --release",
    config = conf("blink-cmp"),
    opts_extend = { "sources.default", "sources.providers" },
  },
  {
    "zbirenbaum/copilot.lua",
    cond = vim.g.ai_enabled and not sys.is_amazon(),
    cmd = "Copilot",
    event = "VimEnter",
    config = conf("copilot"),
  },

  -- ─── NOTETAKING ───────────────────────────────────────────────────────────
  -- Disable entire section: let g:notetaking_enabled = v:false
  {
    "iamcco/markdown-preview.nvim",
    cond = notetaking_enabled,
    cmd = { "MarkdownPreviewToggle" },
    build = "cd app && yarn install",
    ft = { "markdown" },
    init = utils.load_mappings("markdown_preview"),
  },
  {
    "mzlogin/vim-markdown-toc",
    cond = notetaking_enabled,
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
  {
    "jakewvincent/mkdnflow.nvim",
    cond = notetaking_enabled,
    ft = { "markdown", "rmd" },
    config = conf("mkdnflow"),
  },
  {
    "OXY2DEV/markview.nvim",
    cond = notetaking_enabled and treesitter_enabled,
    ft = "markdown",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    config = conf("markview"),
  },

  -- ─── FILETYPE / SYNTAX ────────────────────────────────────────────────────
  {
    "chrisbra/csv.vim",
    cond = not sys.is_firenvim(),
    ft = "csv",
  },

  -- ─── MISC ─────────────────────────────────────────────────────────────────
  {
    "Eandrju/cellular-automaton.nvim",
    cond = not sys.is_firenvim(),
    cmd = { "CellularAutomaton" },
    init = utils.load_mappings("cellular_automaton"),
  },
  {
    "kawre/leetcode.nvim",
    cond = treesitter_enabled and not sys.is_firenvim(),
    cmd = "Leet",
    lazy = "leetcode.nvim" ~= vim.fn.argv()[1],
    build = ":TSUpdate html",
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-treesitter/nvim-treesitter",
      "rcarriga/nvim-notify",
      "nvim-tree/nvim-web-devicons",
    },
    config = conf("leetcode"),
  },

  -- ─── AMAZON INTERNAL ──────────────────────────────────────────────────────
  {
    name = "vim-code-browse",
    url = "ssh://git.amazon.com:2222/pkg/Vim-code-browse",
    cond = sys.is_amazon() and not sys.is_firenvim(),
    event = "VeryLazy",
    dependencies = { "sindrets/vim-fugitive" },
  },
  {
    name = "amazonq",
    url = "ssh://git.amazon.com/pkg/AmazonQNVim",
    cond = sys.is_amazon() and vim.g.ai_enabled and not sys.is_firenvim(),
    init = utils.load_mappings("amazonq"),
    event = "VeryLazy",
    config = conf("amazonq"),
  },

}, require("user.plugins.lazy_nvim"))
