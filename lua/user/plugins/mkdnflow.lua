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
          cmp = false
      },
      filetypes = {md = true, rmd = true, markdown = true, vimwiki = false},
      create_dirs = true,
      perspective = {
          priority = 'first',
          fallback = 'current',
          root_tell = false,
          nvim_wd_heel = false,
          update = false
      },
      wrap = false,
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
          name_is_source = false,
          conceal = false,
          context = 0,
          implicit_extension = nil,
          transform_implicit = false,
          transform_explicit = function(text)
              text = text:gsub(" ", "-")
              text = text:lower()
              text = os.date('%Y-%m-%d_')..text
              return(text)
          end,
          create_on_follow_failure = true
      },
      new_file_template = {
          use_template = false,
          placeholders = {
              before = {
                  title = "link_title",
                  date = "os_date"
              },
              after = {}
          },
          template = "# {{ title }}"
      },
      to_do = {
          symbols = {' ', '-', 'X'},
          update_parents = true,
          not_started = ' ',
          in_progress = '-',
          complete = 'X'
      },
      foldtext = {
          title_transformer = function()
              local function my_title_transformer(text)
                  local updated_title = text:gsub('%b{}', '')
                  updated_title = updated_title:gsub('^%s*', '')
                  updated_title = updated_title:gsub('%s*$', '')
                  updated_title = updated_title:gsub('^######', '░░░░░▓')
                  updated_title = updated_title:gsub('^#####', '░░░░▓▓')
                  updated_title = updated_title:gsub('^####', '░░░▓▓▓')
                  updated_title = updated_title:gsub('^###', '░░▓▓▓▓')
                  updated_title = updated_title:gsub('^##', '░▓▓▓▓▓')
                  updated_title = updated_title:gsub('^#', '▓▓▓▓▓▓')
                  return updated_title
              end
              return my_title_transformer
          end,
          object_count_icon_set = 'nerdfont', -- Use/fall back on the nerdfont icon set
          object_count_opts = function()
              local opts = {
                  link = false, -- Prevent links from being counted
                  blockquote = { -- Count block quotes (these aren't counted by default)
                      icon = ' ',
                      count_method = {
                          pattern = { '^>.+$' },
                          tally = 'blocks',
                      }
                  },
                  fncblk = {
                      -- Override the icon for fenced code blocks with 
                      icon = ' '
                  }
              }
              return opts
          end,
          line_count = false, -- Prevent lines from being counted
          word_count = true, -- Count the words in the section
          fill_chars = {
              left_edge = '╾─🖿 ─',
              right_edge = '──╼',
              item_separator = ' · ',
              section_separator = ' // ',
              left_inside = ' ┝',
              right_inside = '┥ ',
              middle = '─',
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
              mimic_alignment = true
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
          -- MkdnCreateLink = false, -- see MkdnEnter
          -- MkdnCreateLinkFromClipboard = {{'n', 'v'}, '<leader>p'}, -- see MkdnEnter
          -- MkdnFollowLink = false, -- see MkdnEnter
          -- MkdnDestroyLink = {'n', '<M-CR>'},
          MkdnDestroyLink = false,
          -- MkdnTagSpan = {'v', '<M-CR>'},
          MkdnTagSpan = false,
          -- MkdnMoveSource = {'n', '<F2>'},
          -- MkdnYankAnchorLink = {'n', 'yaa'},
          -- MkdnYankFileAnchorLink = {'n', 'yfa'},
          -- MkdnIncreaseHeading = {'n', '+'},
          -- MkdnDecreaseHeading = {'n', '-'},
          MkdnToggleToDo = {{'n', 'v'}, '<C-Space>'},
          MkdnNewListItem = false,
          MkdnNewListItemBelowInsert = {'n', 'o'},
          MkdnNewListItemAboveInsert = {'n', 'O'},
          -- MkdnExtendList = false,
          -- MkdnUpdateNumbering = {'n', '<leader>nn'},
          MkdnTableNextCell = {'i', '<Tab>'},
          MkdnTablePrevCell = {'i', '<S-Tab>'},
          MkdnTableNextRow = false,
          -- MkdnTablePrevRow = {'i', '<M-CR>'},
          -- MkdnTableNewRowBelow = {'n', '<leader>ir'},
          -- MkdnTableNewRowAbove = {'n', '<leader>iR'},
          -- MkdnTableNewColAfter = {'n', '<leader>ic'},
          -- MkdnTableNewColBefore = {'n', '<leader>iC'},
          MkdnFoldSection = {'n', '<leader>z'},
          MkdnUnfoldSection = {'n', '<leader>Z'}
      }
  })
end
