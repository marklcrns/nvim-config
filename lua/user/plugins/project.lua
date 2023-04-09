return function()
  require("project_nvim").setup({
    detection_methods = { "lsp", "pattern" }, -- lsp first, then pattern
    -- detection_methods = { "pattern", "lsp" }, -- pattern first, then lsp
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
    -- When set to false, you will get a message when project.nvim changes your
    -- directory.
    silent_chdir = true,

    -- What scope to change the directory, valid options are
    -- * global (default)
    -- * tab
    -- * win
    scope_chdir = "tab",
  })
end
