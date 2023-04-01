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
  { "nvim-lua/popup.nvim" },
  { "nvim-lua/plenary.nvim", lazy = true },

  -- UI STYLE
  { "kyazdani42/nvim-web-devicons", name = "nvim-web-devicons", config = conf("nvim-web-devicons"), lazy = true },
  { "rcarriga/nvim-notify", config = conf("nvim-notify") },
  { "akinsho/bufferline.nvim", config = conf("bufferline"), dependencies = "nvim-web-devicons", event = "VimEnter" },
  { "feline-nvim/feline.nvim", config = conf("feline"), event = "VeryLazy" },
  { "lukas-reineke/indent-blankline.nvim", config = conf("indent-blankline"), event = "VimEnter" },
  { "Darazaki/indent-o-matic", config = conf("indent-o-matic") },
  { "RRethy/vim-illuminate", config = conf("vim-illuminate"), event = "VeryLazy" },

  -- UI TOOLS
  { "sindrets/diffview.nvim", config = conf("diffview") },
  { "nvim-telescope/telescope.nvim", config = conf("telescope"), dependencies = "nvim-web-devicons" },
  { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
  { "nvim-telescope/telescope-media-files.nvim" },
  { "nvim-telescope/telescope-ui-select.nvim" },
  { "folke/which-key.nvim", config = conf("which-key"), lazy = true },
  { "gregorias/nvim-mapper", config = conf("nvim-mapper"), dependencies = "nvim-telescope/telescope.nvim" },

  -- SYNTAX & FILETYPE PLUGINS
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = conf("nvim-treesitter"),
  },

  -- SYSTEM PLUGINS
  { "marklcrns/vim-smartq", config = conf("vim-smartq") },

  -- COLORSCHEMES
  { "folke/tokyonight.nvim", config = conf("tokyonight"), lazy = true },
  { "sindrets/oxocarbon-lua.nvim", lazy = true },
  { "AlexvZyl/nordic.nvim", opts = { cursorline = { hide_unfocused = false } }, lazy = true },
})

require("user.plugins.keymaps")
