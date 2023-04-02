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

  local local_path = spec.local_path or vim.env.NVIM_LOCAL_PLUGINS or (vim.env.HOME .. "/Documents/dev/nvim/plugins")
  local path = local_path .. "/" .. name

  if vim.fn.isdirectory(path) == 1 then
    spec.dir = path
  end

  return spec
end

require("lazy").setup({
  -- UTILS
  "nvim-lua/popup.nvim",
  "nvim-lua/plenary.nvim",
  "MunifTanjim/nui.nvim",

  -- COLORSCHEMES
  "sindrets/oxocarbon-lua.nvim",
  "AlexvZyl/nordic.nvim",
  {
    "folke/tokyonight.nvim", -- Default
    lazy = false,
    priority = 1000,
    config = conf("tokyonight"),
  },

  -- STARTUP
  { "goolord/alpha-nvim", config = conf("alpha"), event = "VimEnter" },

  -- BEHAVIOR
  {
    "marklcrns/vim-smartq",
    init = require("user.core.utils").load_mappings("smartq"),
    event = "VimEnter",
    config = conf("vim-smartq"),
  },
  -- TODO: map
  { "kevinhwang91/nvim-bqf", config = conf("nvim-bqf") },
  {
    "sindrets/winshift.nvim",
    init = require("user.core.utils").load_mappings("winshift"),
    cmd = "WinShift",
    config = conf("winshift"),
  },
  {
    "beauwilliams/focus.nvim",
    init = require("user.core.utils").load_mappings("focus"),
    event = "BufRead",
    config = conf("vimade"),
  },
  {
    "TaDaa/vimade",
    init = require("user.core.utils").load_mappings("vimade"),
    event = "VimEnter",
    config = conf("vimade"),
  },
  {
    "marklcrns/lens.vim",
    init = require("user.core.utils").load_mappings("lens"),
    event = "VimEnter",
    config = conf("lens"),
    dependencies = {
      {
        "camspiers/animate.vim",
        cond = not Config.common.sys.is_gui(),
        event = "VimEnter",
        config = conf("animate"),
      },
    },
  },
  {
    "karb94/neoscroll.nvim",
    cond = not Config.common.sys.is_gui(),
    init = require("user.core.utils").lazy_load("neoscroll.nvim"),
    config = conf("neoscroll"),
  },

  -- UI STYLE
  { "kyazdani42/nvim-web-devicons", config = conf("nvim-web-devicons") },
  {
    "mrded/nvim-lsp-notify",
    config = function()
      require("lsp-notify").setup({ notify = require("notify") })
    end,
    dependencies = {
      {
        "rcarriga/nvim-notify",
        config = conf("nvim-notify"),
      },
    },
  },
  {
    "RRethy/vim-illuminate",
    init = require("user.core.utils").lazy_load("vim-illuminate"),
    config = conf("vim-illuminate"),
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    init = require("user.core.utils").lazy_load("indent-blankline.nvim"),
    config = conf("indent-blankline"),
  },
  { "Darazaki/indent-o-matic", config = conf("indent-o-matic") },
  {
    "akinsho/bufferline.nvim",
    init = require("user.core.utils").lazy_load("bufferline.nvim"),
    dependencies = "kyazdani42/nvim-web-devicons",
    event = "VimEnter",
    config = conf("bufferline"),
  },
  {
    "feline-nvim/feline.nvim",
    init = require("user.core.utils").lazy_load("feline.nvim"),
    config = conf("feline"),
  },

  -- UI INTERFACE
  {
    -- Needed by common.utils
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewFileHistory" },
    init = require("user.core.utils").load_mappings("diffview"),
    config = conf("diffview"),
  },
  {
    "folke/which-key.nvim",
    keys = { "<leader>", "<localleader>" },
    config = conf("which-key"),
  },
  {
    "folke/zen-mode.nvim",
    cmd = "ZenMode",
    init = require("user.core.utils").load_mappings("zen_mode"),
    config = conf("zen-mode"),
  },
  {
    "simnalamburt/vim-mundo",
    cmd = "MundoToggle",
    init = require("user.core.utils").load_mappings("vim_mundo"),
  },

  -- FILE NAVIGATION
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    init = require("user.core.utils").load_mappings("telescope"),
    config = conf("telescope"),
  },
  { "nvim-telescope/telescope-fzf-native.nvim", "telescope.nvim", build = "make" },
  { "nvim-telescope/telescope-media-files.nvim", "telescope.nvim" },
  { "nvim-telescope/telescope-ui-select.nvim", "telescope.nvim" },
  {
    "nvim-neo-tree/neo-tree.nvim",
    cmd = "Neotree",
    init = require("user.core.utils").load_mappings("neo_tree"),
    config = conf("neo-tree"),
    dependencies = {
      {
        "s1n7ax/nvim-window-picker",
        init = require("user.core.utils").load_mappings("nvim_window_picker"),
        version = "1.*",
        config = conf("nvim-window-picker"),
      },
    },
  },
  {
    "kshenoy/vim-signature",
    init = require("user.core.utils").lazy_load("vim-signature"),
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
    init = require("user.core.utils").lazy_load("Comment.nvim"),
    config = function()
      require("Comment").setup()
    end,
  },
  {
    "kylechui/nvim-surround",
    init = require("user.core.utils").lazy_load("nvim-surround"),
    config = function()
      require("nvim-surround").setup()
    end,
  },
  {
    "windwp/nvim-autopairs",
    init = require("user.core.utils").lazy_load("nvim-autopairs"),
    config = conf("nvim-autopairs"),
  },
  {
    "windwp/nvim-ts-autotag",
    init = require("user.core.utils").lazy_load("nvim-ts-autotag"),
    config = conf("nvim-ts-autotag"),
  },
  {
    "Wansmer/treesj",
    init = require("user.core.utils").load_mappings("treesj"),
    event = "BufRead",
    config = conf("treesj"),
  },
  {
    "monaqa/dial.nvim",
    init = require("user.core.utils").load_mappings("dial"),
    event = "BufRead",
    config = conf("dial"),
  },

  -- VCS
  {
    "TimUntersberger/neogit",
    cmd = "Neogit",
    init = require("user.core.utils").load_mappings("neogit"),
    config = conf("neogit"),
  },
  {
    "lewis6991/gitsigns.nvim",
    init = require("user.core.utils").lazy_load("gitsigns.nvim"),
    config = conf("gitsigns"),
  },

  -- INTEGRATION
  {
    "alexghergh/nvim-tmux-navigation",
    event = "VimEnter",
    config = conf("nvim-tmux-navigation"),
  },

  -- SYNTAX & FILETYPE PLUGINS
  {
    "nvim-treesitter/nvim-treesitter",
    init = require("user.core.utils").lazy_load("nvim-treesitter"),
    cmd = { "TSInstall", "TSBufEnable", "TSBufDisable", "TSModuleInfo" },
    build = ":TSUpdate",
    config = conf("nvim-treesitter"),
    dependencies = {
      { "RRethy/nvim-treesitter-textsubjects" },
      {
        "nvim-treesitter/nvim-treesitter-textobjects",
        config = conf("nvim-treesitter-textobjects"),
      },
      {
        "nvim-treesitter/nvim-treesitter-context",
        config = conf("nvim-treesitter-context"),
      },
      {
        "RRethy/nvim-treesitter-endwise",
        config = conf("nvim-ts-autotag"),
      },
      {
        "andymass/vim-matchup",
        config = conf("vim-matchup"),
      },
    },
  },
  {
    "folke/todo-comments.nvim",
    init = require("user.core.utils").lazy_load("todo-comments.nvim"),
    config = conf("todo-comments"),
  },
  {
    "NvChad/nvim-colorizer.lua",
    init = require("user.core.utils").lazy_load("nvim-colorizer.lua"),
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
    init = require("user.core.utils").load_mappings("lsp"),
  },
  {
    "jose-elias-alvarez/null-ls.nvim",
    config = conf("null-ls"),
  },
  {
    "williamboman/mason.nvim",
    init = require("user.core.utils").load_mappings("mason"),
    cmd = { "Mason", "MasonInstall", "MasonInstallAll", "MasonUninstall", "MasonUninstallAll", "MasonLog" },
    config = conf("mason"),
  },
  {
    "williamboman/mason-lspconfig.nvim",
    after = { "mason.nvim", "nvim-lspconfig" },
    config = conf("mason-lspconfig"),
  },
  {
    "jayp0521/mason-null-ls.nvim",
    after = { "mason.nvim", "null-ls.nvim" },
    config = conf("mason-null-ls"),
  },
  {
    "ray-x/lsp_signature.nvim",
    event = "InsertEnter",
    config = conf("lsp_signature"),
  },
  {
    init = require("user.core.utils").load_mappings("toggle_lsp_diagnostics"),
    "WhoIsSethDaniel/toggle-lsp-diagnostics.nvim",
    config = conf("toggle-lsp-diagnostics"),
  },
  {
    "simrat39/symbols-outline.nvim",
    init = require("user.core.utils").load_mappings("symbols_outline"),
    cmd = { "SymbolsOutline" },
    config = conf("symbols-outline"),
  },

  -- COMPLETION
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    config = conf("nvim-cmp"),
    dependencies = {
      { "hrsh7th/cmp-nvim-lsp" },
      { "hrsh7th/cmp-path" },
      { "hrsh7th/cmp-buffer" },
      { "hrsh7th/cmp-cmdline" },
      { "f3fora/cmp-spell" },
      { "hrsh7th/cmp-emoji" },
      { "petertriho/cmp-git" },
      { "saadparwaiz1/cmp_luasnip" },
      { "davidsierradz/cmp-conventionalcommits" },
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
        "L3MON4D3/LuaSnip",
        version = "<CurrentMajor>.*",
        config = conf("LuaSnip"),
        dependencies = "rafamadriz/friendly-snippets",
      },
      {
        "windwp/nvim-autopairs",
        config = conf("nvim-autopairs"),
      },
    },
  },

  -- NOTETAKING
  {
    "vimwiki/vimwiki",
    cmd = { "VimwikIndex", "VimwikiDiaryIndex", "VimwikiUISelect" },
    init = require("user.core.utils").load_mappings("vimwiki"),
    config = function()
      vim.cmd("source " .. vim.fn.stdpath("config") .. "/usr/plugins/vimwiki.vim")
    end,
  },
}, require("user.plugins.lazy_nvim"))