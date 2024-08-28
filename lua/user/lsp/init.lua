local mason = prequire("mason")
local mason_lspconfig = prequire("mason-lspconfig")

if mason then
  vim.env.PATH = vim.env.PATH
    .. (Config.common.sys.is_windows() and ";" or ":")
    .. vim.fn.stdpath("data")
    .. "/mason/bin"
  mason.setup({
    PATH = "skip",
    ui = {
      icons = {
        package_pending = " ",
        package_installed = " ",
        package_uninstalled = " ﮊ",
      },

      keymaps = {
        toggle_server_expand = "<CR>",
        install_server = "i",
        update_server = "u",
        check_server_version = "c",
        update_all_servers = "U",
        check_outdated_servers = "C",
        uninstall_server = "X",
        cancel_installation = "<C-c>",
      },
    },

    max_concurrent_installers = 10,
    -- Installation directory. Usually in ~/.local/share/nvim
    -- See :lua print(vim.fn.stdpath("data"))
    -- install_root_dir = vim.fn.stdpath("data") .. "/mason",
  })
end
if mason_lspconfig then
  mason_lspconfig.setup({
    automatic_installation = true,
  })
end

require("neodev").setup({
  library = {
    enabled = true, -- when not enabled, neodev will not change any settings to the LSP server
    -- these settings will be used for your Neovim config directory
    runtime = true, -- runtime path
    types = true, -- full signature, docs and completion of vim.api, vim.treesitter, vim.lsp and others
    -- plugins = false, -- installed opt or start plugins in packpath
    -- you can also specify the list of plugins to make available as a workspace library
    plugins = {
      "nvim-treesitter",
      "plenary",
      "telescope.nvim",
      "nvim-dap-ui",
    },
  },
  -- With lspconfig, Neodev will automatically setup your lua-language-server
  -- If you disable this, then you have to set {before_init=require("neodev.lsp").before_init}
  -- in your lsp start options
  lspconfig = true,
  -- much faster, but needs a recent built of lua-language-server
  -- needs lua-language-server >= 3.6.0
  pathStrict = true,
})

local cmp = prequire("cmp")
local cmp_lsp = prequire("cmp_nvim_lsp")
local lspconfig = prequire("lspconfig")

if not lspconfig then
  return
end

local utils = Config.common.utils
local notify = Config.common.notify
local pl = utils.pl
local config_store = {}

local M = {}
_G.Config.lsp = M

require("lspconfig.ui.windows").default_options.border = "single"

---@diagnostic disable-next-line: unused-local
function M.common_on_attach(client, bufnr)
  if not vim.g.low_performance_mode then
    require("illuminate").on_attach(client)
    require("lsp_signature").on_attach({
      bind = true, -- This is mandatory, otherwise border config won't get registered.
      handler_opts = {
        border = "single",
      },
    }, bufnr)
  end
end

M.base_config = {
  on_attach = M.common_on_attach,
  capabilities = utils.tbl_union_extend(
    vim.lsp.protocol.make_client_capabilities(),
    cmp_lsp and cmp_lsp.default_capabilities() or nil
  ),
}

M.local_config_paths = {
  ".vim/lsp_init.lua",
  ".vim/lsp_settings.lua",
  ".vim/lsprc.lua",
  ".lsprc.lua",
}

function M.create_local_config(config)
  local cwd = uv.cwd()
  local local_config = config_store[cwd]
  local project_config = Config.state.project_config
  config = config or {}

  if not local_config then
    if type(project_config) == "table" and project_config.lsp_config then
      local_config = project_config.lsp_config
      notify.config("Using LSP config from project config.")
    else
      for _, path in ipairs(M.local_config_paths) do
        if pl:readable(path) then
          notify.config("Using project-local LSP config: " .. utils.str_quote(path))
          local code_chunk = loadfile(path)
          if code_chunk then
            local_config = code_chunk()
            break
          end
        end
      end
    end

    if not local_config then
      local_config = {}
    end

    config_store[cwd] = local_config
  end

  if vim.is_callable(local_config) then
    local_config = local_config(config)
  else
    local_config = utils.tbl_union_extend(config, local_config)
  end

  return local_config
end

---Create lsp config from base + server defaults + local config.
---@param ... table Set of LSP configs sorted by order of precedence: later
---configs will overwrite earlier configs.
---@return table
function M.create_config(...)
  local config = utils.tbl_union_extend(M.base_config, {}, ...)

  return M.create_local_config(config)
end

-- START LSP CONFIG ------------------------------------------------------------

-- Typescript, Javascript
local TSOrganizeImports = function()
  vim.lsp.buf.code_action({
    apply = true,
    context = {
      only = { "source.organizeImports.ts" },
      diagnostics = {},
    },
  })
end
local TSRemoveUnused = function()
  vim.lsp.buf.code_action({
    apply = true,
    context = {
      only = { "source.removeUnused.ts" },
      diagnostics = {},
    },
  })
end
lspconfig.tsserver.setup(M.create_config({
  single_file_support = true,
  commands = {
    TSOrganizeImports = {
      TSOrganizeImports,
      description = "Organize Imports",
    },
    TSRemoveUnused = {
      TSRemoveUnused,
      description = "Remove unused",
    },
  },

  completions = {
    completeFunctionCalls = true,
  },
  settings = {
    javascript = {
      inlayHints = {
        includeInlayEnumMemberValueHints = true,
        includeInlayFunctionLikeReturnTypeHints = true,
        includeInlayFunctionParameterTypeHints = true,
        includeInlayParameterNameHints = "none", -- 'none' | 'literals' | 'all';
        includeInlayParameterNameHintsWhenArgumentMatchesName = false,
        includeInlayPropertyDeclarationTypeHints = true,
        includeInlayVariableTypeHints = false,
      },
    },

    typescript = {
      inlayHints = {
        includeInlayEnumMemberValueHints = true,
        includeInlayFunctionLikeReturnTypeHints = true,
        includeInlayFunctionParameterTypeHints = true,
        includeInlayParameterNameHints = "none", -- 'none' | 'literals' | 'all';
        includeInlayParameterNameHintsWhenArgumentMatchesName = false,
        includeInlayPropertyDeclarationTypeHints = true,
        includeInlayVariableTypeHints = false,
      },
    },
  },
}))

-- HTML + CSS
lspconfig.html.setup(M.create_config())
lspconfig.cssls.setup(M.create_config())
lspconfig.tailwindcss.setup(M.create_config({
  completions = {
    completeFunctionCalls = true,
  },
  root_dir = lspconfig.util.root_pattern(
    "tailwind.config.js",
    "tailwind.config.cjs",
    "tailwind.config.ts",
    "postcss.config.js",
    "postcss.config.cjs",
    "postcss.config.ts"
  ),
}))

-- Python
lspconfig.pyright.setup(M.create_config())
-- lspconfig.pylsp.setup(M.create_config())
-- lspconfig.jedi_language_server.setup(M.create_config())

-- Lua
require("user.lsp.lua")

-- Bash
lspconfig.bashls.setup(M.create_config())

-- C#
lspconfig.omnisharp.setup(M.create_config())

-- C, C++
lspconfig.clangd.setup(M.create_config())

-- Vim
lspconfig.vimls.setup(M.create_config())

-- Go
-- lspconfig.gopls.setup(M.create_config())

-- Misc
lspconfig.clojure_lsp.setup(M.create_config())
lspconfig.dockerls.setup(M.create_config())
lspconfig.jsonls.setup(M.create_config())
lspconfig.emmet_ls.setup(M.create_config({
  filetypes = {
    "html",
    "typescriptreact",
    "javascriptreact",
    "css",
    "sass",
    "scss",
    "less",
  },
}))
lspconfig.eslint.setup(M.create_config({
  on_attach = function(bufnr)
    vim.api.nvim_create_autocmd("BufWritePre", {
      buffer = tonumber(bufnr),
      command = "EslintFixAll",
    })
  end,
  completions = { completeFunctionCalls = true, },
}))

-- Weird languages for school
lspconfig.svlangserver.setup(M.create_config({
  filetypes = { "systemverilog", "verilog" },
}))

-- END LSP CONFIG --------------------------------------------------------------

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
  virtual_text = false,
  underline = true,
  signs = true,
  -- INFO: My config
  update_in_insert = false,
  severity_sort = true,
})

-- DIAGNOSTICS: Only show the sign with the highest priority per line
-- From: `:h diagnostic-handlers-example`

-- -- Override the built-in signs handler
-- local ns = vim.api.nvim_create_namespace("user_lsp")
-- local orig_signs_handler = vim.diagnostic.handlers.signs
--
-- -- Create a custom namespace. This will aggregate signs from all other
-- -- namespaces and only show the one with the highest severity on a
-- -- given line
-- local ns = vim.api.nvim_create_namespace("my_namespace")
--
-- -- Get a reference to the original signs handler
-- local orig_signs_handler = vim.diagnostic.handlers.signs
--
-- -- Override the built-in signs handler
-- vim.diagnostic.handlers.signs = {
--   show = function(_, bufnr, _, opts)
--     -- Get all diagnostics from the whole buffer rather than just the
--     -- diagnostics passed to the handler
--     local diagnostics = vim.diagnostic.get(bufnr)
--
--     -- Find the "worst" diagnostic per line
--     local max_severity_per_line = {}
--     for _, d in pairs(diagnostics) do
--       local m = max_severity_per_line[d.lnum]
--       if not m or d.severity < m.severity then
--         max_severity_per_line[d.lnum] = d
--       end
--     end
--
--     -- Pass the filtered diagnostics (with our custom namespace) to
--     -- the original handler
--     local filtered_diagnostics = vim.tbl_values(max_severity_per_line)
--     orig_signs_handler.show(ns, bufnr, filtered_diagnostics, opts)
--   end,
--   hide = function(_, bufnr)
--     orig_signs_handler.hide(ns, bufnr)
--   end,
-- }

local pop_opts = { border = "single", max_width = 84 }
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, pop_opts)
-- vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, pop_opts)

function M.define_diagnostic_signs(opts)
  local group = {
    -- version 0.5
    {
      highlight = "LspDiagnosticsSignError",
      sign = opts.error,
    },
    {
      highlight = "LspDiagnosticsSignWarning",
      sign = opts.warn,
    },
    {
      highlight = "LspDiagnosticsSignHint",
      sign = opts.hint,
    },
    {
      highlight = "LspDiagnosticsSignInformation",
      sign = opts.info,
    },
    -- version >=0.6
    {
      highlight = "DiagnosticSignError",
      sign = opts.error,
    },
    {
      highlight = "DiagnosticSignWarn",
      sign = opts.warn,
    },
    {
      highlight = "DiagnosticSignHint",
      sign = opts.hint,
    },
    {
      highlight = "DiagnosticSignInfo",
      sign = opts.info,
    },
  }

  for _, g in ipairs(group) do
    vim.fn.sign_define(g.highlight, {
      text = g.sign,
      texthl = g.highlight,
      linehl = "",
      numhl = "",
    })
  end
end

-- Highlight references on cursor hold

function M.highlight_cursor_symbol()
  if vim.lsp.buf.server_ready() then
    if vim.fn.mode() ~= "i" then
      vim.lsp.buf.document_highlight()
    end
  end
end

function M.highlight_cursor_clear()
  if vim.lsp.buf.server_ready() then
    vim.lsp.buf.clear_references()
  end
end
---------------------------------

-- Only show diagnostics if current word + line is not the same as last call.
local last_diagnostics_word = nil
function M.show_position_diagnostics()
  if not vim.diagnostic.is_enabled({ bufnr = 0 })
    -- NOTE: `cmp.visible()` is very slow (at least 10ms) ! Avoid.
    or (cmp and cmp.core.view:visible() or vim.fn.pumvisible() == 1)
  then
    return
  end

  local cword = vim.fn.expand("<cword>")
  local cline = vim.api.nvim_win_get_cursor(0)[1]
  local bufnr = vim.api.nvim_get_current_buf()

  if
    last_diagnostics_word
    and last_diagnostics_word[1] == cline
    and last_diagnostics_word[2] == cword
    and last_diagnostics_word[3] == bufnr
  then
    return
  end
  last_diagnostics_word = { cline, cword, bufnr }

  vim.diagnostic.open_float({ scope = "cursor", border = "single" })
end

M.define_diagnostic_signs({
  error = "",
  warn = "",
  hint = "",
  info = "",
})

-- LSP auto commands
Config.common.au.declare_group("lsp_init", {}, {
  { "CursorHold", callback = M.show_position_diagnostics },
  {
    "LspAttach",
    callback = function(state)
      local client = vim.lsp.get_client_by_id(state.data.client_id)

      if client and client.server_capabilities.inlayHintProvider then
        -- Enable inlay hints:
        vim.lsp.inlay_hint.enable(true, { bufnr = 0 })
      end
    end,
  }
})

-- Turn off LSP logging
vim.lsp.set_log_level("off")

return M
