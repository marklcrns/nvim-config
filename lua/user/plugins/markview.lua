return function()
  local markview = require("markview");
  local presets = require("markview.presets");

  markview.setup({
    headings = {
      enable = true,
      shift_width = 0,
    },
    modes = { "n", "no", "c" }, -- Change these modes
                                -- to what you need

    hybrid_modes = { "n" },     -- Uses this feature on
                                -- normal mode

    -- This is nice to have
    callbacks = {
        on_enable = function (_, win)
            vim.wo[win].conceallevel = 2;
            vim.wo[win].concealcursor = "c";
        end
    }
  });

  vim.cmd("Markview enableAll");
end
