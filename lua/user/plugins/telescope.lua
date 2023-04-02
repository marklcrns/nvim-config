return function()
  local actions = require("telescope.actions")
  local action_state = require("telescope.actions.state")

  local function deep_extend(...)
    local args = { ... }
    return vim.tbl_deep_extend("force", args[1], args[2] or {}, select(3, ...))
  end

  local picker_presets = {
    vertical_preview_bottom = {
      trim_text = true,
      fname_width = 80,
      path_display = { "truncate" },
      layout_strategy = "vertical",
      layout_config = {
        preview_cutoff = 25,
        mirror = true,
      },
    },
  }

  require("telescope").setup({
    defaults = {
      vimgrep_arguments = {
        "rg",
        "--color=never",
        "--no-heading",
        "--with-filename",
        "--line-number",
        "--column",
        "--smart-case",
      },
      winblend = 5,
      width = 0.8,
      show_line = false,
      -- prompt_prefix = "> ",
      prompt_prefix = "  ",
      selection_caret = "➤ ",
      entry_prefix = "  ",
      initial_mode = "insert",
      results_title = false,
      borderchars = {
        prompt = { "▀", "▐", "▄", "▌", "▛", "▜", "▟", "▙" },
        results = { "▀", "▐", "▄", "▌", "▛", "▜", "▟", "▙" },
        preview = { "▀", "▐", "▄", "▌", "▛", "▜", "▟", "▙" },
      },
      -- borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },

      mappings = {
        i = {
          ["<C-n>"] = actions.move_selection_next,
          ["<C-p>"] = actions.move_selection_previous,

          ["<C-c>"] = actions.close,

          ["<Down>"] = actions.move_selection_next,
          ["<Up>"] = actions.move_selection_previous,

          ["<CR>"] = actions.select_default,
          ["<C-g>"] = actions.select_horizontal,
          ["<C-v>"] = actions.select_vertical,
          ["<C-t>"] = actions.select_tab,

          ["<C-u>"] = actions.preview_scrolling_up,
          ["<C-d>"] = actions.preview_scrolling_down,

          ["<PageUp>"] = actions.results_scrolling_up,
          ["<PageDown>"] = actions.results_scrolling_down,

          ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
          ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
          ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
          ["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
          ["<C-l>"] = actions.complete_tag,
          ["<C-/>"] = actions.which_key,
          ["<C-_>"] = actions.which_key, -- keys from pressing <C-/>
          ["<C-w>"] = { "<c-s-w>", type = "command" },

          -- disable c-j because we dont want to allow new lines #2123
          ["<C-j>"] = actions.nop,
        },

        n = {
          ["<esc>"] = actions.close,
          ["<CR>"] = actions.select_default,
          ["<C-g>"] = actions.select_horizontal,
          ["<C-v>"] = actions.select_vertical,
          ["<C-t>"] = actions.select_tab,

          ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
          ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
          ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
          ["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,

          -- TODO: This would be weird if we switch the ordering.
          ["j"] = actions.move_selection_next,
          ["k"] = actions.move_selection_previous,
          ["H"] = actions.move_to_top,
          ["M"] = actions.move_to_middle,
          ["L"] = actions.move_to_bottom,

          ["<Down>"] = actions.move_selection_next,
          ["<Up>"] = actions.move_selection_previous,
          ["gg"] = actions.move_to_top,
          ["G"] = actions.move_to_bottom,

          ["<C-u>"] = actions.preview_scrolling_up,
          ["<C-d>"] = actions.preview_scrolling_down,

          ["<PageUp>"] = actions.results_scrolling_up,
          ["<PageDown>"] = actions.results_scrolling_down,

          ["?"] = actions.which_key,
        },
      },
    },

    pickers = {
      find_files = {
        results_title = false,
      },
      git_files = {
        results_title = false,
      },
      git_status = {
        expand_dir = false,
      },
      git_commits = {
        mappings = {
          i = {
            ["<M-d>"] = function()
              -- Open in diffview
              local entry = action_state.get_selected_entry()
              -- close Telescope window properly prior to switching windows
              actions.close(vim.api.nvim_get_current_buf())
              vim.cmd(("DiffviewOpen %s^!"):format(entry.value))
            end,
          },
        },
      },
      buffers = {
        sort_mru = true,
        previewer = true,
        mappings = {
          i = {
            ["<c-d>"] = require("telescope.actions").delete_buffer,
          },
          n = {
            ["<c-d>"] = require("telescope.actions").delete_buffer,
          },
        },
      },
      quickfix = deep_extend(picker_presets.vertical_preview_bottom),
      loclist = deep_extend(picker_presets.vertical_preview_bottom),
      lsp_references = deep_extend(picker_presets.vertical_preview_bottom),
      lsp_definitions = deep_extend(picker_presets.vertical_preview_bottom),
      lsp_type_definitions = deep_extend(picker_presets.vertical_preview_bottom),
      lsp_implementations = deep_extend(picker_presets.vertical_preview_bottom),
      lsp_document_symbols = deep_extend(picker_presets.vertical_preview_bottom),
      lsp_workspace_symbols = deep_extend(picker_presets.vertical_preview_bottom),
      lsp_dynamic_workspace_symbols = deep_extend(picker_presets.vertical_preview_bottom),
      current_buffer_fuzzy_find = {
        tiebreak = function(a, b)
          -- Sort tiebreaks by line number
          return a.lnum < b.lnum
        end,
      },
    },

    extensions = {
      fzf = {
        fuzzy = true, -- false will only do exact matching
        override_generic_sorter = false, -- override the generic sorter
        override_file_sorter = true, -- override the file sorter
        case_mode = "smart_case", -- or "ignore_case" or "respect_case"
        -- the default case_mode is "smart_case"
      },
      media_files = {
        -- filetypes whitelist
        -- defaults to {"png", "jpg", "mp4", "webm", "pdf"}
        filetypes = { "png", "webp", "jpg", "jpeg", "mp4", "webm", "pdf" },
        -- find command (defaults to `fd`)
        find_cmd = "rg",
      },
      ["ui-select"] = {
        require("telescope.themes").get_dropdown({}),
      },
    },
  })

  -- Load extensions
  require("telescope").load_extension("notify")
  require("telescope").load_extension("fzf")
  require("telescope").load_extension("media_files")
  require("telescope").load_extension("ui-select")
  require("telescope").load_extension("mapper")

  -- -- Mappings
  -- local mapper = Config.common.mapper
  -- local prog = "Telescope"
  -- local opts = { silent = true }
  -- local mappings = {}
  -- mappings["<leader>fdf"] = { args = "find_files", id = "telescope_find_files", desc = "Find files" }
  -- mappings["<leader>fdb"] = { args = "buffers", id = "telescope_buffers", desc = "Find buffers" }
  -- mappings["<leader>fdc"] = { args = "colorscheme", id = "telescope_colorscheme", desc = "Pick colorscheme" }
  -- mappings["<leader>fdp"] = { args = "projects", id = "telescope_projects", desc = "Find projects" }
  -- mappings["<leader>fdr"] = { args = "live_grep", id = "telescope_live_grep", desc = "Live grep" }
  -- mappings["<leader>fdh"] = { args = "help_tags", id = "telescope_help_tags", desc = "Find help tags" }
  -- mappings["<leader>fdj"] = { args = "jumplist", id = "telescope_jumplist", desc = "Find jumplist" }
  -- mappings["<leader>fdm"] = { args = "marks", id = "telescope_marks", desc = "Find marks" }
  -- mappings["<leader>fdo"] = { args = "oldfiles", id = "telescope_oldfiles", desc = "Find oldfiles" }
  -- mappings["<leader>fdw"] = { args = "grep_string", id = "telescope_grep_string", desc = "Find string" }
  -- mappings["<leader>fdgb"] = { args = "git_branches", id = "telescope_git_branches", desc = "Find git branches" }
  -- mappings["<leader>fdgc"] = { args = "git_commits", id = "telescope_git_commits", desc = "Find git commits" }
  -- mappings["<leader>fdgC"] = { args = "git_bcommits", id = "telescope_git_bcommits", desc = "Find git branch commits" }
  -- mappings["<leader>fdgf"] = { args = "git_files", id = "telescope_git_files", desc = "Find git files" }
  -- mappings["<leader>fdgs"] = { args = "git_status", id = "telescope_git_status", desc = "Find git status" }
  --
  -- for k, v in pairs(mappings) do
  --   local cmd = string.format(":%s %s<CR>", prog, v.args)
  --   mapper.map("n", k, cmd, opts, prog, v.id, v.desc)
  -- end
end
