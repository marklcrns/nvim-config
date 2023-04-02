return function()
  require("nvim-ts-autotag").setup({
    filetypes = {
      "html",
      "javascript",
      "typescript",
      "javascriptreact",
      "typescriptreact",
      "svelte",
      "vue",
      "tsx",
      "jsx",
      "rescript",
      "xml",
      "php",
      "glimmer",
      "handlebars",
      "hbs",
    },
  })
end
