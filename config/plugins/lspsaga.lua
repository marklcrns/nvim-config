require("lspsaga").setup({
  ui = {
    -- currently only round theme
    theme = "round",
    -- border type can be single,double,rounded,solid,shadow.
    border = "solid",
    winblend = 0,
    expand = "",
    collapse = "",
    preview = " ",
    code_action = "💡",
    diagnostic = "🐞",
    incoming = " ",
    outgoing = " ",
    colors = {
      --float window normal bakcground color
      normal_bg = "#30302c",
      --title background color
      title_bg = "#afd700",
      red = "#e95678",
      magenta = "#b33076",
      orange = "#FF8700",
      yellow = "#f7bb3b",
      green = "#afd700",
      cyan = "#36d0e0",
      blue = "#61afef",
      purple = "#CBA6F7",
      white = "#d1d4cf",
      black = "#1c1c19",
    },
    kind = {},
  },
  outline = {
    win_position = "right",
    win_with = "",
    win_width = 30,
    show_detail = true,
    auto_preview = true,
    auto_refresh = true,
    auto_close = true,
    custom_sort = nil,
    keys = {
      jump = "<CR>",
      expand_collapse = "o",
      quit = "q",
    },
  },
  symbol_in_winbar = {
    enable = true,
    separator = "",
    ignore_patterns = {},
    hide_keyword = true,
    show_file = true,
    folder_level = 2,
    respect_root = false,
    color_mode = true,
  },
})

-- local keymap = vim.keymap.set
-- -- Lsp finder find the symbol definition implement reference
-- -- if there is no implement it will hide
-- -- when you use action in finder like open vsplit then you can
-- -- use <C-t> to jump back
-- keymap("n", "gh", "<cmd>Lspsaga lsp_finder<CR>")
--
-- -- Code action
-- keymap({"n","v"}, "<leader>ca", "<cmd>Lspsaga code_action<CR>")
--
-- -- Rename
-- keymap("n", "gr", "<cmd>Lspsaga rename<CR>")
--
-- -- Peek Definition
-- -- you can edit the definition file in this flaotwindow
-- -- also support open/vsplit/etc operation check definition_action_keys
-- -- support tagstack C-t jump back
-- keymap("n", "gd", "<cmd>Lspsaga peek_definition<CR>")
--
-- -- Go to Definition
-- keymap("n","gd", "<cmd>Lspsaga goto_definition<CR>")
--
-- -- Show line diagnostics you can pass arugment ++unfocus to make
-- -- show_line_diagnsotic float window unfocus
-- keymap("n", "<leader>sl", "<cmd>Lspsaga show_line_diagnostics<CR>")
--
-- -- Show cursor diagnostic
-- -- also like show_line_diagnostics  support pass ++unfocus
-- keymap("n", "<leader>sc", "<cmd>Lspsaga show_cursor_diagnostics<CR>")
--
-- -- Show buffer diagnostic
-- keymap("n", "<leader>sb", "<cmd>Lspsaga show_buf_diagnostics<CR>")
--
-- -- Diagnsotic jump can use `<c-o>` to jump back
-- keymap("n", "[e", "<cmd>Lspsaga diagnostic_jump_prev<CR>")
-- keymap("n", "]e", "<cmd>Lspsaga diagnostic_jump_next<CR>")
--
-- -- Diagnostic jump with filter like Only jump to error
-- keymap("n", "[E", function()
--   require("lspsaga.diagnostic").goto_prev({ severity = vim.diagnostic.severity.ERROR })
-- end)
-- keymap("n", "]E", function()
--   require("lspsaga.diagnostic").goto_next({ severity = vim.diagnostic.severity.ERROR })
-- end)
--
-- -- Toggle Outline
-- keymap("n","<leader>o", "<cmd>Lspsaga outline<CR>")
--
-- -- Hover Doc
-- -- if there has no hover will have a notify no information available
-- -- to disable it just Lspsaga hover_doc ++quiet
-- keymap("n", "K", "<cmd>Lspsaga hover_doc<CR>")
--
-- -- Callhierarchy
-- keymap("n", "<Leader>ci", "<cmd>Lspsaga incoming_calls<CR>")
-- keymap("n", "<Leader>co", "<cmd>Lspsaga outgoing_calls<CR>")
--
-- -- Float terminal
-- keymap({"n", "t"}, "<A-d>", "<cmd>Lspsaga term_toggle<CR>")
