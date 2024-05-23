return function()
  require("nvim-ts-autotag").setup({
    opts = {
      -- Defaults
      enable_close = true, -- Auto close tags
      enable_rename = true, -- Auto rename pairs of tags
      enable_close_on_slash = false -- Auto close on trailing </
    },
    -- filetypes = {
    --   "html",
    --   "javascript",
    --   "typescript",
    --   "javascriptreact",
    --   "typescriptreact",
    --   "svelte",
    --   "vue",
    --   "tsx",
    --   "jsx",
    --   "rescript",
    --   "xml",
    --   "php",
    --   "glimmer",
    --   "handlebars",
    --   "hbs",
    -- },
  })
end
