return function()
  -- Setup nvim-cmp.
  local cmp = require("cmp")
  local api = vim.api
  local utils = Config.common.utils

  -- Snippet support
  local cmp_ultisnips_mappings
  local luasnip
  if vim.g.snippet_engine == "ultisnips" then
    cmp_ultisnips_mappings = require("cmp_nvim_ultisnips.mappings")
  elseif vim.g.snippet_engine == "luasnip" then
    luasnip = require("luasnip")
  end

  -- Autopairs support
  local cmp_autopairs
  local handlers
  if not vim.g.low_performance_mode then
    cmp_autopairs = require("nvim-autopairs.completion.cmp")
    handlers = require("nvim-autopairs.completion.handlers")
  end

  local lsp_kinds = {
    Method = "  ",
    Function = " ƒ ",
    Variable = "  ",
    Field = "  ",
    TypeParameter = "  ",
    Constant = "  ",
    Class = "  ",
    Interface = "  ",
    Struct = "  ",
    Event = "  ",
    Operator = " 󰆕 ",
    Module = " 󰅩 ",
    Property = "  ",
    Enum = "  ",
    Reference = "  ",
    Keyword = "  ",
    File = "  ",
    Folder = " 󰝰 ",
    Color = "  ",
    Unit = " 󰑭 ",
    Snippet = "  ",
    Text = "  ",
    Constructor = "  ",
    Value = " 󰎠 ",
    EnumMember = "  "
  }

  local has_words_before = function()
    unpack = unpack or table.unpack
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
  end

  local t = function(str)
    return vim.api.nvim_replace_termcodes(str, true, true, true)
  end

  local get_bufnrs = function()
    return vim.tbl_filter(function(bufnr)
      local bytesize = api.nvim_buf_get_offset(bufnr, api.nvim_buf_line_count(bufnr))
      return bytesize < 1024 * 1024
    end, utils.vec_union(utils.list_bufs({ listed = true }), utils.list_bufs({ no_hidden = true })))
  end

  -- Prevent event listeners from stacking whenever packer reloads the config.
  cmp.event:clear()

  local mapping = {
    ["<Down>"] = cmp.mapping(cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }), { "i" }),
    ["<Up>"] = cmp.mapping(cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }), { "i" }),
    ["<C-n>"] = cmp.mapping({
      c = function()
          if cmp.visible() then
              cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
          else
              vim.api.nvim_feedkeys(t('<Down>'), 'n', true)
          end
      end,
      i = function(fallback)
          if cmp.visible() then
              cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
          else
              fallback()
          end
      end
    }),
    ["<C-p>"] = cmp.mapping({
      c = function()
          if cmp.visible() then
              cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
          else
              vim.api.nvim_feedkeys(t('<Up>'), 'n', true)
          end
      end,
      i = function(fallback)
          if cmp.visible() then
              cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
          else
              fallback()
          end
      end
    }),
    ["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
    ["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
    ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
    ["<C-e>"] = cmp.mapping({ i = cmp.mapping.abort(), c = cmp.mapping.close() }),
    ["<C-c>"] = cmp.mapping({ i = cmp.mapping.abort(), c = cmp.mapping.close() }),
    -- ["<CR>"] = cmp.mapping({
    --   i = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false }),
    --   s = cmp.mapping.confirm({ select = true }),
    -- }),
    ["<CR>"] = cmp.mapping({
      i = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false }),
      c = function(fallback)
          if cmp.visible() then
              cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })
          else
              fallback()
          end
      end
    }),
  }

  -- INFO: If using luasnip snippet engine
  -- https://github.com/hrsh7th/nvim-cmp/wiki/Example-mappings#luasnip
  if vim.g.snippet_engine == "luasnip" then
    mapping["<Tab>"] = cmp.mapping({
      c = function()
        if cmp.visible() then
          cmp.select_next_item({ behavior = cmp.SelectBehavior.Insert })
        else
          cmp.complete()
        end
      end,
      i = function(fallback)
        if luasnip.expand_or_jumpable() then
          luasnip.expand_or_jump()
        elseif has_words_before() then
          cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })
        else
          fallback()
        end
      end,
      s = function(fallback)
        if luasnip.expand_or_jumpable() then
          luasnip.expand_or_jump()
        elseif has_words_before() then
          cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })
        else
          fallback()
        end
      end,
    })
    mapping["<S-Tab>"] = cmp.mapping({
      c = function()
        if cmp.visible() then
          cmp.select_prev_item({ behavior = cmp.SelectBehavior.Insert })
        end
      end,
      i = function(fallback)
        if luasnip.jumpable(-1) then
          luasnip.jump(-1)
        else
          fallback()
        end
      end,
      s = function(fallback)
        if luasnip.jumpable(-1) then
          luasnip.jump(-1)
        else
          fallback()
        end
      end,
    })
    mapping["<C-j>"] = cmp.mapping(function(fallback)
      if luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      elseif cmp.visible() then
        cmp.select_next_item()
      else
        fallback()
      end
    end, { "i", "s" })
    mapping["<C-k>"] = cmp.mapping(function(fallback)
      if luasnip.jumpable(-1) then
        luasnip.jump(-1)
      elseif cmp.visible() then
        cmp.select_prev_item()
      else
        fallback()
      end
    end, { "i", "s" })

  -- INFO: If using UltiSnips snippet engine
  -- https://github.com/hrsh7th/nvim-cmp/wiki/Example-mappings#ultisnips--cmp-cmdline
  elseif vim.g.snippet_engine == "ultisnips" then
    -- INFO: Super <TAB> keybindings
    mapping["<Tab>"] = cmp.mapping({
      c = function()
          if cmp.visible() then
              cmp.select_next_item({ behavior = cmp.SelectBehavior.Insert })
          else
              cmp.complete()
          end
      end,
      i = function(fallback)
        if has_words_before() then
          cmp_ultisnips_mappings.compose({ "expand", "jump_forwards" })(fallback)
          else
            print("fallback")
            fallback()
          end
      end,
      s = function(fallback)
        cmp_ultisnips_mappings.compose({ "expand", "jump_forwards" })(fallback)
      end,
      x = function()
        vim.api.nvim_feedkeys(t("<Plug>(ultisnips_expand)"), "m", true)
      end,
    })
    mapping["<S-Tab>"] = cmp.mapping({
      c = function()
          if cmp.visible() then
              cmp.select_prev_item({ behavior = cmp.SelectBehavior.Insert })
          end
      end,
      i = function(fallback)
        cmp_ultisnips_mappings.jump_backwards(fallback)
      end,
      s = function(fallback)
        cmp_ultisnips_mappings.jump_backwards(fallback)
      end,
    })

    -- INFO: nvim-cmp recommends
    -- mapping["<Tab>"] = cmp.mapping({
    --   c = function()
    --       if cmp.visible() then
    --           cmp.select_next_item({ behavior = cmp.SelectBehavior.Insert })
    --       else
    --           cmp.complete()
    --       end
    --   end,
    --   i = function(fallback)
    --       if cmp.visible() then
    --           cmp.select_next_item({ behavior = cmp.SelectBehavior.Insert })
    --       elseif vim.fn["UltiSnips#CanJumpForwards"]() == 1 then
    --           vim.api.nvim_feedkeys(t("<Plug>(ultisnips_jump_forward)"), 'm', true)
    --       else
    --           fallback()
    --       end
    --   end,
    --   s = function(fallback)
    --       if vim.fn["UltiSnips#CanJumpForwards"]() == 1 then
    --           vim.api.nvim_feedkeys(t("<Plug>(ultisnips_jump_forward)"), 'm', true)
    --       else
    --           fallback()
    --       end
    --   end
    -- })
    -- mapping["<S-Tab>"] = cmp.mapping({
    --   c = function()
    --       if cmp.visible() then
    --           cmp.select_prev_item({ behavior = cmp.SelectBehavior.Insert })
    --       else
    --           cmp.complete()
    --       end
    --   end,
    --   i = function(fallback)
    --       if cmp.visible() then
    --           cmp.select_prev_item({ behavior = cmp.SelectBehavior.Insert })
    --       elseif vim.fn["UltiSnips#CanJumpBackwards"]() == 1 then
    --           return vim.api.nvim_feedkeys( t("<Plug>(ultisnips_jump_backward)"), 'm', true)
    --       else
    --           fallback()
    --       end
    --   end,
    --   s = function(fallback)
    --       if vim.fn["UltiSnips#CanJumpBackwards"]() == 1 then
    --           return vim.api.nvim_feedkeys( t("<Plug>(ultisnips_jump_backward)"), 'm', true)
    --       else
    --           fallback()
    --       end
    --   end
    -- })
    mapping["<C-j>"] = cmp.mapping(function(fallback)
      cmp_ultisnips_mappings.compose({ "jump_forwards", "select_next_item" })(fallback)
    end, { "i", "s" })
    mapping["<C-k>"] = cmp.mapping(function(fallback)
      cmp_ultisnips_mappings.compose({ "jump_backwards", "select_prev_item" })(fallback)
    end, { "i", "s" })
  end

  cmp.setup({
    -- enabled = function()
    --   return vim.api.nvim_buf_get_option(0, "buftype") ~= "prompt" or require("cmp_dap").is_dap_buffer()
    -- end,
    snippet = {
      expand = function(args)
        if vim.g.snippet_engine == "ultisnips" then
          vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
        elseif vim.g.snippet_engine == "luasnip" then
          require("luasnip").lsp_expand(args.body) -- For `luasnip` users.
        end
      end,
    },
    window = {
      -- completion = cmp.config.window.bordered(),
      -- documentation = cmp.config.window.bordered(),
      -- documentation = false,
      documentation = {
        border = "rounded",
        winhighlight = "NormalFloat:Pmenu,NormalFloat:Pmenu,CursorLine:PmenuSel,Search:None",
      },
      completion = {
        border = "rounded",
        winhighlight = "NormalFloat:Pmenu,NormalFloat:Pmenu,CursorLine:PmenuSel,Search:None",
      },
    },
    experimental = {
      ghost_text = true,
    },
    -- NOTE: Enable this when Super <TAB> keybindings are used
    -- completion = {
    --   completeopt = "menu,menuone",
    -- },

    formatting = {
      deprecated = true,
      fields = { "kind", "abbr", "menu" },
      format = function(entry, vim_item)
        vim_item.kind = lsp_kinds[vim_item.kind]
        vim_item.menu = ({
          buffer = "[Buffer]",
          calc = "[Calc]",
          cmdline = "[Cmdline]",
          cmp_tabnine = "[Tab9]",
          codeium = "[Codeium]",
          conventionalcommits = "[VCS]",
          copilot = "[Copilot]",
          emoji = "[Emoji]",
          git = "[VCS]",
          greek = "[Greek]",
          latex_symbols = "[Latex]",
          luasnip = "[Luasnip]",
          neorg = "[Neorg]",
          nerdfont = "[Nerdfont]",
          nvim_lsp = "[LSP]",
          orgmode = "[Org]",
          path = "[Path]",
          spell = "[Spell]",
          treesitter = "[Treesitter]",
          ultisnips = "[UltiSnip]",
        })[entry.source.name]
        return vim_item
      end,
    },
    sorting = {
      priority_weight = 2,
      comparators = {
        -- require("copilot_cmp.comparators").prioritize,
        -- require("copilot_cmp.comparators").score,

        -- Below is the default comparitor list and order for nvim-cmp
        cmp.config.compare.offset,
        -- cmp.config.compare.scopes, --this is commented in nvim-cmp too
        cmp.config.compare.exact,
        cmp.config.compare.score,
        cmp.config.compare.recently_used,
        cmp.config.compare.locality,
        cmp.config.compare.kind,
        cmp.config.compare.sort_text,
        cmp.config.compare.length,
        cmp.config.compare.order,
      },
    },
    sources = cmp.config.sources({
      { name = "copilot", group_index = 1 },
      { name = "codeium", group_index = 1 },
      -- { name = "cmp_tabnine", group_index = 1 },
      { name = "nvim_lsp", group_index = 1 },
      { name = "nvim_lua", group_index = 1 },
      { name = "ultisnips", group_index = 1, max_item_count = 10 },
      { name = "luasnip", option = { show_autosnippets = true }, group_index = 1 },
      { name = "path", group_index = 2 },
      { name = "spell", group_index = 2 },
      {
        name = "buffer",
        max_item_count = 20,
        option = {
          get_bufnrs = function()
            return vim.tbl_filter(
              function(bufnr) return utils.buf_get_size(bufnr) < 1024 end,
              utils.vec_union(
                utils.list_bufs({ no_unlisted = true }),
                utils.list_bufs({ no_hidden = true })
              )
            )
          end,
        },
      },
      { name = "nerdfont", group_index = 3 },
    }),

    mapping = mapping,
  })

  -- autopairs config
  if not vim.g.low_performance_mode then
    cmp.event:on(
      "confirm_done",
      cmp_autopairs.on_confirm_done({
        filetypes = {
          -- "*" is a alias to all filetypes
          ["*"] = {
            ["("] = {
              kind = {
                cmp.lsp.CompletionItemKind.Function,
                cmp.lsp.CompletionItemKind.Method,
              },
              handler = handlers["*"],
            },
          },
          -- Disable for tex
          -- tex = false
        },
      })
    )
  end

  -- Dap completion
  cmp.setup.filetype({ "dap-repl", "dapui_watches", "dapui_hover" }, {
    sources = {
      { name = "dap" },
    },
  })

  -- Set configuration for specific filetype.
  cmp.setup.filetype({ "gitcommit", "gina-commit", "NeogitCommitMessage" }, {
    sources = cmp.config.sources({
      { name = "cmp_tabnine" },
      { name = "git" },
      { name = "conventionalcommits" },
      { name = "spell" },
      {
        name = "buffer",
        max_item_count = 20,
        option = {
          get_bufnrs = function()
            return vim.tbl_filter(
              function(bufnr) return utils.buf_get_size(bufnr) < 1024 end,
              utils.vec_union(
                utils.list_bufs({ no_unlisted = true }),
                utils.list_bufs({ no_hidden = true })
              )
            )
          end,
        },
      },
      { name = "nerdfont", group_index = 3 },
    }),
  })

  cmp.setup.filetype({ "norg" }, {
    sources = cmp.config.sources({
      { name = "copilot", group_index = 1 },
      { name = "codeium", group_index = 1 },
      -- { name = "cmp_tabnine", group_index = 1 },
      { name = "nvim_lsp", group_index = 1 },
      -- { name = 'spell', group_index = 1  },
      { name = "ultisnips", group_index = 1, max_item_count = 10 },
      { name = "luasnip", option = { show_autosnippets = true }, group_index = 1 },
      { name = "path", group_index = 2 },
      {
        name = "buffer",
        max_item_count = 20,
        option = {
          get_bufnrs = function()
            return vim.tbl_filter(
              function(bufnr) return utils.buf_get_size(bufnr) < 1024 end,
              utils.vec_union(
                utils.list_bufs({ no_unlisted = true }),
                utils.list_bufs({ no_hidden = true })
              )
            )
          end,
        },
      },
      { name = "neorg", group_index = 2 },
      { name = "greek", group_index = 3 },
      { name = "nerdfont", group_index = 3 },
      { name = "latex_symbols", group_index = 3, option = { strategy = 0 } },
    }),
  })

  cmp.setup.filetype({ "markdown", "vimwiki", "help", "text" }, {
    sources = cmp.config.sources({
      { name = "copilot", group_index = 1 },
      { name = "codeium", group_index = 1 },
      -- { name = "cmp_tabnine", group_index = 1 },
      { name = "nvim_lsp", group_index = 1 },
      -- { name = 'spell', group_index = 1  },
      { name = "ultisnips", group_index = 1, max_item_count = 10 },
      { name = "luasnip", option = { show_autosnippets = true }, group_index = 1 },
      { name = "path", group_index = 2 },
      {
        name = "buffer",
        max_item_count = 20,
        option = {
          get_bufnrs = function()
            return vim.tbl_filter(
              function(bufnr) return utils.buf_get_size(bufnr) < 1024 end,
              utils.vec_union(
                utils.list_bufs({ no_unlisted = true }),
                utils.list_bufs({ no_hidden = true })
              )
            )
          end,
        },
      },
      { name = "greek", group_index = 3 },
      { name = "nerdfont", group_index = 3 },
      { name = "emoji", group_index = 3, option = { insert = true } },
      { name = "latex_symbols", group_index = 3, option = { strategy = 0 } },
    }),
  })

  -- `/` cmdline setup.
  cmp.setup.cmdline("/", {
    completion = { autocomplete = false },
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
      { name = 'buffer', option = { keyword_pattern = [=[[^[:blank:]].*]=] } }
    }
  })

  -- `:` cmdline setup.
  cmp.setup.cmdline(":", {
    completion = { autocomplete = false },
    sources = cmp.config.sources({
      { name = 'path' }
      }, {
      { name = 'cmdline' }
    })
  })
end
