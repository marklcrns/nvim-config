return function()
  -- Setup nvim-cmp.
  local cmp = require("cmp")
  local cmp_autopairs = require("nvim-autopairs.completion.cmp")
  local handlers = require("nvim-autopairs.completion.handlers")
  local luasnip = require("luasnip")
  local api = vim.api
  local utils = Config.common.utils

  local lsp_kinds = {
    Method = "  ",
    Function = " ƒ ",
    Variable = "  ",
    Field = "  ",
    TypeParameter = "  ",
    Constant = "  ",
    Class = "  ",
    Interface = " 蘒",
    Struct = "  ",
    Event = "  ",
    Operator = "  ",
    Module = "  ",
    Property = "  ",
    Enum = "  ",
    Reference = "  ",
    Keyword = "  ",
    File = "  ",
    Folder = " ﱮ ",
    Color = "  ",
    Unit = " 塞 ",
    Snippet = "  ",
    Text = "  ",
    Constructor = "  ",
    Value = "  ",
    EnumMember = "  ",
    Copilot = "  ",
  }

  local has_words_before = function()
    if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then
      return false
    end
    unpack = unpack or table.unpack
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_text(0, line - 1, 0, line - 1, col, {})[1]:match("^%s*$") == nil
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

  cmp.setup({
    -- enabled = function()
    --   return vim.api.nvim_buf_get_option(0, "buftype") ~= "prompt" or require("cmp_dap").is_dap_buffer()
    -- end,
    snippet = {
      expand = function(args)
        -- vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
        require("luasnip").lsp_expand(args.body) -- For `luasnip` users.
        -- require("snippy").expand_snippet(args.body) -- For `snippy` users.
        -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
      end,
    },
    window = {
      --   completion = cmp.config.window.bordered(),
      --   documentation = cmp.config.window.bordered(),
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
    completion = {
      completeopt = "menu,menuone,noselect",
    },

    -- formatting = {
    --   fields = { "kind", "abbr", "menu" },
    --   format = function(entry, item)
    --     local kind = {
    --       spell = "[Spell]",
    --       buffer = "[Buffer]",
    --       calc = "[Calc]",
    --       emoji = "[Emoji]",
    --       nvim_lsp = "[LSP]",
    --       path = "[Path]",
    --       look = "[Look]",
    --       treesitter = "[treesitter]",
    --       ultisnips = "[UltiSnip]",
    --       nvim_lua = "[Lua]",
    --       latex_symbols = "[Latex]",
    --       cmp_tabnine = "[Tab9]",
    --       git = "[Git]",
    --       conventionalcommits = "[CC]",
    --       copilot = "[Copilot]",
    --       cmdline = "[Cmdline]",
    --     }
    --
    --     if entry.source.name == "cmp_tabnine" then
    --       item.kind_hl_group = "CmpItemKindTabnine"
    --     end
    --
    --     if entry.source.name == "copilot" then
    --       item.kind_hl_group = "CmpItemKindCopilot"
    --     end
    --
    --     if entry.source.name == "emoji" then
    --       item.kind_hl_group = "CmpItemKindEmoji"
    --     end
    --
    --     -- set a name for each source
    --     -- item.menu = lsp_symbols[item.kind]
    --     -- item.kind = item.kind .. " " .. kind[entry.source.name]
    --     item.menu = item.kind .. " " .. kind[entry.source.name]
    --     item.kind = lsp_kinds[item.kind]
    --     return item
    --   end,
    -- },

    formatting = {
      deprecated = true,
      fields = { "kind", "abbr", "menu" },
      format = function(entry, vim_item)
        vim_item.kind = lsp_kinds[vim_item.kind]
        vim_item.menu = ({
          nvim_lsp = "[LSP]",
          emoji = "[Emoji]",
          path = "[Path]",
          calc = "[Calc]",
          neorg = "[Neorg]",
          orgmode = "[Org]",
          luasnip = "[Luasnip]",
          buffer = "[Buffer]",
          spell = "[Spell]",
          git = "[VCS]",
          copilot = "[Copilot]",
          cmp_tabnine = "[Tab9]",
          latex_symbols = "[Latex]",
          treesitter = "[Treesitter]",
          conventionalcommits = "[CC]",
          cmdline = "[Cmdline]",
        })[entry.source.name]
        return vim_item
      end,
    },
    sorting = {
      priority_weight = 2,
      comparators = {
        require("copilot_cmp.comparators").prioritize,
        require("copilot_cmp.comparators").score,

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
      -- { name = "cmp_tabnine", group_index = 1 },
      { name = "nvim_lsp", group_index = 1 },
      { name = "nvim_lua", group_index = 1 },
      { name = "luasnip", group_index = 2 },
      { name = "path", group_index = 2 },
      { name = "spell", group_index = 2 },
      { name = "emoji", group_index = 3, options = { insert = true } },
      {
        name = "buffer",
        group_index = 2,
        max_item_count = 20,
        option = {
          get_bufnrs = get_bufnrs,
        },
      },
    }),

    mapping = {
      -- -- https://github.com/hrsh7th/nvim-cmp/wiki/Example-mappings#ultisnips--cmp-cmdline
      -- ["<Tab>"] = cmp.mapping({
      --   i = function(fallback)
      --     if has_words_before() then
      --       cmp_ultisnips_mappings.compose({ "expand", "jump_forwards" })(fallback)
      --     else
      --       fallback()
      --     end
      --   end,
      --   s = function(fallback)
      --     cmp_ultisnips_mappings.compose({ "expand", "jump_forwards" })(fallback)
      --   end,
      --   x = function()
      --     vim.api.nvim_feedkeys(t("<Plug>(ultisnips_expand)"), "m", true)
      --   end,
      -- }),
      ["<Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        -- You could replace the expand_or_jumpable() calls with expand_or_locally_jumpable()
        -- they way you will only jump inside the snippet region
        elseif luasnip.expand_or_jumpable() then
          luasnip.expand_or_jump()
        elseif has_words_before() then
          cmp.complete()
        else
          fallback()
        end
      end, { "i", "s" }),
      -- ["<S-Tab>"] = cmp.mapping({
      --   i = function(fallback)
      --     cmp_ultisnips_mappings.jump_backwards(fallback)
      --   end,
      --   s = function(fallback)
      --     cmp_ultisnips_mappings.jump_backwards(fallback)
      --   end,
      -- }),
      ["<S-Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        elseif luasnip.jumpable(-1) then
          luasnip.jump(-1)
        else
          fallback()
        end
      end, { "i", "s" }),
      -- ["<C-j>"] = cmp.mapping(function(fallback)
      --   cmp_ultisnips_mappings.compose({ "jump_forwards", "select_next_item" })(fallback)
      -- end, { "i", "s" }),
      -- ["<C-k>"] = cmp.mapping(function(fallback)
      --   cmp_ultisnips_mappings.compose({ "jump_backwards", "select_prev_item" })(fallback)
      -- end, { "i", "s" }),
      ["<Down>"] = cmp.mapping(cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }), { "i" }),
      ["<Up>"] = cmp.mapping(cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }), { "i" }),
      ["<C-n>"] = cmp.mapping({
        -- c = function()
        --   if cmp.visible() then
        --     cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
        --   else
        --     vim.api.nvim_feedkeys(t("<Down>"), "n", true)
        --   end
        -- end,
        i = function(fallback)
          if cmp.visible() then
            cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
          else
            fallback()
          end
        end,
      }),
      ["<C-p>"] = cmp.mapping({
        -- c = function()
        --   if cmp.visible() then
        --     cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
        --   else
        --     vim.api.nvim_feedkeys(t("<Up>"), "n", true)
        --   end
        -- end,
        i = function(fallback)
          if cmp.visible() then
            cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
          else
            fallback()
          end
        end,
      }),
      ["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
      ["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
      ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
      ["<C-e>"] = cmp.mapping({ i = cmp.mapping.abort(), c = cmp.mapping.close() }),
      ["<C-c>"] = cmp.mapping({ i = cmp.mapping.abort(), c = cmp.mapping.close() }),
      ["<CR>"] = cmp.mapping({
        -- c = function(fallback)
        --   if cmp.visible() then
        --     cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })
        --   else
        --     fallback()
        --   end
        -- end,
        i = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false }),
      }),
    },
  })

  -- autopairs config
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
          get_bufnrs = get_bufnrs,
        },
      },
    }),
  })

  cmp.setup.filetype({ "markdown", "vimwiki", "norg", "help", "text" }, {
    sources = cmp.config.sources({
      { name = "copilot", group_index = 1 },
      -- { name = "cmp_tabnine", group_index = 1 },
      { name = "nvim_lsp", group_index = 1 },
      -- { name = 'spell', group_index = 1  },
      { name = "path", group_index = 2 },
      { name = "neorg", group_index = 2 },
      { name = "emoji", group_index = 3, options = { insert = true } },
      {
        name = "buffer",
        group_index = 2,
        max_item_count = 20,
        option = {
          get_bufnrs = get_bufnrs,
        },
      },
    }),
  })

  -- Use buffer source for `/`.
  cmp.setup.cmdline("/", {
    completion = { autocomplete = false },
    sources = {
      {
        name = "buffer",
        max_item_count = 20,
        option = {
          get_bufnrs = get_bufnrs,
        },
      },
    },
  })

  -- Use cmdline & path source for ':'.
  cmp.setup.cmdline(":", {
    completion = { autocomplete = true },
    sources = cmp.config.sources({
      { name = "cmdline", group_index = 1 },
      { name = "path", group_index = 1, priority = 999 },
    }),
  })
end