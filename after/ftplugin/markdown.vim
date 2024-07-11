" setl conceallevel=2
setl concealcursor=c sw=2

lua vim.opt_local.formatlistpat = [=[^\s*\d\+\.\s\+\|^\s*[-*+]\s\+\|^\[^\ze[^\]]\+\]:\&^.\{4\}\|^\s*>\s\+]=]
