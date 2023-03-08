require("project_nvim").setup({
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
    "lua/", -- To prevent Telescope only looking into ./lua dir when in lua buf
  },
})
require("telescope").load_extension("projects")
