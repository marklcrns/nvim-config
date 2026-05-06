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
  });
  -- Don't auto-enable. Loaded lazily via `:Markview` cmd or <leader>cmv keymap.
  -- On first invocation, markview renders the current buffer.
end
