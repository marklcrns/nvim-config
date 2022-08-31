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
  TypeParameter = "  "
}

local press = function(key)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), "n", true)
end

local has_any_words_before = function()
  if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then
    return false
  end
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

cmp.setup({
  snippet = {
    -- REQUIRED - you must specify a snippet engine
    expand = function(args)
      -- vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
      -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
      -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
      vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
    end,
  },
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
  mapping = cmp.mapping.preset.insert({
    ["<C-p>"] = cmp.mapping.select_prev_item(),
    ["<C-n>"] = cmp.mapping.select_next_item(),
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-u>'] = cmp.mapping(cmp.mapping.select_prev_item(), { 'i', 'c' }),
    ['<C-d>'] = cmp.mapping(cmp.mapping.select_next_item(), { 'i', 'c' }),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ["<C-c>"] = cmp.mapping.close(),
    ['<CR>'] = cmp.mapping.confirm({ select = false }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    -- ["<Tab>"] = cmp.mapping(function(fallback)
    --   if vim.fn["UltiSnips#CanJumpForwards"]() == 1 then
    --     press("<ESC>:call UltiSnips#JumpForwards()<CR>")
    --   elseif cmp.visible() then
    --     cmp.select_next_item()
    --   elseif has_any_words_before() then
    --     press("<Tab>")
    --   else
    --     fallback()
    --   end
    -- end, {
    --   "i",
    --   "s",
    -- }),
    -- ["<S-Tab>"] = cmp.mapping(function(fallback)
    --   if vim.fn["UltiSnips#CanJumpBackwards"]() == 1 then
    --     press("<ESC>:call UltiSnips#JumpBackwards()<CR>")
    --   elseif cmp.visible() then
    --     cmp.select_prev_item()
    --   else
    --     fallback()
    --   end
    -- end, {
    --   "i",
    --   "s",
    -- }),
    ["<Tab>"] = cmp.mapping(function(fallback)
      if vim.fn["UltiSnips#CanExpandSnippet"]() == 1 then
        return press("<C-R>=UltiSnips#ExpandSnippet()<CR>")
      elseif cmp.visible() then
        cmp.confirm({ select = true })
      elseif has_any_words_before() then
        press("<Tab>")
      else
        fallback()
      end
    end, { "i", "s", }),
  }),

  completion = {
    completeopt = 'menu,menuone,noselect,noinsert'
    -- completeopt = 'menu,menuone,noinsert'
  },

  sources = cmp.config.sources({
    { name = 'nvim_lua' },
    { name = 'nvim_lsp' },
    -- { name = 'vsnip' }, -- For vsnip users.
    -- { name = 'luasnip' }, -- For luasnip users.
    { name = 'ultisnips' }, -- For ultisnips users.
    -- { name = 'snippy' }, -- For snippy users.
    { name = 'cmp_tabnine' },
    { name = 'buffer' },
    { name = 'path' },
    { name = 'treesitter' },
    { name = 'neorg' },
    { name = 'emoji', options = { insert = true } },
    { name = 'spell' },
    { name = 'git' },
    { name = 'conventionalcommits' },
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
        -- luasnip = "[LuaSnip]",
        ultisnips = "[UltiSnip]",
        nvim_lua = "[Lua]",
        latex_symbols = "[Latex]",
        cmp_tabnine = "[Tab9]",
        git = "[Git]",
        conventionalcommits = "[Git]",
        cmdline = "[Cmdline]",
      })[entry.source.name]
      return item
    end
  },
})

-- autopairs config
cmp.event:on(
  'confirm_done',
  cmp_autopairs.on_confirm_done()
)

-- Set configuration for specific filetype.
cmp.setup.filetype('gitcommit', {
  sources = cmp.config.sources({
    { name = 'git' }, -- cmp_git
  }, {
    { name = 'conventionalcommits' },
  }, {
    { name = 'spell' },
  }, {
    { name = 'emoji', options = { insert = true } },
  }, {
    { name = 'buffer' },
  })
})

cmp.setup.filetype('NeogitCommitMessage', {
  sources = cmp.config.sources({
    { name = 'git' }, -- cmp_git
  }, {
    { name = 'conventionalcommits' },
  }, {
    { name = 'spell' },
  }, {
    { name = 'emoji', options = { insert = true } },
  }, {
    { name = 'buffer' },
  })
})

-- Completion sources according to specific file-types.
cmp.setup.filetype({ 'markdown', 'help', 'text' }, {
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

-- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline('/', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' }
  }
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    { name = 'cmdline' }
  })
})
