return function ()
  require('mkdnflow').setup({
      modules = {
          bib = false,
          buffers = true,
          conceal = false,
          cursor = true,
          folds = false,
          foldtext = false,
          links = true,
          lists = true,
          maps = true,
          paths = true,
          tables = true,
          yaml = false,
          completion = false
      },
      filetypes = {markdown = true, rmd = true},
      create_dirs = true,
      path_resolution = {
          primary = 'current',
          fallback = 'current',
          root_marker = false,
          sync_cwd = false,
          update_on_navigate = false,
      },
      wrap = true,
      bib = {
          default_path = nil,
          find_in_root = true
      },
      silent = false,
      cursor = {
          jump_patterns = nil
      },
      links = {
          style = 'markdown',
          compact = false,
          conceal = false,
          search_range = 0,
          implicit_extension = nil,
          transform_on_follow = false,
          transform_on_create = function(text)
              text = text:gsub(" ", "-")
              text = text:lower()
              text = os.date('%Y-%m-%d_')..text
              return(text)
          end,
          auto_create = true,
      },
      new_file_template = {
          enabled = false,
          placeholders = {
              title = "link_title",
              date = "os_date",
          },
          template = "# {{ title }}"
      },
      to_do = {
          statuses = {
              not_started = { marker = ' ' },
              in_progress = { marker = '-' },
              complete     = { marker = 'X' },
          },
          status_order = { 'not_started', 'in_progress', 'complete' },
          status_propagation = {
              up = true,
              down = true,
          },
      },
      foldtext = {
          object_count = true,
          object_count_icon_set = 'emoji',
          object_count_opts = function()
              return require('mkdnflow').foldtext.default_count_opts()
          end,
          line_count = true,
          line_percentage = true,
          word_count = false,
          title_transformer = nil,
          fill_chars = {
              left_edge = '⢾',
              right_edge = '⡷',
              left_inside = ' ⣹',
              right_inside = '⣏ ',
              middle = '⣿',
              item_separator = ' · ',
          },
      },
      tables = {
          trim_whitespace = true,
          format_on_move = true,
          auto_extend_rows = false,
          auto_extend_cols = false,
          style = {
              cell_padding = 1,
              separator_padding = 1,
              outer_pipes = true,
              apply_alignment = true,
          }
      },
      yaml = {
          bib = { override = false }
      },
      mappings = {
          MkdnEnter = {{'n', 'v'}, '<CR>'},
          MkdnTab = false,
          MkdnSTab = false,
          MkdnNextLink = {'n', '<Tab>'},
          MkdnPrevLink = {'n', '<S-Tab>'},
          MkdnNextHeading = {'n', ']]'},
          MkdnPrevHeading = {'n', '[['},
          MkdnGoBack = {'n', '<BS>'},
          MkdnGoForward = {'n', '<Del>'},
          MkdnDestroyLink = false,
          MkdnTagSpan = false,
          MkdnToggleToDo = {{'n', 'v'}, '<C-Space>'},
          MkdnNewListItem = false,
          MkdnNewListItemBelowInsert = {'n', 'o'},
          MkdnNewListItemAboveInsert = {'n', 'O'},
          MkdnUpdateNumbering = {'n', '<leader>cmn'},
          MkdnTableNextCell = {'i', '<Tab>'},
          MkdnTablePrevCell = {'i', '<S-Tab>'},
          MkdnTableNextRow = false,
          MkdnFoldSection = {'n', '<leader>z'},
          MkdnUnfoldSection = {'n', '<leader>Z'}
      }
  })
end
