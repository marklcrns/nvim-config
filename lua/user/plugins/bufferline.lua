return function()
  local hi = Config.common.hl.hi

  local symbol_map = {
    error = "",
    warning = "",
    info = "",
    hint = "",
  }

  require("bufferline").setup({
    options = {
      mode = "tabs",
      view = "default",
      numbers = "none",
      buffer_close_icon = "",
      modified_icon = "●",
      close_icon = "",
      left_trunc_marker = "",
      right_trunc_marker = "",
      max_name_length = 18,
      max_prefix_length = 15, -- prefix used when a buffer is deduplicated
      tab_size = 18,
      -- diagnostics = "nvim_lsp",
      -- ---@diagnostic disable-next-line: unused-local
      -- diagnostics_indicator = function(total_count, level, diagnostics_dict)
      --   local s = ""
      --   for kind, count in pairs(diagnostics_dict) do
      --     s = string.format("%s %s %d", s, symbol_map[kind], count)
      --   end
      --   return s
      -- end,
      show_buffer_close_icons = true,
      show_close_icon = false,
      show_tab_indicators = true,
      persist_buffer_sort = true, -- whether or not custom sorted buffers should persist
      -- can also be a table containing 2 custom separators
      -- [focused and unfocused]. eg: { '|', '|' }
      -- separator_style = { "▏", "▕" },
      -- separator_style = { "│", "│" },
      separator_style = "thin",
      -- separator_style = "thin",        --  "slant" | "thick" | "thin" | { 'any', 'any' },
      enforce_regular_tabs = false,
      always_show_bufferline = true,
      -- sort_by = 'extension' | 'relative_directory' | 'directory' | function(buffer_a, buffer_b)
      --   -- add custom logic
      --   return buffer_a.modified > buffer_b.modified
      -- end
      hover = {
        enabled = true,
        delay = 10,
        reveal = {'close'}
      },
      offsets = {
        {
          filetype = "NvimTree",
          text = "Files",
          text_align = "center",
        },
        {
          filetype = "neo-tree",
          text = "Files",
          text_align = "center",
        },
        {
          filetype = "DiffviewFiles",
          text = "Source Control",
          text_align = "center",
        },
      },
      custom_areas = {
        right = function()
          local result = {}
          local session = vim.api.nvim_call_function("fnamemodify", { vim.v.this_session, ":t:r" })

          -- local seve = vim.diagnostic.severity
          -- local error = #vim.diagnostic.get(0, { severity = seve.ERROR })
          -- local warning = #vim.diagnostic.get(0, { severity = seve.WARN })
          -- local info = #vim.diagnostic.get(0, { severity = seve.INFO })
          -- local hint = #vim.diagnostic.get(0, { severity = seve.HINT })
          --
          -- if error ~= 0 then
          --   table.insert(result, { text = "  " .. error, fg = "#EC5241" })
          -- end
          --
          -- if warning ~= 0 then
          --   table.insert(result, { text = "  " .. warning, fg = "#EFB839" })
          -- end
          --
          -- if hint ~= 0 then
          --   table.insert(result, { text = "  " .. hint, fg = "#A3BA5E" })
          -- end
          --
          -- if info ~= 0 then
          --   table.insert(result, { text = "  " .. info, fg = "#7EA9A7" })
          -- end

          if session ~= "" then
            table.insert(result, { text = "  " .. session, fg = "#7EA9A7" })
          end

          return result
        end,
      },
    },
  })

  hi("BufferLineDiagnostic", { style = "bold" })
  hi("BufferLineDiagnosticVisible", { style = "bold" })
end
