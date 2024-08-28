return function()
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
        ["<C-t>"] = "open_tabnew",
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
        ["dD"] = "delete",
        ["r"] = "rename",
        ["yy"] = "copy_to_clipboard",
        ["d"] = "",
        ["dd"] = "cut_to_clipboard",
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
        ["S"] = "none",
        ["q"] = "none", -- let smartq handle this
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
        -- Harpoon integration {{{
        components = {
          harpoon_index = function(config, node, state)
            local Marked = require("harpoon.mark")
            local path = node:get_id()
            local succuss, index = pcall(Marked.get_index_of, path)
            if succuss and index and index > 0 then
              return {
                text = string.format(" ⥤ %d", index), -- <-- Add your favorite harpoon like arrow here
                highlight = config.highlight or "NeoTreeDirectoryIcon",
              }
            else
              return {}
            end
          end,
        },
        renderers = {
          file = {
            { "icon" },
            { "name", use_git_status_colors = true },
            { "harpoon_index" }, --> This is what actually adds the component in where you want it
            { "diagnostics" },
            { "git_status", highlight = "NeoTreeDimText" },
          },
        },
        -- }}}
      },
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
          ["ff"] = "filter_on_submit", -- For filesystem only!
          ["o"] = "system_open",
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
      follow_current_file = {
        enabled = true, -- This will find and focus the file in the active buffer every time
        --              -- the current file is changed while the tree is open.
        leave_dirs_open = true, -- `false` closes auto expanded dirs, such as with `:Neotree reveal`
      },
      -- time the current file is changed while the tree is open.
      group_empty_dirs = true, -- when true, empty folders will be grouped together
      show_unloaded = true,
      window = {
        mappings = {
          ["<cr>"] = "open_tab_drop",
          ["bd"] = "buffer_delete",
          ["<bs>"] = "navigate_up",
          ["."] = "set_root",
          ["o"] = "system_open",
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

    -- Nerd Font v3 Fix {{{
    default_component_configs = {
      icon = {
        folder_empty = "󰜌",
        folder_empty_open = "󰜌",
      },
      git_status = {
        symbols = {
          renamed = "󰁕",
          unstaged = "󰄱",
        },
      },
    },
    document_symbols = {
      kinds = {
        File = { icon = "󰈙", hl = "Tag" },
        Namespace = { icon = "󰌗", hl = "Include" },
        Package = { icon = "󰏖", hl = "Label" },
        Class = { icon = "󰌗", hl = "Include" },
        Property = { icon = "󰆧", hl = "@property" },
        Enum = { icon = "󰒻", hl = "@number" },
        Function = { icon = "󰊕", hl = "Function" },
        String = { icon = "󰀬", hl = "String" },
        Number = { icon = "󰎠", hl = "Number" },
        Array = { icon = "󰅪", hl = "Type" },
        Object = { icon = "󰅩", hl = "Type" },
        Key = { icon = "󰌋", hl = "" },
        Struct = { icon = "󰌗", hl = "Type" },
        Operator = { icon = "󰆕", hl = "Operator" },
        TypeParameter = { icon = "󰊄", hl = "Type" },
        StaticMethod = { icon = "󰠄 ", hl = "Function" },
      },
    },
    -- Add this section only if you've configured source selector.
    sources = { "filesystem", "buffers", "git_status" },
    source_selector = {
      winbar = true,
      sources = {
        { source = "filesystem", display_name = " 󰉓 Files " },
        { source = "buffers", display_name = "  Buffer " },
        { source = "git_status", display_name = " 󰊢 Git " },
        { source = "diagnostics", display_name = "  Diagnostics " },
      },
    },
    -- }}}
  })
end
