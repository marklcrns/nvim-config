return function()
  require("neorg").setup({
    -- Tell Neorg what modules to load
    load = {
      ["core.defaults"] = {}, -- Load all the default modules
      ["core.concealer"] = {}, -- Allows for use of icons
      ["core.keybinds"] = { -- Configure core.keybinds
        config = {
          default_keybinds = true, -- Generate the default keybinds
          neorg_leader = "<LocalLeader>nn", -- This is the default if unspecified
          hook = function(keybinds)
            keybinds.remap("toc-split", "n", "q", "<cmd>q<CR>") -- Temporary fix for toc mappings dripping down to norg mappings when closed
            keybinds.remap("toc-split", "n", "<ESC>", "<cmd>q<CR>") -- Temporary fix for toc mappings dripping down to norg mappings when closed
          end,
        },
      },
      ["core.dirman"] = { -- Manage your directories with Neorg
        config = {
          workspaces = {
            main = "~/Sync/notes",
          },
          default_workspace = "main",
        },
      },
      ["core.qol.toc"] = {
        config = {
          toc_split_placement = "right",
        },
      },
      ["core.norg.esupports.metagen"] = {
        config = {
          type = "auto",
          update_date = true,
        },
      },
      ["core.integrations.telescope"] = {}, -- Enable the telescope module
      ["core.integrations.nvim-cmp"] = {},
    },
  })

  -- Telescope integration keybinds
  local neorg_callbacks = require("neorg.callbacks")

  neorg_callbacks.on_event("core.keybinds.events.enable_keybinds", function(_, keybinds)
    -- Map all the below keybinds only when the "norg" mode is active
    keybinds.map_event_to_mode("norg", {
      n = { -- Bind keys in normal mode
        { "<C-s>", "core.integrations.telescope.find_linkable" },
      },
      i = { -- Bind in insert mode
        { "<C-l>", "core.integrations.telescope.insert_link" },
      },
    }, {
      silent = true,
      noremap = true,
    })
  end)
end
