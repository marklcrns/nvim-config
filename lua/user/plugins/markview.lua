return function()
  local markview = require("markview");
  local presets = require("markview.presets");

  markview.setup({
    headings = presets.headings.glow_labels,
    on_enable = {
      conceallevel = 2,
      concealcursor = ""
    },
    on_disable = {
      conceallevel = 0,
      concealcursor= ""
    }
  });

  vim.cmd("Markview enableAll");
end
