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
      prompt_prefix = "  ",
      selection_caret = "➤ ",
      entry_prefix = "  ",
      initial_mode = "insert",
      results_title = false,
      selection_strategy = "reset",
      sorting_strategy = "ascending",
      layout_strategy = "horizontal",
      -- borderchars = {
      --   prompt = { "▀", "▐", "▄", "▌", "▛", "▜", "▟", "▙" },
      --   results = { "▀", "▐", "▄", "▌", "▛", "▜", "▟", "▙" },
      --   preview = { "▀", "▐", "▄", "▌", "▛", "▜", "▟", "▙" },
      -- },
      layout_config = {
        prompt_position = "top",
        preview_cutoff = 120,
        width = 0.75,
        horizontal = {
          mirror = false,
        },
        vertical = {
          mirror = false,
        },
      },
      path_display = {
        "truncate",
      },
      file_sorter = require("telescope.sorters").get_fuzzy_file,
      file_ignore_patterns = {},
      generic_sorter = require("telescope.sorters").get_generic_fuzzy_sorter,
      winblend = 5,
      border = {},
      borderchars = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
      color_devicons = true,
      use_less = true,
      set_env = { ["COLORTERM"] = "truecolor" }, -- default = nil,
      file_previewer = require("telescope.previewers").vim_buffer_cat.new,
      grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
      qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
      -- Developer configurations: Not meant for general override
      buffer_previewer_maker = require("telescope.previewers").buffer_previewer_maker,
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
          ["<c-k>"] = actions.nop,
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
        override_generic_sorter = true, -- override the generic sorter
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
      undo = {
        mappings = {
          i = {
            ["<CR>"] = require("telescope-undo.actions").yank_additions,
            ["<M-CR>"] = require("telescope-undo.actions").yank_deletions,
            ["<BS>"] = require("telescope-undo.actions").restore,
          },
        },
      },
      ast_grep = {
        command = {
          "sg",
          "--json=stream",
          "-p",
        }, -- must have --json and -p
        grep_open_files = false, -- search in opened files
        lang = nil, -- string value, sepcify language for ast-grep `nil` for default
      },
    },
  })

  -- Load extensions
  -- require("telescope").load_extension("frecency")
  require("telescope").load_extension("fzf")
  require("telescope").load_extension("harpoon")
  require("telescope").load_extension("media_files")
  require("telescope").load_extension("notify")
  require("telescope").load_extension("projects")
  require("telescope").load_extension("ui-select")
  require("telescope").load_extension("undo")
end
