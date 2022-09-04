require('neorg').setup {
  -- Tell Neorg what modules to load
  load = {
    ["core.defaults"] = {}, -- Load all the default modules
    ["core.keybinds"] = { -- Configure core.keybinds
      config = {
        default_keybinds = true, -- Generate the default keybinds
        neorg_leader = "<LocalLeader>n", -- This is the default if unspecified
        hook = function(keybinds)
            keybinds.remap("toc-split", "n", "q", "<cmd>q<CR>") -- Temporary fix for toc mappings dripping down to norg mappings when closed
            keybinds.remap("toc-split", "n", "<ESC>", "<cmd>q<CR>") -- Temporary fix for toc mappings dripping down to norg mappings when closed
        end,
      }
    },
    ["core.norg.concealer"] = {}, -- Allows for use of icons
    ["core.norg.dirman"] = { -- Manage your directories with Neorg
      config = {
        workspaces = {
          notes = "~/Documents/my-neorg/main",
          gtd = '~/Documents/my-neorg/gtd',
        }
      }
    },
    ['core.gtd.base'] = {
      config = {
        workspace = 'gtd',
      },
    },
    ['core.norg.completion'] = {
      config = {
        engine = 'nvim-cmp',
      },
    },
    ["core.norg.esupports.metagen"] = {
      config = {
        type = "auto",
      }
    },
    ["core.norg.qol.toc"] = {
      config = {
        toc_split_placement = "right",
      }
    },
    ["core.integrations.telescope"] = {}, -- Enable the telescope module
  },
}

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
