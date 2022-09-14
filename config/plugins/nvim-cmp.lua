-- Setup nvim-cmp.
local cmp = require 'cmp'
local cmp_ultisnips_mappings = require("cmp_nvim_ultisnips.mappings")
local cmp_autopairs = require('nvim-autopairs.completion.cmp')

local lsp_symbols = {
  Text = "  ",
  Method = "  ",
  Function = "  ",
  Constructor = "  ",
  Field = " ﴲ ",
  Variable = "  ",
  Class = "  ",
  Interface = " ﰮ ",
  Module = "  ",
  Property = " 襁 ",
  Unit = "  ",
  Value = "  ",
  Enum = " 練 ",
  Keyword = "  ",
  Snippet = "  ",
  Color = "  ",
  File = "  ",
  Reference = "  ",
  Folder = "  ",
  EnumMember = "  ",
  Constant = " ﲀ ",
  Struct = " ﳤ ",
  Event = "  ",
  Operator = "  ",
  TypeParameter = "  ",
  Copilot = "  ",
}

local press = function(key)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), "n", true)
end

local has_words_before = function()
  if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then return false end
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_text(0, line - 1, 0, line - 1, col, {})[1]:match("^%s*$") == nil
end

local t = function(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

cmp.setup({
  snippet = {
    expand = function(args)
      vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
    end,
  },
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },

  -- mapping = cmp.mapping.preset.insert({
  --   ["<C-p>"] = cmp.mapping.select_prev_item(),
  --   ["<C-n>"] = cmp.mapping.select_next_item(),
  --   ['<C-b>'] = cmp.mapping.scroll_docs(-4),
  --   ['<C-f>'] = cmp.mapping.scroll_docs(4),
  --   ['<C-u>'] = cmp.mapping(cmp.mapping.select_prev_item(), { 'i', 'c' }),
  --   ['<C-d>'] = cmp.mapping(cmp.mapping.select_next_item(), { 'i', 'c' }),
  --   ['<C-Space>'] = cmp.mapping.complete(),
  --   ['<C-e>'] = cmp.mapping.abort(),
  --   ["<C-c>"] = cmp.mapping.close(),
  --   ['<CR>'] = cmp.mapping.confirm({ select = false }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
  --   ["<Tab>"] = cmp.mapping(function(fallback)
  --     if cmp.visible() and has_words_before() then
  --       cmp.confirm({ select = true })
  --     elseif vim.fn["UltiSnips#CanExpandSnippet"]() == 1 then
  --       press("<C-R>=UltiSnips#ExpandSnippet()<CR>")
  --     else
  --       fallback()
  --     end
  --   end),
  -- }),

  -- https://github.com/hrsh7th/nvim-cmp/wiki/Example-mappings#ultisnips--cmp-cmdline
  mapping = {
    ["<Tab>"] = cmp.mapping({
      c = function()
        if cmp.visible() then
          cmp.select_next_item({ behavior = cmp.SelectBehavior.Insert })
        else
          cmp.complete()
        end
      end,
      i = function(fallback)
        if cmp.visible() and has_words_before() then
          cmp.select_next_item({ behavior = cmp.SelectBehavior.Insert })
        elseif vim.fn["UltiSnips#CanJumpForwards"]() == 1 then
          vim.api.nvim_feedkeys(t("<Plug>(ultisnips_jump_forward)"), 'm', true)
        else
          fallback()
        end
      end,
      s = function(fallback)
        if vim.fn["UltiSnips#CanJumpForwards"]() == 1 then
          vim.api.nvim_feedkeys(t("<Plug>(ultisnips_jump_forward)"), 'm', true)
        else
          fallback()
        end
      end
    }),
    ["<S-Tab>"] = cmp.mapping({
      c = function()
        if cmp.visible() then
          cmp.select_prev_item({ behavior = cmp.SelectBehavior.Insert })
        else
          cmp.complete()
        end
      end,
      i = function(fallback)
        if cmp.visible() and has_words_before() then
          cmp.select_prev_item({ behavior = cmp.SelectBehavior.Insert })
        elseif vim.fn["UltiSnips#CanJumpBackwards"]() == 1 then
          return vim.api.nvim_feedkeys(t("<Plug>(ultisnips_jump_backward)"), 'm', true)
        else
          fallback()
        end
      end,
      s = function(fallback)
        if vim.fn["UltiSnips#CanJumpBackwards"]() == 1 then
          return vim.api.nvim_feedkeys(t("<Plug>(ultisnips_jump_backward)"), 'm', true)
        else
          fallback()
        end
      end
    }),
    ['<Down>'] = cmp.mapping(cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }), { 'i' }),
    ['<Up>'] = cmp.mapping(cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }), { 'i' }),
    ['<C-n>'] = cmp.mapping({
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
    ['<C-p>'] = cmp.mapping({
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
    ['<C-u>'] = cmp.mapping(cmp.mapping.select_prev_item(), { 'i', 'c' }),
    ['<C-d>'] = cmp.mapping(cmp.mapping.select_next_item(), { 'i', 'c' }),
    ['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
    ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
    ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
    ['<C-e>'] = cmp.mapping({ i = cmp.mapping.close(), c = cmp.mapping.close() }),
    ['<CR>'] = cmp.mapping({
      -- i = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false }),
      i = function(fallback)
        if has_words_before() then
          if cmp.visible() then
            cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })
          elseif vim.fn["UltiSnips#CanExpandSnippet"]() == 1 then
            -- Only for regex conditional ultisnips that aren't visible
            -- Must close completion first with '<C-e>' to expand
            return vim.api.nvim_feedkeys(t("<Plug>(ultisnips_expand)"), 'm', true)
          end
        end
        fallback()
      end,
      c = function(fallback)
        if cmp.visible() then
          cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })
        else
          fallback()
        end
      end
    }),
  },

  completion = {
    completeopt = 'menu,menuone,noselect,noinsert'
  },

  sources = cmp.config.sources({
    { name = 'copilot', group_index = 1, priority = 999 },
    { name = 'nvim_lsp', group_index = 1 },
    { name = 'nvim_lua', group_index = 1 },
    { name = 'ultisnips', group_index = 1, max_item_count = 10 },
    -- { name = 'cmp_tabnine', group_index = 1 },
    { name = 'git', group_index = 2 },
    { name = 'conventionalcommits', group_index = 2 },
    { name = 'buffer', group_index = 2 },
    { name = 'path', group_index = 2 },
    { name = 'cmdline', group_index = 2 },
    { name = 'neorg', group_index = 2 },
    { name = 'treesitter', group_index = 3 },
    { name = 'emoji', group_index = 3, options = { insert = true } },
    { name = 'spell', group_index = 3 },
  }),

  formatting = {
    format = function(entry, item)
      item.kind = lsp_symbols[item.kind] .. " " .. item.kind
      -- set a name for each source
      item.menu =
      ({
        spell = "[Spell]",
        buffer = "[Buffer]",
        calc = "[Calc]",
        emoji = "[Emoji]",
        nvim_lsp = "[LSP]",
        path = "[Path]",
        look = "[Look]",
        treesitter = "[treesitter]",
        ultisnips = "[UltiSnip]",
        nvim_lua = "[Lua]",
        latex_symbols = "[Latex]",
        cmp_tabnine = "[Tab9]",
        git = "[Git]",
        conventionalcommits = "[Git]",
        copilot = "[Copilot]",
        cmdline = "[Cmdline]",
      })[entry.source.name]
      return item
    end
  },

  sorting = {
    priority_weight = 2,
    comparators = {
      require("copilot_cmp.comparators").prioritize,
      require("copilot_cmp.comparators").score,
    },
  },
})

-- autopairs config
cmp.event:on(
  'confirm_done',
  cmp_autopairs.on_confirm_done()
)

-- Set configuration for specific filetype.
cmp.setup.filetype({'gitcommit', 'gina-commit', 'NeogitCommitMessage'}, {
  sources = cmp.config.sources({
    { name = 'copilot' },
  }, {
    { name = 'git' },
  }, {
    { name = 'conventionalcommits' },
  }, {
    { name = 'spell' },
  }, {
    { name = 'buffer' },
  })
})

cmp.setup.filetype({ 'markdown', 'vimwiki', 'help', 'text' }, {
  sources = cmp.config.sources({
    { name = 'emoji', options = { insert = true } },
  }, {
    { name = 'nvim_lsp' },
  }, {
    { name = 'spell' },
  }, {
    { name = 'buffer' },
  }, {
    { name = 'path' },
  }, {
    { name = 'ultisnips' },
  })
})

-- Use buffer source for `/`.
cmp.setup.cmdline('/', {
  completion = { autocomplete = false },
  sources = {
    -- { name = 'buffer' }
    { name = 'buffer', opts = { keyword_pattern = [=[[^[:blank:]].*]=] } }
  }
})

-- Use cmdline & path source for ':'.
cmp.setup.cmdline(':', {
  completion = { autocomplete = false },
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    { name = 'cmdline' }
  })
})
