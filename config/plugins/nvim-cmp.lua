-- Setup nvim-cmp.
local cmp = require 'cmp'
local cmp_autopairs = require('nvim-autopairs.completion.cmp')
local handlers = require('nvim-autopairs.completion.handlers')
local cmp_ultisnips_mappings = require("cmp_nvim_ultisnips.mappings")

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

  -- https://github.com/hrsh7th/nvim-cmp/wiki/Example-mappings#ultisnips--cmp-cmdline
  mapping = {
    ["<Tab>"] = cmp.mapping({
      c = function()
        if cmp.visible() then
          cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })
          -- cmp.select_next_item({ behavior = cmp.SelectBehavior.Insert })
        else
          cmp.complete()
        end
      end,
      i = function(fallback)
        if has_words_before() then
          cmp_ultisnips_mappings.compose { "expand", "jump_forwards" }(fallback)
        else
          fallback()
        end
      end,
      s = function(fallback)
        cmp_ultisnips_mappings.compose { "expand", "jump_forwards" }(fallback)
      end,
      x = function()
        vim.api.nvim_feedkeys(t("<Plug>(ultisnips_expand)"), 'm', true)
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
        cmp_ultisnips_mappings.jump_backwards(fallback)
      end,
      s = function(fallback)
        cmp_ultisnips_mappings.jump_backwards(fallback)
      end
    }),
    ["<C-j>"] = cmp.mapping(
      function(fallback)
        cmp_ultisnips_mappings.compose { "jump_forwards", "select_next_item" }(fallback)
      end,
      { "i", "s" }
    ),
    ["<C-k>"] = cmp.mapping(
      function(fallback)
        cmp_ultisnips_mappings.compose { "jump_backwards", "select_prev_item" }(fallback)
      end,
      { "i", "s" }
    ),
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
    ['<C-e>'] = cmp.mapping({ i = cmp.mapping.abort(), c = cmp.mapping.close() }),
    ['<C-c>'] = cmp.mapping({ i = cmp.mapping.abort(), c = cmp.mapping.close() }),
    ['<CR>'] = cmp.mapping({
      c = function(fallback)
        if cmp.visible() then
          cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })
        else
          fallback()
        end
      end,
      i = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false }),
    }),
  },

  experimental = {
    ghost_text = true,
  },

  completion = {
    completeopt = 'menu,menuone,noselect'
  },

  sources = cmp.config.sources({
    -- {
    --   name = "copilot",
    --   -- keyword_length = 0,
    --   max_item_count = 3,
    --   trigger_characters = {
    --     {
    --       ".",
    --       ":",
    --       "(",
    --       "'",
    --       '"',
    --       "[",
    --       ",",
    --       "#",
    --       "*",
    --       "@",
    --       "|",
    --       "=",
    --       "-",
    --       "{",
    --       "/",
    --       "\\",
    --       "+",
    --       "?",
    --       " ",
    --       -- "\t",
    --       -- "\n",
    --     },
    --   },
    --   group_index = 1,
    -- },
    { name = 'cmp_tabnine', group_index = 1 },
    { name = 'nvim_lsp', group_index = 1 },
    { name = 'nvim_lua', group_index = 1 },
    { name = 'ultisnips', group_index = 1, max_item_count = 10 },
    { name = 'treesitter', group_index = 1 },
    { name = 'buffer', group_index = 2 },
    { name = 'path', group_index = 2 },
    { name = 'spell', group_index = 2 },
    { name = 'emoji', group_index = 3, options = { insert = true } },
  }),

  formatting = {
    format = function(entry, item)
      item.kind = lsp_symbols[item.kind] .. " " .. item.kind

      if entry.source.name == "cmp_tabnine" then
        item.kind_hl_group = "CmpItemKindTabnine"
      end
      if entry.source.name == "copilot" then
        item.kind_hl_group = "CmpItemKindCopilot"
      end

      if entry.source.name == "emoji" then
        item.kind_hl_group = "CmpItemKindEmoji"
      end

      -- set a name for each source
      item.menu = (
        {
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
          conventionalcommits = "[CC]",
          copilot = "[Copilot]",
          cmdline = "[Cmdline]",
        }
      )[entry.source.name]
      return item
    end
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
})

-- autopairs config
cmp.event:on(
  'confirm_done',
  cmp_autopairs.on_confirm_done({
    filetypes = {
      -- "*" is a alias to all filetypes
      ["*"] = {
        ["("] = {
          kind = {
            cmp.lsp.CompletionItemKind.Function,
            cmp.lsp.CompletionItemKind.Method,
          },
          handler = handlers["*"]
        }
      },
      -- Disable for tex
      -- tex = false
    }
  })
)

-- Set configuration for specific filetype.
cmp.setup.filetype({ 'gitcommit', 'gina-commit', 'NeogitCommitMessage' }, {
  sources = cmp.config.sources({
    -- { name = 'copilot', group_index = 1  },
    { name = 'git', group_index = 1  },
    { name = 'conventionalcommits', group_index = 1  },
    { name = 'spell', group_index = 1  },
    { name = 'buffer', group_index = 1  },
  })
})

cmp.setup.filetype({ 'markdown', 'vimwiki', 'norg', 'help', 'text' }, {
  sources = cmp.config.sources({
    -- { name = 'copilot', group_index = 1 },
    { name = 'cmp_tabnine', group_index = 1 },
    { name = 'nvim_lsp', group_index = 1  },
    { name = 'spell', group_index = 1  },
    { name = 'buffer', group_index = 1  },
    { name = 'path', group_index = 1  },
    { name = 'ultisnips', group_index = 1  },
    { name = 'neorg', group_index = 1,},
    { name = 'emoji', group_index = 2 , options = { insert = true } },
  })
})

-- Use buffer source for `/`.
cmp.setup.cmdline('/', {
  completion = { autocomplete = false },
  sources = {
    { name = 'buffer', opts = { keyword_pattern = [=[[^[:blank:]].*]=] } },
  }
})

-- Use cmdline & path source for ':'.
cmp.setup.cmdline(':', {
  completion = { autocomplete = true },
  sources = cmp.config.sources({
    { name = 'cmdline', group_index = 1  },
    { name = 'path', group_index = 1 , priority = 999 },
  })
})

