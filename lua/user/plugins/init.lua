
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

-- ─── Colorscheme auto-lazy helper ──────────────────────────────────────────
-- Resolves the active colorscheme name from vim.g.colorscheme (or env var)
-- using the same rules as lua/user/colorscheme.lua. The cs() helper then
-- auto-sets lazy/priority so the active one loads eagerly and everything
-- else lazy-loads on :colorscheme <name>.
local function resolve_active_colorscheme()
  -- Pick the first non-empty source; don't rely on ipairs (stops at nils).
  local raw = (vim.env.NVIM_COLORSCHEME ~= nil and vim.env.NVIM_COLORSCHEME ~= "")
      and vim.env.NVIM_COLORSCHEME
    or (vim.g.colorscheme ~= nil and vim.g.colorscheme ~= "")
      and vim.g.colorscheme
    or "default_dark"
  local name = vim.split(raw, "%s+", {})[1]
  if name == "default_dark"  then return vim.g.default_dark_colorscheme  or "tokyonight"  end
  if name == "default_light" then return vim.g.default_light_colorscheme or "seoulbones"  end
  return name
end

local active_cs = resolve_active_colorscheme()

--- Colorscheme plugin spec helper. Auto-sets lazy/priority based on whether
--- the plugin provides the active colorscheme.
--- @param repo string  Plugin repo like "folke/tokyonight.nvim"
--- @param opts? table  Standard lazy.nvim spec fields. Extra field:
---   - provides: string[] list of colorscheme names this plugin registers
---     (defaults to the plugin name, stripped of ".nvim" suffix). Used by
---     multi-scheme plugins like zenbones.
local function cs(repo, opts)
  opts = opts or {}
  -- Derive the colorscheme name for active-matching only (NOT for opts.name,
  -- which affects lazy's plugin directory). Use explicit opts.name when set.
  local derived_name = (opts.name or repo:match("[^/]+$")):gsub("%.nvim$", "")
  local provides = opts.provides or { derived_name }
  opts.provides = nil
  local active = vim.tbl_contains(provides, active_cs)
  opts[1] = repo
  opts.lazy = not active
  if active then opts.priority = 1000 end
  return opts
end

require("lazy").setup({

  -- ─── UTILS ────────────────────────────────────────────────────────────────
  "nvim-lua/plenary.nvim",
  {
    "tpope/vim-eunuch",
    cmd = { "Rename", "Move", "Duplicate", "Delete", "Unlink", "Remove", "Copy",
            "Mkdir", "Chmod", "SudoWrite", "SudoEdit", "Wall",
            "Cfind", "Clocate", "Lfind", "Llocate" },
    config = conf("eunuch"),
  },
  {
    "rcarriga/nvim-notify",
    cond = not vim.g.low_performance_mode and not sys.is_firenvim(),
    event = "VeryLazy",
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
  -- Active colorscheme (set via g:colorscheme in vimrc) loads eagerly with
  -- priority 1000; all others lazy-load when `:colorscheme <name>` is run.
  cs("folke/tokyonight.nvim",     { config = conf("tokyonight") }),
  cs("mcchrish/zenbones.nvim",    {
    dependencies = "rktjmp/lush.nvim",
    provides = {
      "zenbones", "seoulbones", "neobones", "zenwritten", "duckbones",
      "forestbones", "tokyobones", "rosebones", "kanagawabones", "nordbones",
      "vimbones", "randombones",
    },
  }),
  cs("rebelot/kanagawa.nvim",     { config = conf("kanagawa") }),
  cs("EdenEast/nightfox.nvim",    { config = conf("nightfox") }),
  cs("Mofiqul/vscode.nvim",       { config = conf("vscode") }),
  cs("catppuccin/nvim",           { name = "catppuccin", config = conf("catppuccin") }),
  cs("rose-pine/neovim",          { name = "rose-pine",  config = conf("rose-pine") }),
  cs("sainnhe/gruvbox-material",  { config = conf("gruvbox-material") }),
  cs("sindrets/oxocarbon-lua.nvim", {}),
  cs("dgox16/oldworld.nvim",      {}),

  -- ─── UI STYLE ─────────────────────────────────────────────────────────────
  {
    "nvim-tree/nvim-web-devicons",
    lazy = true,
    config = conf("nvim-web-devicons"),
  },
  {
    "akinsho/bufferline.nvim",
    cond = not sys.is_firenvim(),
    event = "UIEnter",
    dependencies = "nvim-tree/nvim-web-devicons",
    config = conf("bufferline"),
  },
  {
    "nvim-lualine/lualine.nvim",
    cond = not sys.is_firenvim(),
    event = "VeryLazy",
    dependencies = "nvim-tree/nvim-web-devicons",
    config = conf("lualine"),
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    event = "BufReadPre",
    main = "ibl",
    config = conf("indent-blankline"),
  },
  {
    "Darazaki/indent-o-matic",
    event = "BufReadPost",
    config = conf("indent-o-matic"),
  },
  {
    "mvllow/modes.nvim",
    event = "ModeChanged",
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
    cmd = { "TransparentToggle", "TransparentEnable", "TransparentDisable" },
    init = utils.load_mappings("transparent"),
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
    cmd = { "Twilight", "TwilightEnable", "TwilightDisable" },
    config = conf("twilight"),
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
    cmd = { "SmartQSave", "SmartQCloseSplits" },
  },
  {
    "chrisgrieser/nvim-spider",
    cond = not vim.g.low_performance_mode and not sys.is_firenvim(),
    keys = {
      { "w",  mode = { "n", "o", "x" }, function() require("spider").motion("w")  end, desc = "spider-w" },
      { "e",  mode = { "n", "o", "x" }, function() require("spider").motion("e")  end, desc = "spider-e" },
      { "b",  mode = { "n", "o", "x" }, function() require("spider").motion("b")  end, desc = "spider-b" },
      { "ge", mode = { "n", "o", "x" }, function() require("spider").motion("ge") end, desc = "spider-ge" },
    },
    config = function()
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
    event = "VeryLazy",
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
  -- ─── CODING HELPER ────────────────────────────────────────────────────────
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
    keys = { { "<leader>cs", desc = "split/join code" } },
    config = conf("treesj"),
  },
  {
    "monaqa/dial.nvim",
    init = utils.load_mappings("dial"),
    keys = {
      { "<C-a>",  mode = { "n", "v" }, desc = "dial increment" },
      { "<C-x>",  mode = { "n", "v" }, desc = "dial decrement" },
      { "g<C-a>", mode = "v",          desc = "dial increment (additive)" },
      { "g<C-x>", mode = "v",          desc = "dial decrement (additive)" },
    },
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
    event = "VimEnter",
    init = function()
      vim.g.niceblock_use_default_mappings = 0
      utils.load_mappings("niceblock")
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
  {
    "chentoast/marks.nvim",
    cond = not sys.is_firenvim(),
    keys = {
      { "m", mode = { "n", "v" }, desc = "marks.nvim prefix" },
      { "dm", desc = "marks.nvim delete prefix" },
      { "]'", desc = "next mark (line)" }, { "]`", desc = "next mark (pos)" },
      { "['", desc = "prev mark (line)" }, { "[`", desc = "prev mark (pos)" },
    },
    config = conf("marks"),
  },

  -- ─── INTEGRATIONS ─────────────────────────────────────────────────────────
  {
    "mrjones2014/smart-splits.nvim",
    cond = not sys.is_firenvim(),
    event = "VeryLazy",
    init = utils.load_mappings("smart_splits"),
  },
  {
    "sindrets/winshift.nvim",
    cond = not sys.is_firenvim(),
    init = utils.load_mappings("winshift"),
    cmd = "WinShift",
    config = conf("winshift"),
  },
  {
    "glacambre/firenvim",
    -- firenvim's binary passes `--cmd 'let g:started_by_firenvim = v:true'`
    -- to nvim BEFORE init.lua runs. `v:true` becomes Lua `true`, not `1`,
    -- so we do a truthy check (not equality with 1) to detect browser mode.
    cond = function() return vim.g.started_by_firenvim end,
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
    keys = {
      { "<leader>imm", desc = "toggle minimap" },
      { "<leader>imf", desc = "toggle minimap focus" },
    },
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
    event = "BufReadPre",
    init = utils.load_mappings("todo_comments"),
    config = conf("todo-comments"),
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
    -- Note: don't exclude via sys.is_firenvim() here. diffview.path is used
    -- by lua/user/common/utils.lua as the path library (M.pl). Excluding
    -- diffview in firenvim mode makes utils fail to load. Diffview itself
    -- is lazy (no event/cmd/keys/ft triggers below means lazy.nvim treats
    -- it as needs-explicit-require; the plugin only activates on :Diffview*
    -- commands), so no startup cost in firenvim mode either way.
    cond = git_enabled,
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
    "tpope/vim-fugitive",
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
      -- LSP servers mason-lspconfig should keep installed. Missing ones are
      -- auto-installed async at Neovim startup. Present ones are skipped.
      -- Add more here as needs grow (use lspconfig names, not mason pkg names).
      ensure_installed = {
        "bashls",          -- bash-language-server
        "clangd",          -- C/C++
        "cssls",           -- css-lsp
        "dockerls",        -- dockerfile-language-server
        "emmet_ls",        -- emmet-ls
        "eslint",          -- eslint-lsp
        "html",            -- html-lsp
        "jsonls",          -- json-lsp
        "lua_ls",          -- lua-language-server
        "pyright",         -- python
        "rust_analyzer",   -- rust
        "tailwindcss",     -- tailwindcss-language-server
        "taplo",           -- toml
        "vimls",           -- vim-language-server
        "yamlls",          -- yaml-language-server
        -- Handled separately (not in ensure_installed):
        --   jdtls (Java)      → installed by mason, started via FileType autocmd
        --   omnisharp (C#)    → already installed; keep as optional opt-in
        --   svlangserver      → already installed; keep as optional opt-in
        --   luau_lsp          → already installed; keep as optional opt-in
        --   clojure_lsp       → already installed; keep as optional opt-in
      },
      automatic_enable = {
        -- Servers we configure manually — don't let mason-lspconfig auto-enable
        -- them with its defaults (would create duplicate/wrong clients):
        --   jdtls               → lua/user/lsp/java.lua (Bemol workspace, custom cmd)
        --   ts_ls               → replaced by typescript-tools.nvim
        --   lua_ls              → lua/user/lsp/lua.lua (explicit vim.lsp.config + enable)
        --   haxe_language_server → lua/user/lsp/init.lua (custom cmd for build.hxml)
        --   stylua (formatter, not an LSP — defensive entry)
        exclude = { "jdtls", "ts_ls", "lua_ls", "haxe_language_server", "stylua" },
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
    config = conf("goto-preview"),
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
    build = function() require('blink.cmp').build():wait(60000) end,
    config = conf("blink-cmp"),
    opts_extend = { "sources.default", "sources.providers" },
  },
  {
    "zbirenbaum/copilot.lua",
    cond = vim.g.ai_enabled and not sys.is_amazon(),
    cmd = "Copilot",
    event = "InsertEnter",
    config = conf("copilot"),
  },

  -- ─── NOTETAKING ───────────────────────────────────────────────────────────
  -- Disable entire section: let g:notetaking_enabled = v:false
  {
    "OXY2DEV/markview.nvim",
    cond = notetaking_enabled and treesitter_enabled,
    -- Load only on explicit :Markview command to avoid ~60ms render-cascade
    -- on every markdown file open. Activate per-buffer with `:Markview toggle`
    -- or globally for the session with `:Markview Enable`.
    cmd = "Markview",
    init = utils.load_mappings("markview"),
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
  -- ─── AZ INTERNAL ──────────────────────────────────────────────────────────
  {
    name = "vim-code-browse",
    url = "ssh://git.amazon.com:2222/pkg/Vim-code-browse",
    cond = sys.is_amazon() and not sys.is_firenvim(),
    event = "VeryLazy",
    dependencies = { "tpope/vim-fugitive" },
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
