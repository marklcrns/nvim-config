-- following options are the default
-- each of these are documented in `:help nvim-tree.OPTION_NAME`
require 'nvim-tree'.setup {
  sort_by                            = "name",
  disable_netrw                      = true,
  hijack_netrw                       = true,
  hijack_cursor                      = true,
  open_on_setup                      = false,
  open_on_setup_file                 = false,
  ignore_buffer_on_setup             = false,
  ignore_ft_on_setup                 = {
    "startify",
    "dashboard",
    "alpha",
  },
  auto_reload_on_write               = true,
  hijack_unnamed_buffer_when_opening = false,
  hijack_directories                 = {
    enable = true,
    auto_open = true,
  },
  auto_close                         = false,
  open_on_tab                        = false,
  update_cwd                         = false,
  diagnostics                        = {
    enable = true,
    show_on_dirs = true,
    icons = {
      error = " ",
      warning = " ",
      hint = " ",
      info = " ",
    },
  },
  update_focused_file                = {
    enable = true,
    update_cwd = true,
    ignore_list = {},
  },
  system_open                        = {
    cmd = nil,
    args = {},
  },
  git                                = {
    enable = true,
    ignore = false,
    timeout = 200,
  },
  actions = {
    use_system_clipboard = true,
    change_dir = {
      enable = true,
      global = false,
      restrict_above_cwd = false,
    },
    open_file = {
      quit_on_open = false,
      resize_window = false,
      window_picker = {
        enable = true,
        chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890",
        exclude = {
          filetype = { "notify", "packer", "qf", "diff", "fugitive", "fugitiveblame" },
          buftype = { "nofile", "terminal", "help" },
        },
      },
    },
  },
  filters                            = {
    dotfiles = false,
    custom = { "node_modules", "\\.cache" },
    exclude = {},
  },
  view                               = {
    adaptive_size = true,
    hide_root_folder = false,
    side = 'left',
    auto_resize = false,
    mappings = {
      custom_only = false,
      list = {
        { key = "u", action = "dir_up" },
        { key = "<C-s>", action = "system_open" },
        { key = "s", action = "" }, -- Disable default system_open mappings
      },
    },
    number = false,
    relativenumber = false,
    signcolumn = "yes"
  },
  trash                              = {
    cmd = "trash",
    require_confirm = true
  },
  renderer                           = {
    indent_markers = {
      enable = true,
      inline_arrows = true,
      icons = {
        corner = "└",
        edge = "│",
        item = "│",
        none = " ",
      },
    },
    icons = {
      show = {
        file = true,
        folder = true,
        folder_arrow = true,
        git = true,
      },
      glyphs = {
        default = "",
        symlink = "",
        bookmark = "",
        folder = {
          arrow_closed = "",
          arrow_open = "",
          default = "",
          open = "",
          empty = "",
          empty_open = "",
          symlink = "",
          symlink_open = "",
        },
        git = {
          unstaged = "✗",
          staged = "✓",
          unmerged = "",
          renamed = "➜",
          untracked = "★",
          deleted = "",
          ignored = "◌",
        },
      },
    },
    special_files = { "Makefile", "README.md", "readme.md" },
    symlink_destination = true,
  },
}
