setl conceallevel=3
setl concealcursor=c sw=2
setl spell

lua vim.opt_local.formatlistpat = [=[^\s*\d\+\.\s\+\|^\s*[-*+]\s\+\|^\[^\ze[^\]]\+\]:\&^.\{4\}\|^\s*>\s\+]=]
