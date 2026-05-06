-- Defer the typescript-tools setup to FileType autocmd. Setup() pulls in the
-- whole typescript-tools module (~5ms) — paying that cost only when a TS/JS
-- file is actually opened keeps non-TS sessions faster.

local function setup()
  require("typescript-tools").setup(
    Config.lsp.create_config({
      single_file_support = true,
      settings = {
        -- spawn additional tsserver instance to calculate diagnostics on it
        separate_diagnostic_server = true,
        -- "change"|"insert_leave" determine when the client asks the server about diagnostic
        publish_diagnostic_on = "insert_leave",
        -- string|nil -specify a custom path to `tsserver.js` file, if this is nil or file under path
        -- not exists then standard path resolution strategy is applied
        tsserver_path = nil,
        -- specify a list of plugins to load by tsserver, e.g., for support `styled-components`
        -- (see 💅 `styled-components` support section)
        tsserver_plugins = {
          -- for TypeScript v4.9+
          "@styled/typescript-styled-plugin",
          -- or for older TypeScript versions
          -- "typescript-styled-plugin",
        },
        -- this value is passed to: https://nodejs.org/api/cli.html#--max-old-space-sizesize-in-megabytes
        -- memory limit in megabytes or "auto"(basically no limit)
        tsserver_max_memory = "auto",
        -- described below
        tsserver_format_options = {},
        tsserver_file_preferences = {},
      },
    })
  )
end

Config.common.au.declare_group("typescript_lsp_config", {}, {
  {
    "FileType",
    pattern = { "typescript", "typescriptreact", "javascript", "javascriptreact", "tsx", "jsx" },
    once = true, -- setup() only needs to run once per session
    callback = setup,
  },
})
