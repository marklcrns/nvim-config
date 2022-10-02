local status, npairs = pcall(require, "nvim-autopairs")
if (not status) then return end

local Rule = require'nvim-autopairs.rule'
local cond = require'nvim-autopairs.conds'
local ts_conds = require('nvim-autopairs.ts-conds')

npairs.setup({
  fast_wrap = {},
  disable_filetype = { "TelescopePrompt" },
  check_ts = true,
  ts_config = {
      lua = {'string'},-- it will not add a pair on that treesitter node
      javascript = {'template_string'},
      java = false,-- don't check treesitter on java
  },
})

-- https://github.com/windwp/nvim-autopairs/wiki/Custom-rules
npairs.add_rules {
  -- Add spaces between parentheses
  Rule(' ', ' ')
    :with_pair(function(opts)
      local pair = opts.line:sub(opts.col -1, opts.col)
      return vim.tbl_contains({ '()', '{}', '[]' }, pair)
    end)
    :with_move(cond.none())
    :with_cr(cond.none())
    :with_del(function(opts)
      local col = vim.api.nvim_win_get_cursor(0)[2]
      local context = opts.line:sub(col - 1, col + 2)
      return vim.tbl_contains({ '(  )', '{  }', '[  ]' }, context)
    end),
  Rule('', ' )')
    :with_pair(cond.none())
    :with_move(function(opts) return opts.char == ')' end)
    :with_cr(cond.none())
    :with_del(cond.none())
    :use_key(')'),
  Rule('', ' }')
    :with_pair(cond.none())
    :with_move(function(opts) return opts.char == '}' end)
    :with_cr(cond.none())
    :with_del(cond.none())
    :use_key('}'),
  Rule('', ' ]')
    :with_pair(cond.none())
    :with_move(function(opts) return opts.char == ']' end)
    :with_cr(cond.none())
    :with_del(cond.none())
    :use_key(']'),

  -- Auto add space on `=`
  -- Rule('=', '')
  --   :with_pair(cond.not_inside_quote())
  --   :with_pair(function(opts)
  --       local last_char = opts.line:sub(opts.col - 1, opts.col - 1)
  --       if last_char:match('[%w%=%s]') then
  --           return true
  --       end
  --       return false
  --   end)
  --   :replace_endpair(function(opts)
  --       local prev_2char = opts.line:sub(opts.col - 2, opts.col - 1)
  --       local next_char = opts.line:sub(opts.col, opts.col)
  --       next_char = next_char == ' ' and '' or ' '
  --       if prev_2char:match('%w$') then
  --           return '<bs> =' .. next_char
  --       end
  --       if prev_2char:match('%=$') then
  --           return next_char
  --       end
  --       if prev_2char:match('=') then
  --           return '<bs><bs>=' .. next_char
  --       end
  --       return ''
  --   end)
  --   :set_end_pair_length(0)
  --   :with_move(cond.none())
  --   :with_del(cond.none()),

  -- press % => %% only while inside a comment or string (lua)
  Rule("%", "%", "lua")
    :with_pair(ts_conds.is_ts_node({'string','comment'})),

  -- Bracket-like $$ behavior
  Rule("$", "$" , {"tex", "latex", "plaintex", "vimwiki"})
    -- move right when repeat character
    :with_move(function(opts) return opts.char == '$' end),
  -- Add $$ in new line after $$<CR>
  Rule("$$", "", {"tex", "latex", "plaintex", "vimwiki"})
    :use_regex(true)
    :with_pair(function(opts)
        print(vim.inspect(opts))
        if opts.line=="aa $$" then
        -- don't add pair on that line
          return false
        end
    end)
    :replace_endpair(function(opts)
      return '$$'
    end)
    :end_wise(),

  -- Insert '{  }' on arrow key '>' after '() = or ()=' (javascript)
  Rule('%(.*%)%s*%=>$', ' {  }', { 'typescript', 'typescriptreact', 'javascript' })
      :use_regex(true)
      :set_end_pair_length(2),
}
