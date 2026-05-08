local M = {}
local merge_tb = vim.tbl_deep_extend
local fn = vim.fn

-- ─── Mapping loader (original) ───────────────────────────────────────────────

M.load_mappings = function(section, mapping_opt)
  local function set_section_map(section_values)
    if section_values.plugin then
      return
    end

    section_values.plugin = nil

    for mode, mode_values in pairs(section_values) do
      local default_opts = merge_tb("force", { mode = mode }, mapping_opt or {})
      for keybind, mapping_info in pairs(mode_values) do
        local opts = merge_tb("force", default_opts, mapping_info.opts or {})

        mapping_info.opts, opts.mode = nil, nil
        opts.desc = mapping_info[2]

        vim.keymap.set(mode, keybind, mapping_info[1], opts)
      end
    end
  end

  local mappings = require("user.core.mappings")

  if type(section) == "string" then
    mappings[section]["plugin"] = nil
    mappings = { mappings[section] }
  end

  for _, sect in pairs(mappings) do
    set_section_map(sect)
  end
end

M.lazy_load = function(plugin)
  vim.api.nvim_create_autocmd({ "BufRead", "BufWinEnter", "BufNewFile" }, {
    group = vim.api.nvim_create_augroup("BeLazyOnFileOpen" .. plugin, {}),
    callback = function()
      local file = fn.expand("%")
      local condition = file ~= "NvimTree_1" and file ~= "[lazy]" and file ~= ""

      if condition then
        vim.api.nvim_del_augroup_by_name("BeLazyOnFileOpen" .. plugin)

        if plugin ~= "nvim-treesitter" then
          vim.schedule(function()
            require("lazy").load({ plugins = plugin })

            if plugin == "nvim-lspconfig" then
              vim.cmd("silent! do FileType")
            end
          end, 0)
        else
          require("lazy").load({ plugins = plugin })
        end
      end
    end,
  })
end

-- ─── Cache helpers (ported from core/utils.vim) ──────────────────────────────

---Write a value to a cache file in stdpath('data')/cache/
---@param filename string
---@param data any
function M.cache_to_data_dir(filename, data)
  local dir = fn.stdpath("data") .. "/cache"
  if fn.isdirectory(dir) == 0 then
    fn.mkdir(dir, "p")
  end
  local str = type(data) == "boolean" and (data and "true" or "false") or tostring(data)
  fn.writefile({ str }, dir .. "/" .. filename)
end

---Read a cached value from stdpath('data')/cache/
---@param filename string
---@param default any
---@return any
function M.read_cache_from_data_dir(filename, default)
  local path = fn.stdpath("data") .. "/cache/" .. filename
  if fn.filereadable(path) == 0 then
    return default
  end
  local lines = fn.readfile(path)
  if #lines == 0 then
    return default
  end
  local val = lines[1]
  if val == "true" then return true end
  if val == "false" then return false end
  return val
end

-- Expose as globals so vimrc can call them
_G.CacheToDataDir = M.cache_to_data_dir
_G.ReadCacheFromDataDir = M.read_cache_from_data_dir

return M
