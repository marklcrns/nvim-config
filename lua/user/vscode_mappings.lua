local keymap = vim.keymap.set
local vscode = require('vscode')
local opts = { noremap = true, silent = true }

-- Helper Functions
local function with_insert_mode_callback(callback)
    return function()
        vscode.with_insert(callback)
    end
end

-- Basic Setup
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Clear default space mappings
keymap({"n", "x"}, "<Space>", "<Nop>", opts)
keymap({"n", "x"}, ",", "<Nop>", opts)
keymap({"n", "x"}, ";", "<Nop>", opts)

-------------------------------------------------------------------------------
-- Basic Mappings
-------------------------------------------------------------------------------

-- Exit mappings
keymap("n", "Q", "q", opts) -- Remap macro recording to Q
keymap("n", "q", function() vscode.action('workbench.action.closeActiveEditor') end)

-- Basic movement improvements
keymap("n", "gh", "g^", opts)
keymap("n", "gl", "g$", opts)
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- Keep cursor at the bottom of visual selection after yanking
keymap("v", "y", "ygv<Esc>", opts)
keymap("n", "Y", "y$", opts)

-- Prevent selecting and pasting from overwriting what you originally copied
keymap("x", "p", "pgvy", opts)

-- Preserve registers when deleting single characters
keymap("n", "x", '"_x', opts)
keymap("n", "X", '"_X', opts)

-- Keep search results centered
keymap("n", "n", "nzzzv", opts)
keymap("n", "N", "Nzzzv", opts)

-- Keep cursor position when joining lines
keymap("n", "J", ":let p=getpos('.')<CR>:join<CR>:call setpos('.', p)<CR>", opts)

-- Escape insert mode alternatives
keymap("i", "kj", "<Esc>`^", opts)
keymap("i", "fd", "<Esc>`^", opts)
keymap("v", "fd", "<Esc>`<", opts)
keymap("v", "df", "<Esc>`>", opts)

-- Makes relative number jumps work with text wrap
keymap({"n", "v"}, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
keymap({"n", "v"}, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- Move text up and down
keymap("v", "J", ":m .+1<CR>==", opts)
keymap("v", "K", ":m .-2<CR>==", opts)
keymap("x", "J", ":move '>+1<CR>gv-gv", opts)
keymap("x", "K", ":move '<-2<CR>gv-gv", opts)

-------------------------------------------------------------------------------
-- VSCode Specific Commands
-------------------------------------------------------------------------------

-- Navigation
keymap({"n", "v"}, "<C-j>", function() vscode.action('workbench.action.navigateDown') end)
keymap({"n", "v"}, "<C-k>", function() vscode.action('workbench.action.navigateUp') end)
keymap({"n", "v"}, "<C-h>", function() vscode.action('workbench.action.navigateLeft') end)
keymap({"n", "v"}, "<C-l>", function() vscode.action('workbench.action.navigateRight') end)

-- Window Management
keymap("n", "<C-w>s", function() vscode.action('workbench.action.splitEditorDown') end)
keymap("n", "<C-w>v", function() vscode.action('workbench.action.splitEditorRight') end)
keymap("n", "<C-w>c", function() vscode.action('workbench.action.closeActiveEditor') end)
keymap("n", "<C-w>=", function() vscode.action('workbench.action.evenEditorWidths') end)

-- File Navigation
keymap({"n", "v"}, "<Leader>ff", function() vscode.action('workbench.action.quickOpen') end)
keymap({"n", "v"}, "<Leader>fg", function() vscode.action('workbench.action.findInFiles') end)
keymap({"n", "v"}, "gd", function() vscode.action('editor.action.revealDefinition') end)
keymap({"n", "v"}, "gr", function() vscode.action('editor.action.goToReferences') end)
keymap({"n", "v"}, "gD", function() vscode.action('editor.action.peekDefinition') end)
keymap({"n", "v"}, "gi", function() vscode.action('editor.action.goToImplementation') end)

-- Code Actions
keymap({"n", "v"}, "<Leader>ca", function() vscode.action('editor.action.quickFix') end)
keymap({"n", "v"}, "<Leader>rn", function() vscode.action('editor.action.rename') end)
keymap({"n", "v"}, "<Leader>.", function() vscode.action('editor.action.quickFix') end)
keymap({"n"}, "K", function() vscode.action('editor.action.showHover') end)

-- Format Document
keymap({"n", "v"}, "=", function() vscode.action('editor.action.formatSelection') end)
keymap("n", "<Leader>fd", function() vscode.action('editor.action.formatDocument') end)

-- Comments
keymap({"n", "v"}, "gc", function() vscode.action('editor.action.commentLine') end)
keymap({"n", "v"}, "gC", function() vscode.action('editor.action.blockComment') end)

-- Terminal
keymap({"n", "v"}, "<Leader>t", function() vscode.action('workbench.action.terminal.toggleTerminal') end)

-- Multi-Cursor Support (when in visual modes)
keymap("x", "ma", function() vscode.action('editor.action.insertCursorBelow') end)
keymap("x", "mi", function() vscode.action('editor.action.insertCursorAbove') end)

-- Search improvements
keymap("n", "<Esc>", "<Esc>:noh<CR>", opts)

-- Tab Management
keymap("n", "[t", function() vscode.action('workbench.action.previousEditorInGroup') end)
keymap("n", "]t", function() vscode.action('workbench.action.nextEditorInGroup') end)
keymap("n", "<M-[>", function() vscode.action('workbench.action.previousEditorInGroup') end)
keymap("n", "<M-]>", function() vscode.action('workbench.action.nextEditorInGroup') end)

-- File Explorer
keymap("n", "<Leader>e", function() vscode.action('workbench.action.toggleSidebarVisibility') end)

-- Problems/Diagnostics
keymap("n", "[d", function() vscode.action('editor.action.marker.prev') end)
keymap("n", "]d", function() vscode.action('editor.action.marker.next') end)
keymap("n", "<Leader>sp", function() vscode.action('workbench.actions.view.problems') end)

-- Folding
keymap("n", "za", function() vscode.action('editor.toggleFold') end)
keymap("n", "zR", function() vscode.action('editor.unfoldAll') end)
keymap("n", "zM", function() vscode.action('editor.foldAll') end)
keymap("n", "zo", function() vscode.action('editor.unfold') end)
keymap("n", "zc", function() vscode.action('editor.fold') end)

-------------------------------------------------------------------------------
-- Project Management
-------------------------------------------------------------------------------

-- Workspace
keymap({"n", "v"}, "<Leader>po", function() vscode.action('workbench.action.openRecent') end)
keymap({"n", "v"}, "<Leader>pf", function() vscode.action('workbench.action.files.openFolder') end)

-------------------------------------------------------------------------------
-- Enhanced Editing Commands
-------------------------------------------------------------------------------

-- Command mode improvements
keymap("c", "<C-a>", "<Home>", opts)
keymap("c", "<C-e>", "<End>", opts)
keymap("c", "<C-h>", "<BS>", opts)

-- Multiple cursor support
keymap({"n", "x"}, "<C-d>", with_insert_mode_callback(function()
    vscode.action("editor.action.addSelectionToNextFindMatch")
end))

-- Selection expansion
keymap({"n", "x"}, "gk", function() vscode.action('editor.action.smartSelect.expand') end)
keymap({"n", "x"}, "gj", function() vscode.action('editor.action.smartSelect.shrink') end)

-------------------------------------------------------------------------------
-- Plugins
-------------------------------------------------------------------------------

-- Only load minimal plugin set that works well with VSCode
require("user.core.bootstrap")
require("lazy").setup({
    { "tpope/vim-repeat" },
    { "tpope/vim-surround" },
    { "kana/vim-niceblock" },
})
