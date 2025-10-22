return function()
  local markview = require("markview");
  local presets = require("markview.presets");

  markview.setup({
    markdown = {
      code_blocks = {
        pad_amount = 0,
      },
      list_items = {
        indent_size = 2,
        shift_width = 2,
      },
    },
    preview = {
      modes = { "n", "i", "no", "c" },
      hybrid_modes = { "i" },
      callbacks = {
        on_enable = function (_, win)
          vim.api.nvim_win_call(win, function ()
            vim.opt_local.conceallevel = 2
            vim.opt_local.concealcursor = "nc"
          end)
        end,
      },
    },
    -- preview = {
    --   headings = {
    --     enable = true,
    --     -- shift_width = 0,
    --   },
    --   modes = { "n", "no", "c" }, -- Change these modes
    --                               -- to what you need
    --
    --   hybrid_modes = { "n" },     -- Uses this feature on
    --                               -- normal mode
    --
    --   -- This is nice to have
    --   callbacks = {
    --       on_enable = function (_, win)
    --           vim.wo[win].conceallevel = 2;
    --           vim.wo[win].concealcursor = "c";
    --       end
    --   }
    -- },
  });

  require("markview.highlights").setup()
  vim.cmd("Markview Enable");
end
