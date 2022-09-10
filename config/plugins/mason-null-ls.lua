require("mason-null-ls").setup({
  ensure_installed = {
    -- you can pin a tool to a particular version
    -- { 'golangci-lint', version = '1.47.0' },

    -- you can turn off/on auto_update per tool
    -- { 'shellcheck', auto_update = true },

    -- 'stylua',
    -- 'editorconfig-checker',
    'prettier',
    'shellcheck',
    'vint',
  },
  automatic_installation = true,
})
require("mason-null-ls").check_install(true)
