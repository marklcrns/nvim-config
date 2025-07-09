local jdtls = require("jdtls")
local cmp_lsp = prequire("cmp_nvim_lsp")

local utils = Config.common.utils
local sys = Config.common.sys

local M = {}

local capabilities = utils.tbl_union_extend(
  vim.lsp.protocol.make_client_capabilities(),
  cmp_lsp and cmp_lsp.default_capabilities() or {}
)
capabilities.textDocument.completion.completionItem.snippetSupport = true;
capabilities.workspace.configuration = true

--- START: Amazon Bemol LSP
--- https://w.amazon.com/bin/view/Bemol#HnvimbuiltinLSP
local mason_dir = vim.fn.stdpath("data") .. "/mason"
local root_dir = require("jdtls.setup").find_root({ "packageInfo" }, "Config")
local home = os.getenv("HOME")
local eclipse_workspace = home .. "/.local/share/eclipse/" .. vim.fn.fnamemodify(root_dir, ":p:h:t")

local ws_folders_jdtls = {}
if root_dir then
  local file = io.open(root_dir .. "/.bemol/ws_root_folders")
  if file then
    for line in file:lines() do
      table.insert(ws_folders_jdtls, "file://" .. line)
    end
    file:close()
  end
end

function M.bemol()
  local bemol_dir = vim.fs.find({ '.bemol' }, { upward = true, type = 'directory'})[1]
  local ws_folders_lsp = {}
  if bemol_dir then
    local file = io.open(bemol_dir .. '/ws_root_folders', 'r')
    if file then

    for line in file:lines() do
      table.insert(ws_folders_lsp, line)
    end
    file:close()
    end
  end

  for _, line in ipairs(ws_folders_lsp) do
    vim.lsp.buf.add_workspace_folder(line)
  end
end
--- END: Amazon Bemol

function M.start_jdtls()
  local extendedClientCapabilities = jdtls.extendedClientCapabilities
  extendedClientCapabilities.resolveAdditionalTextEditsSupport = true

  local function jdtls_on_attach(client, bufnr)
    Config.lsp.common_on_attach(client, bufnr)
    require("jdtls.setup").add_commands()
    -- local opts = { noremap = true, silent = true; }

    -- Initialize Amazon Bemol LSP
    if sys.whoami() == "mrklcrns" then
      M.bemol()
    end
  end

  local settings = require("user.lsp").create_local_config({
    ["java.project.referencedLibraries"] = {
      "lib/**/*.jar",
      "lib/*.jar"
    },
    java = {
      signatureHelp = { enabled = true };
      contentProvider = { preferred = "fernflower" };
      completion = {
        favoriteStaticMembers = {
          "org.hamcrest.MatcherAssert.assertThat",
          "org.hamcrest.Matchers.*",
          "org.hamcrest.CoreMatchers.*",
          "org.junit.jupiter.api.Assertions.*",
          "java.util.Objects.requireNonNull",
          "java.util.Objects.requireNonNullElse",
          "org.mockito.Mockito.*"
        }
      };
    },
  })

  jdtls.start_or_attach({
    capabilities = capabilities,
    init_options = {
      extendedClientCapabilities = extendedClientCapabilities,
      workspaceFolders = ws_folders_jdtls
    },
    cmd = {
      mason_dir .. "/bin/jdtls",
      "-Declipse.application=org.eclipse.jdt.ls.core.id1",
      "-Dosgi.bundles.defaultStartLevel=4",
      "-Declipse.product=org.eclipse.jdt.ls.core.product",
      "-Dlog.protocol=true",
      "-Dlog.level=ALL",
      "-Xms1g",
      "--add-modules=ALL-SYSTEM",
      "--add-opens", "java.base/java.util=ALL-UNNAMED",
      "--add-opens", "java.base/java.lang=ALL-UNNAMED",
      "--jvm-arg=-javaagent:" .. mason_dir .. "/share/jdtls/lombok.jar", -- need for lombok magic
      "-data",
      eclipse_workspace,
    },
    filetypes = { "java" }, -- Not used by jdtls, but used by lspsaga
    on_attach = jdtls_on_attach,
    -- root_dir = require("jdtls.setup").find_root({ ".git", "gradlew", "build.xml", "mvnw" }),
    root_dir = root_dir, -- Amazon Bemol LSP specific root_dir
    flags = {
      allow_incremental_sync = true,
      server_side_fuzzy_completion = true,
    },
    settings = settings
  })
end

function M.attach_mappings()
  local map = function (mode, lhs, rhs, opts)
    opts = vim.tbl_extend("force", { buffer = 0 },  opts or {}) --[[@as table ]]
    vim.keymap.set(mode, lhs, rhs, opts)
  end

  map("n", "<M-O>", jdtls.organize_imports)
end

Config.common.au.declare_group("jdtls_config", {}, {
  {
    "FileType", pattern = "java", callback = function()
      M.start_jdtls()
      M.attach_mappings()
    end,
  },
})

return M
