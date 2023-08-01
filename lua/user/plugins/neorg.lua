return function()
  require("neorg").setup({
    -- Tell Neorg what modules to load
    load = {
      ["core.defaults"] = {}, -- Load all the default modules
      ["core.concealer"] = {}, -- Allows for use of icons
      ["core.manoeuvre"] = {},
      ["core.journal"] = {},
      ["core.ui.calendar"] = {},
      ["core.completion"] = {
        config = {
          engine = "nvim-cmp",
        },
      },
      ["core.keybinds"] = { -- Configure core.keybinds
        config = {
          default_keybinds = true, -- Generate the default keybinds
          neorg_leader = "<LocalLeader>nn", -- This is the default if unspecified
          hook = function(keybinds)
            -- Keybinds to make moving sections up and down easily
            keybinds.map("norg", "n", "gj", "<cmd>Neorg keybind norg core.manoeuvre.item_down<cr>")
            keybinds.map("norg", "n", "gk", "<cmd>Neorg keybind norg core.manoeuvre.item_up<cr>")
            keybinds.map("norg", "n", "]s", "<cmd>Neorg keybind norg core.integrations.treesitter.next.heading<cr>")
            keybinds.map("norg", "n", "[s", "<cmd>Neorg keybind norg core.integrations.treesitter.previous.heading<cr>")
            -- FIXME: Broken
            keybinds.map(
              "norg",
              "n",
              "<LocalLeader>nnc",
              '<cmd>:lua neorg.modules.get_module("core.ui.calendar").select_date({})<cr>'
            )
          end,
        },
      },
      ["core.dirman"] = { -- Manage your directories with Neorg
        config = {
          workspaces = {
            main = "~/Sync/notes/neorg/main",
            work = "~/Sync/notes/neorg/work",
          },
          default_workspace = "main",
        },
      },
      ["core.qol.toc"] = {
        config = {
          toc_split_placement = "right",
        },
      },
      ["core.esupports.metagen"] = {
        config = {
          type = "auto",
          update_date = true,
          template = {
            {
              "title",
              function()
                return vim.fn.expand("%:t:r")
              end,
            },
            { "description", "" },
            { "author", "Mark Lucernas" },
            { "categories", "" },
            {
              "created",
              function()
                return os.date("%Y-%m-%d")
              end,
            },
            {
              "updated",
              function()
                return os.date("%Y-%m-%d")
              end,
            },
            { "version", require("neorg.config").norg_version }, -- error here, why?
          },
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
