require('nvim-rooter').setup {
  rooter_patterns = {
    '=src',
    '.git',
    '.hg',
    '.svn',
    '.git/',
    'README.*',
    'node_modules/',
    'pom.xml',
    'env/',
    '.root',
    '.editorconfig',
    'Makefile',
    'makefile',
  },
  trigger_patterns = { '*' },
  manual = true,
}
