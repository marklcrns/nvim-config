local keymap = vim.keymap.set

local saga = require('lspsaga')
saga.init_lsp_saga({
  -- symbols in winbar
  symbol_in_winbar = {
    enable = true,
  },
})

-- -- Lsp finder find the symbol definition implmement reference
-- keymap("n", "gh", "<cmd>Lspsaga lsp_finder<CR>", { silent = true })

-- -- Code action
-- keymap("n", "<leader>ca", "<cmd>Lspsaga code_action<CR>", { silent = true })
-- keymap("v", "<leader>ca", "<cmd><C-U>Lspsaga range_code_action<CR>", { silent = true })

-- -- Rename
-- keymap("n", "gr", "<cmd>Lspsaga rename<CR>", { silent = true })

-- -- Definition preview
-- keymap("n", "gd", "<cmd>Lspsaga preview_definition<CR>", { silent = true })

-- -- Show line diagnostics
-- keymap("n", "<leader>cd", "<cmd>Lspsaga show_line_diagnostics<CR>", { silent = true })

-- -- Show cursor diagnostic
-- keymap("n", "<leader>cd", "<cmd>Lspsaga show_cursor_diagnostics<CR>", { silent = true })

-- -- Diagnsotic jump
-- keymap("n", "[e", "<cmd>Lspsaga diagnostic_jump_next<CR>", { silent = true })
-- keymap("n", "]e", "<cmd>Lspsaga diagnostic_jump_prev<CR>", { silent = true })

-- -- Only jump to error
-- keymap("n", "[E", function()
--   require("lspsaga.diagnostic").goto_prev({ severity = vim.diagnostic.severity.ERROR })
-- end, { silent = true })
-- keymap("n", "]E", function()
--   require("lspsaga.diagnostic").goto_next({ severity = vim.diagnostic.severity.ERROR })
-- end, { silent = true })

-- -- Outline
-- keymap("n","<leader>o", "<cmd>LSoutlineToggle<CR>",{ silent = true })

-- -- Hover Doc
-- keymap("n", "K", "<cmd>Lspsaga hover_doc<CR>", { silent = true })

-- -- Signature help
-- keymap("n", "gs", "<Cmd>Lspsaga signature_help<CR>", { silent = true })

