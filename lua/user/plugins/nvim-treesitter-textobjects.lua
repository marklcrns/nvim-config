return function()
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
          ["]a"] = { query = "@assignment.outer", desc = "Next assignment start" },
          ["]n"] = { query = "@number.inner", desc = "Next number start" },
          ["]p"] = { query = "@parameter.inner", desc = "Next parameter start" },
          ["]f"] = { query = "@function.outer", desc = "Next function start" },
          ["]s"] = { query = "@scope", query_group = "locals", desc = "Next scope" },
          ["]}"] = { query = "@block.outer", desc = "Next block start" },
          ["]]"] = { query = "@class.outer", desc = "Next class start" },
          ["]["] = { query = "@class.inner", desc = "Next class inner start" },
          -- ["]z"] = { query = "@fold", query_group = "folds", desc = "Next fold" },

          -- You can use regex matching and/or pass a list in a "query" key to group multiple queires.
          ["]o"] = "@loop.*",
          -- ["]o"] = { query = { "@loop.inner", "@loop.outer" } },
        },
        goto_previous_start = {
          ["[a"] = { query = "@assignment.outer", desc = "Previous assignment start" },
          ["[n"] = { query = "@number.inner", desc = "Previous number start" },
          ["[p"] = { query = "@parameter.inner", desc = "Previous parameter start" },
          ["[f"] = { query = "@function.outer", desc = "Previous function start" },
          ["[s"] = { query = "@scope", query_group = "locals", desc = "Previous scope" },
          ["[}"] = { query = "@block.outer", desc = "Next block start" },
          ["[["] = { query = "@class.outer", desc = "Previous class start" },
          ["[]"] = { query = "@class.inner", desc = "Previous class inner start" },
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
          ["]i"] = { query = "@conditional.inner", desc = "Next conditional" },
        },
        goto_previous = {
          ["[i"] = { query = "@conditional.inner", desc = "Previous conditional" },
        },
      },
      select = {
        -- INFO: Disabled in favor of mini.ai
        enable = false,

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

  -- DEPRECATED: Conflicts with nvim-surround and possibly similar plugins
  -- -- Optionally, make builtin vim f, F, t, T also repeatable with ; and ,
  -- vim.keymap.set({ "n", "x", "o" }, "f", ts_repeat_move.builtin_f)
  -- vim.keymap.set({ "n", "x", "o" }, "F", ts_repeat_move.builtin_F)
  -- vim.keymap.set({ "n", "x", "o" }, "t", ts_repeat_move.builtin_t)
  -- vim.keymap.set({ "n", "x", "o" }, "T", ts_repeat_move.builtin_T)

  ----------------------------
  --  Gitsigns integration  --
  ----------------------------

  local gs = require("gitsigns")

  -- make sure forward function comes first
  local next_hunk_repeat, prev_hunk_repeat = ts_repeat_move.make_repeatable_move_pair(gs.next_hunk, gs.prev_hunk)
  -- Or, use `make_repeatable_move` or `set_last_move` functions for more control. See the code for instructions.

  vim.keymap.set({ "n", "x", "o" }, "]g", next_hunk_repeat)
  vim.keymap.set({ "n", "x", "o" }, "[g", prev_hunk_repeat)

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

  vim.keymap.set({ "n", "x", "o" }, "]z", next_fold_repeat)
  vim.keymap.set({ "n", "x", "o" }, "[z", prev_fold_repeat)

  -----------------------
  --  LSP integration  --
  -----------------------

  local function goNextDiagnostic()
    vim.diagnostic.goto_next({ float = false })
  end

  local function goPreviousDiagnostic()
    vim.diagnostic.goto_prev({ float = false })
  end

  local next_diagnostic_repeat, prev_diagnostic_repeat =
    ts_repeat_move.make_repeatable_move_pair(goNextDiagnostic, goPreviousDiagnostic)

  vim.keymap.set({ "n", "x", "o" }, "]d", next_diagnostic_repeat)
  vim.keymap.set({ "n", "x", "o" }, "[d", prev_diagnostic_repeat)

  --------------------------------
  --  Vim builtins integration  --
  --------------------------------

  -- Diff navigation

  local function goNextDiff()
    vim.cmd("normal! ]c")
  end
  local function goPreviousDiff()
    vim.cmd("normal! [c")
  end

  local next_diff_repeat, prev_diff_repeat = ts_repeat_move.make_repeatable_move_pair(goNextDiff, goPreviousDiff)

  vim.keymap.set({ "n", "x", "o" }, "]c", next_diff_repeat)
  vim.keymap.set({ "n", "x", "o" }, "[c", prev_diff_repeat)

  -- Tab navigation

  local function goNextTab()
    vim.cmd("tabnext")
  end
  local function goPreviousTab()
    vim.cmd("tabprevious")
  end

  local next_tab_repeat, prev_tab_repeat = ts_repeat_move.make_repeatable_move_pair(goNextTab, goPreviousTab)

  vim.keymap.set({ "n", "x", "o" }, "]t", next_tab_repeat)
  vim.keymap.set({ "n", "x", "o" }, "[t", prev_tab_repeat)

  -- Buffer navigation

  local function goNextBuffer()
    vim.cmd("bnext")
  end
  local function goPreviousBuffer()
    vim.cmd("bprevious")
  end

  local next_buffer_repeat, prev_buffer_repeat =
    ts_repeat_move.make_repeatable_move_pair(goNextBuffer, goPreviousBuffer)

  vim.keymap.set({ "n", "x", "o" }, "]b", next_buffer_repeat)
  vim.keymap.set({ "n", "x", "o" }, "[b", prev_buffer_repeat)

  -- Quickfix navigation

  -- local function goNextQuickfix()
  --   vim.cmd("cnext")
  -- end
  -- local function goPreviousQuickfix()
  --   vim.cmd("cprevious")
  -- end
  --
  -- local next_quickfix_repeat, prev_quickfix_repeat =
  --   ts_repeat_move.make_repeatable_move_pair(goNextQuickfix, goPreviousQuickfix)
  --
  -- vim.keymap.set({ "n", "x", "o" }, "]q", next_quickfix_repeat)
  -- vim.keymap.set({ "n", "x", "o" }, "[q", prev_quickfix_repeat)

  -- Locationlist navigation

  local function goNextLocationlist()
    vim.cmd("lnext")
  end
  local function goPreviousLocationlist()
    vim.cmd("lprevious")
  end

  local next_locationlist_repeat, prev_locationlist_repeat =
    ts_repeat_move.make_repeatable_move_pair(goNextLocationlist, goPreviousLocationlist)

  vim.keymap.set({ "n", "x", "o" }, "]l", next_locationlist_repeat)
  vim.keymap.set({ "n", "x", "o" }, "[l", prev_locationlist_repeat)
end
