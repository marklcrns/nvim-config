return function()
  require("neorg").setup({
    -- Tell Neorg what modules to load
    load = {
      ["core.defaults"] = {
        config = {
          disable = {
            "core.norg.esupports.indent",
          },
        },
      },
      ["core.concealer"] = {}, -- Allows for use of icons
      ["core.journal"] = {},
      ["core.ui.calendar"] = (vim.fn.has("nvim-0.10") == 1) and {} or nil,
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
            work = "~/Sync/notes/neorg/work",
            main = "~/Sync/notes/neorg/main",
          },
          default_workspace = "work",
        },
      },
      ["core.qol.toc"] = {
        config = {
          toc_split_placement = "right",
        },
      },
      ["core.neorgcmd"] = {
        config = {
          load = { "core.journal" },
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
            { "version", require("neorg.core.config").norg_version }, -- error here, why?
          },
        },
      },
      ["core.integrations.telescope"] = {}, -- Enable the telescope module
      ["core.integrations.treesitter"] = {},
      ["core.integrations.nvim-cmp"] = {},
    },
  })
end
