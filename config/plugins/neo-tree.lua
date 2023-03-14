local function getTelescopeOpts(state, path)
  return {
    cwd = path,
    search_dirs = { path },
    attach_mappings = function(prompt_bufnr, map)
      local actions = require("telescope.actions")
      actions.select_default:replace(function()
        actions.close(prompt_bufnr)
        local action_state = require("telescope.actions.state")
        local selection = action_state.get_selected_entry()
        local filename = selection.filename
        if filename == nil then
          filename = selection[1]
        end
        -- any way to open the file without triggering auto-close event of neo-tree?
        require("neo-tree.sources.filesystem").navigate(state, state.path, filename)
      end)
      return true
    end,
  }
end

require("neo-tree").setup({
  close_if_last_window = true, -- Close Neo-tree if it is the last window left in the tab
  popup_border_style = "rounded",
  enable_git_status = true,
  enable_diagnostics = true,
  source_selector = {
    winbar = true,
    statusline = false,
  },
  default_component_configs = {
    container = {
      enable_character_fade = true,
    },
    indent = {
      indent_size = 2,
      padding = 1, -- extra padding on left hand side
      -- indent guides
      with_markers = true,
      indent_marker = "│",
      last_indent_marker = "└",
      highlight = "NeoTreeIndentMarker",
      -- expander config, needed for nesting files
      with_expanders = nil, -- if nil and file nesting is enabled, will enable expanders
      expander_collapsed = "",
      expander_expanded = "",
      expander_highlight = "NeoTreeExpander",
    },
    icon = {
      folder_closed = "",
      folder_open = "",
      folder_empty = "ﰊ",
      -- The next two settings are only a fallback, if you use nvim-web-devicons and configure default icons there
      -- then these will never be used.
      default = "*",
      highlight = "NeoTreeFileIcon",
    },
    modified = {
      symbol = "[+]",
      highlight = "NeoTreeModified",
    },
    name = {
      trailing_slash = false,
      use_git_status_colors = true,
      highlight = "NeoTreeFileName",
    },
    git_status = {
      symbols = {
        -- Change type
        added = "", -- or "✚", but this is redundant info if you use git_status_colors on the name
        modified = "", -- or "", but this is redundant info if you use git_status_colors on the name
        deleted = "✖", -- this can only be used in the git_status source
        renamed = "", -- this can only be used in the git_status source
        -- Status type
        untracked = "",
        ignored = "",
        unstaged = "",
        staged = "",
        conflict = "",
      },
    },
  },
  window = {
    position = "left",
    width = 35,
    mapping_options = {
      noremap = true,
      nowait = true,
    },
    mappings = {
      -- ["<cr>"] = {
      --   "toggle_node",
      --   nowait = false, -- disable `nowait` if you have existing combos starting with this char that you want to use
      -- },
      ["<2-LeftMouse>"] = "open",
      ["<esc>"] = "revert_preview",
      ["l"] = "focus_preview",
      ["<C-g>"] = "split_with_window_picker",
      ["<C-v>"] = "vsplit_with_window_picker",
      ["<cr>"] = "open_with_window_picker",
      ["e"] = "open_drop",
      ["t"] = "open_tabnew",
      ["<Tab>"] = "toggle_node",
      ["<S-Tab>"] = "close_node",
      -- ["t"] = "open_tab_drop",
      -- ["P"] = "toggle_preview", -- enter preview mode, which shows the current node without focusing
      ["P"] = { "toggle_preview", config = { use_float = true } },
      ["C"] = "close_all_subnodes",
      ["z"] = "close_all_nodes",
      ["Z"] = "expand_all_nodes",
      ["a"] = {
        "add",
        -- this command supports BASH style brace expansion ("x{a,b,c}" -> xa,xb,xc). see `:h neo-tree-file-actions` for details
        -- some commands may take optional config options, see `:h neo-tree-mappings` for details
        config = {
          show_path = "relative", -- "none", "relative", "absolute"
        },
      },
      ["A"] = "add_directory", -- also accepts the optional config.show_path option like "add". this also supports BASH style brace expansion.
      ["d"] = "delete",
      ["r"] = "rename",
      ["y"] = "copy_to_clipboard",
      ["x"] = "cut_to_clipboard",
      ["p"] = "paste_from_clipboard",
      -- ["c"] = "copy", -- takes text input for destination, also accepts the optional config.show_path option like "add":
      ["c"] = {
        "copy",
        config = {
          show_path = "relative", -- "none", "relative", "absolute"
        },
      },
      ["m"] = "move", -- takes text input for destination, also accepts the optional config.show_path option like "add".
      ["R"] = "refresh",
      ["?"] = "show_help",
      ["<"] = "prev_source",
      [">"] = "next_source",
      ["w"] = "toggle_auto_expand_width",
      ["f"] = "none",
      ["s"] = "none",
      ["q"] = "none", -- let smartq handle this
      ["o"] = "system_open",
      ["ff"] = "filter_on_submit",
      ["fd"] = "telescope_find",
      ["fr"] = "telescope_grep",
      ["Y"] = "copy_absolute_path",
    },
  },
  filesystem = {
    filtered_items = {
      visible = false, -- when true, they will just be displayed differently than normal items
      hide_dotfiles = true,
      hide_gitignored = true,
      hide_hidden = true, -- only works on Windows for hidden files/directories
      hide_by_name = {
        --"node_modules"
      },
      hide_by_pattern = { -- uses glob style patterns
        --"*.meta",
        --"*/src/*/tsconfig.json",
      },
      always_show = { -- remains visible even if other settings would normally hide it
        --".gitignored",
      },
      never_show = { -- remains hidden even if visible is toggled to true, this overrides always_show
        --".DS_Store",
        --"thumbs.db"
      },
      never_show_by_pattern = { -- uses glob style patterns
        --".null-ls_*",
      },
    },
    follow_current_file = false, -- This will find and focus the file in the active buffer every
    -- time the current file is changed while the tree is open.
    group_empty_dirs = false, -- when true, empty folders will be grouped together
    hijack_netrw_behavior = "open_default", -- netrw disabled, opening a directory opens neo-tree
    -- in whatever position is specified in window.position
    -- "open_current",  -- netrw disabled, opening a directory opens within the
    -- window like netrw would, regardless of window.position
    -- "disabled",    -- netrw left alone, neo-tree does not handle opening dirs
    use_libuv_file_watcher = false, -- This will use the OS level file watchers to detect changes
    -- instead of relying on nvim autocmd events.
    window = {
      mappings = {
        ["<bs>"] = "navigate_up",
        ["."] = "set_root",
        ["H"] = "toggle_hidden",
        ["/"] = "fuzzy_finder",
        ["D"] = "fuzzy_finder_directory",
        ["#"] = "fuzzy_sorter", -- fuzzy sorting using the fzy algorithm
        -- ["D"] = "fuzzy_sorter_directory",
        ["<C-x>"] = "clear_filter",
        ["[g"] = "prev_git_modified",
        ["]g"] = "next_git_modified",
        ["o"] = "system_open",
        ["ff"] = "filter_on_submit",
        ["fd"] = "telescope_find",
        ["fr"] = "telescope_grep",
        ["Y"] = "copy_absolute_path",
      },
    },
    commands = {
      system_open = function(state)
        local node = state.tree:get_node()
        local path = node:get_id()
        local sys = require("user.common.sys")

        if sys.is_mac() then
          vim.api.nvim_command("silent !open -g " .. path)
        elseif sys.is_wsl() then
          vim.api.nvim_command(string.format("silent !wsl-open '%s'", path))
        elseif sys.is_linux() then
          vim.api.nvim_command(string.format("silent !xdg-open '%s'", path))
        end
      end,
      telescope_find = function(state)
        local node = state.tree:get_node()
        local path = node:get_id()
        require("telescope.builtin").find_files(getTelescopeOpts(state, path))
      end,
      telescope_grep = function(state)
        local node = state.tree:get_node()
        local path = node:get_id()
        require("telescope.builtin").live_grep(getTelescopeOpts(state, path))
      end,
      copy_absolute_path = function(state) -- copy the absolute path of the current node to clipboard
        local node = state.tree:get_node()
        local content = node.path
        -- relative
        -- local content = node.path:gsub(state.path, ""):sub(2)
        vim.fn.setreg('"', content)
        vim.fn.setreg("1", content)
        vim.fn.setreg("+", content)
      end,
    },
  },
  buffers = {
    follow_current_file = true, -- This will find and focus the file in the active buffer every
    -- time the current file is changed while the tree is open.
    group_empty_dirs = true, -- when true, empty folders will be grouped together
    show_unloaded = true,
    window = {
      mappings = {
        ["bd"] = "buffer_delete",
        ["<bs>"] = "navigate_up",
        ["."] = "set_root",
        ["Y"] = "copy_absolute_path",
      },
    },
    commands = {
      system_open = function(state)
        local node = state.tree:get_node()
        local path = node:get_id()
        local sys = require("user.common.sys")

        if sys.is_mac() then
          vim.api.nvim_command("silent !open -g " .. path)
        elseif sys.is_wsl() then
          vim.api.nvim_command(string.format("silent !wsl-open '%s'", path))
        elseif sys.is_linux() then
          vim.api.nvim_command(string.format("silent !xdg-open '%s'", path))
        end
      end,
      telescope_find = function(state)
        local node = state.tree:get_node()
        local path = node:get_id()
        require("telescope.builtin").find_files(getTelescopeOpts(state, path))
      end,
      telescope_grep = function(state)
        local node = state.tree:get_node()
        local path = node:get_id()
        require("telescope.builtin").live_grep(getTelescopeOpts(state, path))
      end,
      copy_absolute_path = function(state) -- copy the absolute path of the current node to clipboard
        local node = state.tree:get_node()
        local content = node.path
        -- relative
        -- local content = node.path:gsub(state.path, ""):sub(2)
        vim.fn.setreg('"', content)
        vim.fn.setreg("1", content)
        vim.fn.setreg("+", content)
      end,
    },
  },
  git_status = {
    window = {
      position = "left",
      mappings = {
        ["A"] = "git_add_all",
        ["gu"] = "git_unstage_file",
        ["gs"] = "git_add_file",
        ["gr"] = "git_revert_file",
        ["gc"] = "git_commit",
        ["gp"] = "git_push",
        ["gg"] = "git_commit_and_push",
        ["o"] = "system_open",
        ["ff"] = "filter_on_submit",
        ["fd"] = "telescope_find",
        ["fr"] = "telescope_grep",
        ["Y"] = "copy_absolute_path",
      },
    },
    commands = {
      system_open = function(state)
        local node = state.tree:get_node()
        local path = node:get_id()
        local sys = require("user.common.sys")

        if sys.is_mac() then
          vim.api.nvim_command("silent !open -g " .. path)
        elseif sys.is_wsl() then
          vim.api.nvim_command(string.format("silent !wsl-open '%s'", path))
        elseif sys.is_linux() then
          vim.api.nvim_command(string.format("silent !xdg-open '%s'", path))
        end
      end,
      telescope_find = function(state)
        local node = state.tree:get_node()
        local path = node:get_id()
        require("telescope.builtin").find_files(getTelescopeOpts(state, path))
      end,
      telescope_grep = function(state)
        local node = state.tree:get_node()
        local path = node:get_id()
        require("telescope.builtin").live_grep(getTelescopeOpts(state, path))
      end,
      copy_absolute_path = function(state) -- copy the absolute path of the current node to clipboard
        local node = state.tree:get_node()
        local content = node.path
        -- relative
        -- local content = node.path:gsub(state.path, ""):sub(2)
        vim.fn.setreg('"', content)
        vim.fn.setreg("1", content)
        vim.fn.setreg("+", content)
      end,
    },
  },
})
