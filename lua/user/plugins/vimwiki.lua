return function()
  vim.g.vimwiki_use_calendar = 1
  vim.g.vimwiki_hl_headers = 1
  vim.g.vimwiki_hl_cb_checked = 1
  vim.g.vimwiki_autowriteall = 0
  vim.g.vimwiki_folding = "custom"
  vim.g.vimwiki_map_prefix = "<LocalLeader>nw"
  vim.g.vimwiki_key_mappings = {
    all_maps = 1,
    global = 1,
    headers = 1,
    text_objs = 1,
    table_format = 1,
    table_mappings = 0,
    lists = 1,
    links = 1,
    html = 1,
    mouse = 0,
  }
  vim.g.vimwiki_list = {
    {
      path = "~/Documents/my-wiki/task/md/",
      exclude_files = { "**/README.md" },
      path_html = "~/Documents/my-wiki/task/html",
      diary_header = "Task",
      diary_link_fmt = "%Y-%m/%d",
      index = "index",
      auto_tags = 1,
      auto_toc = 0,
      auto_export = 1,
      automatic_nested_syntaxes = 1,
      syntax = "markdown",
      ext = ".md",
      template_path = "~/Documents/my-wiki/templates/",
      template_default = "template",
      template_ext = ".html",
      custom_wiki2html = "~/Documents/my-wiki/task/wiki2html.sh",
    },
    {
      path = "~/Documents/my-wiki/docs/md/",
      exclude_files = { "**/README.md" },
      path_html = "~/Documents/my-wiki/docs/html",
      index = "index",
      auto_tags = 1,
      auto_toc = 0,
      auto_export = 1,
      automatic_nested_syntaxes = 1,
      syntax = "markdown",
      ext = ".md",
      template_path = "~/Documents/my-wiki/templates/",
      template_default = "template",
      template_ext = ".html",
      custom_wiki2html = "~/Documents/my-wiki/docs/wiki2html.sh",
    },
    {
      path = "~/Documents/my-wiki/school/md",
      exclude_files = { "**/README.md" },
      path_html = "~/Documents/my-wiki/school/html",
      index = "index",
      auto_tags = 1,
      auto_toc = 0,
      auto_export = 1,
      automatic_nested_syntaxes = 1,
      syntax = "markdown",
      ext = ".md",
      template_path = "~/Documents/my-wiki/templates/",
      template_default = "template",
      template_ext = ".html",
      custom_wiki2html = "~/Documents/my-wiki/school/wiki2html.sh",
    },
    {
      path = "~/Documents/my-wiki/",
      exclude_files = { "**/README.md" },
      path_html = "~/Documents/my-wiki/",
      index = "index",
      auto_tags = 1,
      auto_toc = 0,
      auto_export = 1,
      automatic_nested_syntaxes = 1,
      syntax = "markdown",
      ext = ".md",
      template_path = "~/Documents/my-wiki/templates/",
      template_default = "index_template",
      template_ext = ".html",
      custom_wiki2html = "~/Documents/my-wiki/wiki2html.sh",
    },
  }

  vim.cmd([[
    " Custom link handler for external files
    " Use Vim to open external files with the 'vfile:' scheme.  E.g.:
    "   1) [vfile:~/absolute_path/to/file/]
    "   2) [vfile:./relative_path/to/file]
    " Use xdg-open to open external file with the 'file:' scheme. E.g:
    "   1) [file:~/absolute_path/to/file/]
    "   2) [file:./relative_path/to/file]
    " For markdown syntax
    "   Open with Vim
    "   1) [Description](vfile:~/absolute_path/to/file)
    "   2) [Description](vfile:./relative_path/to/file)
    "   Open with xdg-open
    "   1) [Description](file:~/absolute_path/to/file)
    "   2) [Description](file:./relative_path/to/file)
    function! VimwikiLinkHandler(link)
      let link = a:link
      if link =~# '^vfile:'
        let link_infos = vimwiki#base#resolve_link(link[1:])
      elseif link=~# '^file:'
        let link_infos = vimwiki#base#resolve_link(link)
      else
        return 0
      endif
      if link_infos.filename == ''
        echomsg 'Vimwiki Error: Unable to resolve link!'
        return 0
      elseif link =~# '^file:'
        try
          if vimwiki#u#is_windows()
            call s:win32_handler(link)
            return 1
          elseif vimwiki#u#is_macos()
            call s:macunix_handler(link)
            return 1
          else
            call s:linux_handler(link)
            return 1
          endif
        catch
          echo "Error while opening " . fnameescape(link_infos.filename)
        endtry
        return 0
      else
        exe 'vsplit ' . fnameescape(link_infos.filename)
        return 1
      endif
    endfunction

    " TODO: Check if reference header exists, if not make one
    " TODO: Do not overwrite on existing list sublists
    " Resources:
    " Copy search match                   = https://vim.fandom.com/wiki/Copy_search_matches
    " Undupe list                         = https://stackoverflow.com/a/6630950/11850077
    " Match all characters with new lines = https://vi.stackexchange.com/a/13991
    " Extras:
    " https://vim.fandom.com/wiki/Folding_with_Regular_Expression
    " ----------
    function! CopyMatches(reg)
      let hits = []
      " Add all matches into hits list
      silent %s//\=len(add(hits, submatch(0))) ? submatch(0) : ''/gne
      " Get register name. Use '+' if not provided
      let reg = empty(a:reg) ? '+' : a:reg
      " Replace in-between new lines/line breaks with single space from each matches
      let cleanhits = map(copy(hits), 'substitute(v:val, "\\n\\(\\s*\\|\\t*\\)\\?", " ", "g")')
      " Filter out duplicate matches
      let undupehits = filter(copy(cleanhits), 'index(cleanhits, v:val, v:key+1)==-1')
      " Put all list of strings joined by new lines into register
      exe 'let @'.reg.' = "\n" . join(undupehits, "\n") . "\n"'
    endfunction
    command! -register CopyMatches call CopyMatches(<q-reg>)

    function! IndexResourcesLinks(header, pattern)
      let list_type_include = '-+'
      let list_type_exclude = '*'
      let link_type_emojis = '⬇📄📑💽📺'
      " Save cursor position
      let save_pos = getpos(".")
      " Use default link pattern in non was given
      " Note: \_.\{-} regex pattern matches all characters including new lines.
      " Res: https://vim.fandom.com/wiki/Regex_lookahead_and_lookbehind
      let pattern = empty(a:pattern) ? '^\(['.list_type_include.']\s\|[^'.list_type_exclude.']*\)\zs\[['.link_type_emojis.']\_.\{-}\](\_.\{-}\(\\\)\@<!)' : a:pattern
      " Check if pattern matched
      if search(pattern, 'w') == 0
        echo "No link pattern match found"
        return
      endif

      " Use default '# Resources' header of non was given
      let header = empty(a:header) ? '# Resources' : a:header
      if search(header, 'w') == 0
        " Create header if not found. Also adds '<br>' tag before the header
        exe "norm! Go\<CR><br>\<CR>\<CR>" . header
      endif

      " Delete exising links under the header
      exe 'silent g/' . header . '/'
      silent exe "norm! jVG:g/-\\s\\[.*\\](.*)/d\<CR>"

      " Clear `x` register and copy all matched reference links into it
      exe 'let @x = ""'
      " Yank all links matched with pattern
      exe 'silent g/' . pattern . '/y A'
      " Copy all matches in 'x' register and ready for pasting
      call CopyMatches('x')

      " Check if resources header exist
      if search(header, 'w') == 0
        echom 'Error IndexResourcesLinks(): ' . header . ' header not found'
        return
      endif
      exe 'silent g/' . header . '/'
      " Paste all links under the header
      silent exe 'norm! "xp'

      " Prepend '- ' on every pasted matched links. 'j' after '`[' offsets extra
      " empty line at the beginning of selection, and 'jdd' at the end deletes
      " extra empty line at the end.
      silent exe "norm! `[jv`]:s/\\(.*\\)/- \\1/\<CR>`]jdd"
      " Add back new line if the following line is not empty and not a link
      let nextline = getline('.')
      if (len(nextline) > 0) && !(nextline =~ pattern)
        exe 'norm! O'
      endif
      " Clear highlights
      nohls
      " Go back to last cursor position centered
      call setpos('.', save_pos)
      exe 'norm! zz'
      " Report complete
      redraw
      echo "Auto generated Resources header"
    endfunction

    " Deprecated by coc-spell-checker
    " augroup SpellCheck
    "   autocmd!
    "   autocmd Filetype vimwiki
    "        \ autocmd BufRead <buffer> setlocal spell
    " augroup END

    augroup VimwikiEditMode
      autocmd!
      autocmd FileType vimwiki setlocal textwidth=80
      autocmd FileType vimwiki setlocal foldlevel=99
      autocmd FileType vimwiki setlocal nowrap
      " Toggle conceallevel on and after insert mode
      autocmd FileType vimwiki
            \ autocmd InsertEnter <buffer> setlocal conceallevel=0
      autocmd FileType vimwiki
            \ autocmd InsertLeave <buffer> setlocal conceallevel=2
    augroup END

    " Vimwiki custom mappings
    augroup VimwikiCustomMappings
      autocmd!
      " Integration with delimitMate, coc completion and Ultisnips
      autocmd FileType vimwiki inoremap <silent><buffer><expr> <Tab>
            \ vimwiki#tbl#kbd_tab()
      autocmd Filetype vimwiki inoremap <silent><buffer><expr> <S-tab>
            \ vimwiki#tbl#kbd_shift_tab()
      autocmd FileType vimwiki inoremap <silent><buffer> <CR>
            \ <C-]><Esc>:VimwikiReturn 1 5<CR>
      autocmd FileType vimwiki inoremap <silent><buffer> <S-CR>
            \ <Esc>:VimwikiReturn 4 1<CR>
      autocmd Filetype vimwiki nnoremap <silent><buffer><LocalLeader>nwL :call IndexResourcesLinks('# Resources', '')<CR>
    augroup END

    " Quick fix hack on <CR> and <S-CR> being remapped when comming back to a session
    if !hasmapto('VimwikiReturn', 'i')
      if maparg('<CR>', 'i') !~? '<Esc>:VimwikiReturn'
        autocmd FileType vimwiki inoremap <silent><buffer> <CR>
              \ <C-]><Esc>:VimwikiReturn 1 5<CR>
      endif
      if maparg('<S-CR>', 'i') !~? '<Esc>:VimwikiReturn'
        autocmd FileType vimwiki inoremap <silent><buffer> <S-CR> <Esc>:VimwikiReturn 4 1<CR>
      endif
    endif
  ]])
end
