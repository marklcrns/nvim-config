require("nvim-treesitter.configs").setup({
  textobjects = {
    swap = {
      enable = true,
      swap_next = {
        ["]P"] = "@parameter.inner",
        ["]F"] = "@function.outer",
        ["]I"] = "@conditional.outer",
        ["]O"] = "@loop.outer",
      },
      swap_previous = {
        ["[P"] = "@parameter.inner",
        ["[F"] = "@function.outer",
        ["[I"] = "@conditional.outer",
        ["[O"] = "@loop.outer",
      },
    },
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        ["]p"] = { query = "@parameter.inner", desc = "Next parameter start" },
        ["]f"] = { query = "@function.outer", desc = "Next function start" },
        ["]]"] = { query = "@class.outer", desc = "Next class start" },
        ["]s"] = { query = "@scope", query_group = "locals", desc = "Next scope" },
        -- ["]z"] = { query = "@fold", query_group = "folds", desc = "Next fold" },

        -- You can use regex matching and/or pass a list in a "query" key to group multiple queires.
        ["]o"] = "@loop.*",
        -- ["]o"] = { query = { "@loop.inner", "@loop.outer" } },
      },
      goto_previous_start = {
        ["[p"] = { query = "@parameter.inner", desc = "Previous parameter start" },
        ["[f"] = { query = "@function.outer", desc = "Previous function start" },
        ["[["] = { query = "@class.outer", desc = "Previous class start" },
        ["[s"] = { query = "@scope", query_group = "locals", desc = "Previous scope" },
        -- ["[z"] = { query = "@fold", query_group = "folds", desc = "Previous fold" },

        ["[o"] = "@loop.*",
      },
      -- goto_next_end = {
      --   ["]F"] = { query = "@function.outer", desc = "Next function end" },
      --   ["]["] = { query = "@class.outer", desc = "Next class end" },
      -- },
      -- goto_previous_end = {
      --   ["[F"] = { query = "@function.outer", desc = "Previous function end" },
      --   ["[]"] = { query = "@class.outer", desc = "Previous class end" },
      -- },
      -- Below will go to either the start or the end, whichever is closer.
      -- Use if you want more granular movements
      -- Make it even more gradual by adding multiple queries and regex.
      goto_next = {
        ["]i"] = { query = "@conditional.outer", desc = "Next conditional" },
      },
      goto_previous = {
        ["[i"] = { query = "@conditional.outer", desc = "Previous conditional" },
      },
    },
    select = {
      enable = true,

      -- Automatically jump forward to textobj, similar to targets.vim
      lookahead = true,

      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        -- You can optionally set descriptions to the mappings (used in the desc parameter of
        -- nvim_buf_set_keymap) which plugins like which-key display
        ["ic"] = { query = "@class.inner", desc = "Select inner part of a class region" },
        -- You can also use captures from other query groups like `locals.scm`
        ["as"] = { query = "@scope", query_group = "locals", desc = "Select language scope" },
      },
      -- You can choose the select mode (default is charwise 'v')
      --
      -- Can also be a function which gets passed a table with the keys
      -- * query_string: eg '@function.inner'
      -- * method: eg 'v' or 'o'
      -- and should return the mode ('v', 'V', or '<c-v>') or a table
      -- mapping query_strings to modes.
      selection_modes = {
        ["@parameter.outer"] = "v", -- charwise
        ["@function.outer"] = "V", -- linewise
        ["@class.outer"] = "<c-v>", -- blockwise
      },
      -- If you set this to `true` (default is `false`) then any textobject is
      -- extended to include preceding or succeeding whitespace. Succeeding
      -- whitespace has priority in order to act similarly to eg the built-in
      -- `ap`.
      --
      -- Can also be a function which gets passed a table with the keys
      -- * query_string: eg '@function.inner'
      -- * selection_mode: eg 'v'
      -- and should return true of false
      include_surrounding_whitespace = true,
    },
  },
})

local ts_repeat_move = require("nvim-treesitter.textobjects.repeatable_move")

-- Repeat movement with ; and ,
-- ensure ; goes forward and , goes backward regardless of the last direction
-- vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move_next)
-- vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_previous)

-- vim way: ; goes to the direction you were moving.
vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move)
vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_opposite)

-- Optionally, make builtin vim f, F, t, T also repeatable with ; and ,
vim.keymap.set({ "n", "x", "o" }, "f", ts_repeat_move.builtin_f)
vim.keymap.set({ "n", "x", "o" }, "F", ts_repeat_move.builtin_F)
vim.keymap.set({ "n", "x", "o" }, "t", ts_repeat_move.builtin_t)
vim.keymap.set({ "n", "x", "o" }, "T", ts_repeat_move.builtin_T)

----------------------------
--  Gitsigns integration  --
----------------------------

local gs = require("gitsigns")

-- make sure forward function comes first
local next_hunk_repeat, prev_hunk_repeat = ts_repeat_move.make_repeatable_move_pair(gs.next_hunk, gs.prev_hunk)
-- Or, use `make_repeatable_move` or `set_last_move` functions for more control. See the code for instructions.

vim.keymap.set({ "n", "x", "o" }, "]h", next_hunk_repeat)
vim.keymap.set({ "n", "x", "o" }, "[h", prev_hunk_repeat)

----------------------------
--  Nvim-ufo integration  --
----------------------------

local function goNextClosedAndPeek()
  require("ufo").goNextClosedFold()
  require("ufo").peekFoldedLinesUnderCursor()
end

local function goPreviousClosedAndPeek()
  require("ufo").goPreviousClosedFold()
  require("ufo").peekFoldedLinesUnderCursor()
end

local next_fold_repeat, prev_fold_repeat =
  ts_repeat_move.make_repeatable_move_pair(goNextClosedAndPeek, goPreviousClosedAndPeek)

vim.keymap.set("n", "]z", next_fold_repeat)
vim.keymap.set("n", "[z", prev_fold_repeat)

-----------------------
--  LSP integration  --
-----------------------

local next_diagnostic_repeat, prev_diagnostic_repeat =
  ts_repeat_move.make_repeatable_move_pair(vim.diagnostic.goto_next, vim.diagnostic.goto_prev)

vim.keymap.set("n", "]d", next_diagnostic_repeat)
vim.keymap.set("n", "[d", prev_diagnostic_repeat)
