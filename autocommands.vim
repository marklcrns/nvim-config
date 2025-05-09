augroup NvimConfig
    au!

    " Disable swap/undo/viminfo/shada files in temp directories or shm
    silent! au BufNewFile,BufReadPre
            \ /tmp/*,$TMPDIR/*,$TMP/*,$TEMP/*,*/shm/*,/private/var/*,.vault.vim
            \ setlocal noswapfile noundofile nobackup nowritebackup viminfo= shada=

    " Automatically set read-only for files being edited elsewhere
    au SwapExists * nested let v:swapchoice = 'o'

    " Disables automatic commenting on newline:
    au FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

    " Force write shada on leaving nvim
    au VimLeave * if has('nvim') | wshada! | else | wviminfo! | endif

    " nuke netrw brain damage
    au VimEnter * silent! au! FileExplorer *
    " au BufEnter * if isdirectory(expand('%')) | bd | endif

    " Auto-cd to the first argv if it's a directory.
    au VimEnter * if isdirectory(argv(0))
                \ |     exe 'cd ' . argv(0)
                \ | elseif argv(0) =~# '^oil:\/\/'
                \ |     exe 'cd ' . argv(0)[6:]
                \ | endif


    au VimEnter * lua require'user.au'.source_project_config();
                \ require'user.au'.source_project_session()

    " Restore cursor pos
    au BufReadPost *
                \ if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit' && &ft !~# 'git'
                \ |     exe "normal! g`\"zz"
                \ | endif

    " Highlight yanks
    au TextYankPost * silent!
                \ lua vim.highlight.on_yank({ higroup="Visual", timeout=300, on_visual=true })

    au BufWinEnter quickfix set nobuflisted | setl nowrap cc=

    " Disable modelines after the first time it's processed.
    au BufWinEnter * setl nomodeline

    " au TermEnter,TermOpen * setl nonu nornu signcolumn=yes:1
    "             \ | if exists(":IlluminatePauseBuf") | exe "IlluminatePauseBuf" | endif

    au TermOpen * let b:term_start = v:lua.vim.loop.hrtime()

    " Automatically close interactive term buffers if exit status is 0. Don't
    " close the terminal if its lifetime was less than 2 seconds. Define
    " `b:term_keep` to keep the term regardless.
    au TermClose * ++nested
                \ if v:event.status == 0 && exists("b:term_start") && !get(b:, "term_keep")
                \ && (v:lua.vim.loop.hrtime() - b:term_start) / 1000000 > 2000
                \ | bd | endif

    au TermOpen,BufEnter * lua
                \ if vim.bo[Config.state.term.actual_curbuf or 0].buftype == "terminal"
                \   and vim.fn.line("w$") == vim.fn.line("$")
                \ then
                \       vim.cmd("startinsert")
                \ end

    au BufWinEnter,FileType fugitiveblame setl nolist

    " Enable 'onemore' in visual mode.
    au ModeChanged *:[v]* setl virtualedit+=onemore
    au ModeChanged [v]*:* setl virtualedit<

    " Automatically reload file if it's been changed outside vim.
    au BufEnter,CursorHold * silent! checktime %

    " Open file location. Example: `foo/bar/baz:128:17`
    au BufReadCmd *:[0-9]\+ lua require("user.au").open_file_location(vim.fn.expand("<afile>"))

    au BufWinLeave * if get(t:, "compare_mode", 0) | diffoff | endif
    au BufEnter * if get(t:, "compare_mode", 0)
                \ |     if &bt ==# ""
                \ |         setl diff cursorbind scrollbind fdm=diff fdl=0
                \ |     else
                \ |         setl nodiff nocursorbind noscrollbind
                \ |     endif
                \ | endif

    au CmdwinEnter * setl ft=vim

    " Execute command from cmdline window while keeping it open.
    au CmdwinEnter * nnoremap <buffer> <C-x> <CR>q:

    " Notification after file change
    autocmd FileChangedShellPost *
            \ lua Config.common.notify.config.info("File changed. Autoreloaded " .. vim.fn.expand("%"))

    " OpenGL Shading Language: GLSL support
    " Make sure to install glsl via Tree-sitter `TSInstall glsl`
    autocmd! BufNewFile,BufRead *.vs,*.fs set ft=glsl
augroup END

lua <<EOF
local aucmd = vim.api.nvim_create_autocmd

function bufIsBig(bufnr)
    -- Check if the buffer is too big (in KB)
    local kb = Config.common.utils.buf_get_size(bufnr)
    return kb > 320
end

-- Ref: https://github.com/neovim/nvim-lspconfig/issues/2626#issuecomment-2117022664
-- Prevent LSP to attach to big files
aucmd("LspAttach", {
    group = "NvimConfig",
    callback = function(ctx)
        -- if bufIsBig(ctx.buf) then
        --     for _,client in pairs(vim.lsp.get_active_clients({bufnr = ctx.buf})) do
        --         -- Using vim.defer_fn because when this event is fired, we are
        --         -- not really attached. See:
        --         -- https://www.reddit.com/r/neovim/comments/168u3e4/comment/jyyluyo/
        --         vim.defer_fn(function()
        --             vim.lsp.buf_detach_client(ctx.buf, client.id)
        --             print(
        --                 "Detaching client " .. client.name .. " because buffer " ..
        --                 vim.fn.bufname(ctx.buf) .. " is too big"
        --             )
        --         end, 10)
        --     end
        -- end

        if bufIsBig(ctx.buf) then
            vim.o.eventignore = "FileType"
            vim.schedule(function() vim.o.eventignore = "" end)
        end
    end
})

aucmd("BufRead", {
    group = "NvimConfig",
    callback = function(ctx)
        -- Disable stuff in big files
        local notify = Config.common.notify

        if bufIsBig(ctx.buf) then
            local ts_context = prequire("treesitter-context")
            local todo_comments = prequire("todo-comments")
            local rainbow_delimiters = prequire("rainbow_delimiters")
            local smooth_cursor_utils = prequire("smoothcursor.utils")
            -- local illuminate = vim.g.loaded_illuminate == 1
            -- local matchup = vim.g.loaded_matchit == 1 or vim.g.loaded_matchparen == 1

            if ts_context then ts_context.disable() end
            if todo_comments then todo_comments.disable() end
            if rainbow_delimiters then rainbow_delimiters.disable() end
            if smooth_cursor_utils then smooth_cursor_utils.smoothcursor_stop() end
            -- if illuminate then require("illuminate").freeze_buf() end
            -- if matchup then vim.cmd("NoMatchParen") end

            notify.config.info("Big file detected: Disabled treesitter-context, todo-comments, illuminate, and rainbow-delimiters.")
        end
    end,
})

-- Lua adaptation of vim-cool (auto `nohlsearch`)
-- Ref: https://www.reddit.com/r/neovim/comments/1ct2w2h/lua_adaptation_of_vimcool_auto_nohlsearch
local function augroup(name, fnc)
  fnc(vim.api.nvim_create_augroup(name, { clear = true }))
end

augroup("ibhagwan/ToggleSearchHL", function(g)
    aucmd("InsertEnter", {
        group = g,
        callback = function()
        vim.schedule(function() vim.cmd("nohlsearch") end)
        end
    })
    aucmd("CursorMoved", {
        group = g,
        callback = function()
        -- No bloat lua adpatation of: https://github.com/romainl/vim-cool
        local view, rpos = vim.fn.winsaveview(), vim.fn.getpos(".")
        -- Move the cursor to a position where (whereas in active search) pressing `n`
        -- brings us to the original cursor position, in a forward search / that means
        -- one column before the match, in a backward search ? we move one col forward
        vim.cmd(string.format("silent! keepjumps go%s",
            (vim.fn.line2byte(view.lnum) + view.col + 1 - (vim.v.searchforward == 1 and 2 or 0))))
        -- Attempt to goto next match, if we're in an active search cursor position
        -- should be equal to original cursor position
        local ok, _ = pcall(vim.cmd, "silent! keepjumps norm! n")
        local insearch = ok and (function()
            local npos = vim.fn.getpos(".")
            return npos[2] == rpos[2] and npos[3] == rpos[3]
        end)()
        -- restore original view and position
        vim.fn.winrestview(view)
        if not insearch then
            vim.schedule(function() vim.cmd("nohlsearch") end)
        end
        end
    })
end)
EOF
