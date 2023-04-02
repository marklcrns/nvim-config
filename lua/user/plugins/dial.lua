return function()
  local augend = require("dial.augend")
  require("dial.config").augends:register_group({
    -- default augends used when no group name is specified
    default = {
      augend.integer.alias.decimal, -- nonnegative decimal number (0, 1, 2, 3, ...)
      augend.integer.alias.hex, -- nonnegative hex number  (0x01, 0x1a1f, etc.)
      augend.date.alias["%Y/%m/%d"], -- date (2022/02/19, etc.)
      augend.constant.new({
        elements = { "and", "or" },
        word = true, -- if false, "sand" is incremented into "sor", "doctor" into "doctand", etc.
        cyclic = true, -- "or" is incremented into "and".
      }),
      augend.constant.new({
        elements = { "&&", "||" },
        word = false,
        cyclic = true,
      }),
      augend.constant.new({
        elements = { "true", "false" },
        word = true,
        cyclic = true,
      }),
      augend.hexcolor.new({
        case = "lower",
      }),
      -- uppercase hex number (0x1A1A, 0xEEFE, etc.)
      augend.user.new({
        find = require("dial.augend.common").find_pattern("%d+"),
        add = function(text, addend, cursor)
          local n = tonumber(text)
          n = math.floor(n * (2 ^ addend))
          text = tostring(n)
          cursor = #text
          return { text = text, cursor = cursor }
        end,
      }),
      -- augend.paren.new({
      --   patterns = { { "'", "'" }, { '"', '"' } },
      --   nested = false,
      --   escape_char = [[\]],
      --   cyclic = true,
      -- }),
      -- augend.paren.new({
      --   patterns = {
      --     { '"', '"' },
      --     { "[[", "]]" },
      --     { "[=[", "]=]" },
      --     { "[==[", "]==]" },
      --     { "[===[", "]===]" },
      --   },
      --   nested = false,
      --   cyclic = false,
      -- }),
    },
  })
end
