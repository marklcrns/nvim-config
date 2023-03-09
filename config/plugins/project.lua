require("project_nvim").setup({
  detection_methods = { "lsp", "pattern" },
  patterns = {
    "=src",
    ".git",
    "_darcs",
    ".hg",
    ".bzr",
    ".svn",
    ".git/",
    "README.*",
    "pom.xml",
    "env/",
    ".root",
    ".editorconfig",
    "package.json",
    "Makefile",
  },
})
require("telescope").load_extension("projects")
