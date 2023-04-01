local lazy = require("user.lazy")

local M = {}

local mapper = lazy.require("nvim-mapper")
local wk = lazy.require("which-key")

local default_opts = {
  noremap = true,
  silent = false,
  nowait = false,
}

M.map = function(mode, keys, cmd, options, category, unique_identifier, description)
  local opts = {
    noremap = options.noremap == nil and default_opts.noremap or options.noremap,
    silent = options.silent == nil and default_opts.silent or options.silent,
    nowait = options.nowait == nil and default_opts.nowait or options.nowait,
  }

  mapper.map(mode, keys, cmd, opts, category, unique_identifier, description)
  wk.register({
    [keys] = {
      cmd,
      description,
    },
  }, {
    mode = "n",
    noremap = opts.noremap,
    silent = opts.silent,
    nowait = opts.nowait,
  })
end

M.map_buf = function(bufnr, mode, keys, cmd, options, category, unique_identifier, description)
  local opts = {
    noremap = options.noremap == nil and default_opts.noremap or options.noremap,
    silent = options.silent == nil and default_opts.silent or options.silent,
    nowait = options.nowait == nil and default_opts.nowait or options.nowait,
  }

  mapper.map_buf(bufnr, mode, keys, cmd, opts, category, unique_identifier, description)
  wk.register({
    [keys] = {
      cmd,
      description,
    },
  }, {
    mode = "n",
    buffer = bufnr,
    noremap = opts.noremap,
    silent = opts.silent,
    nowait = opts.nowait,
  })
end

M.map_virtual = function(mode, keys, cmd, options, category, unique_identifier, description)
  local opts = {
    noremap = options.noremap == nil and default_opts.noremap or options.noremap,
    silent = options.silent == nil and default_opts.silent or options.silent,
    nowait = options.nowait == nil and default_opts.nowait or options.nowait,
  }

  mapper.map_virtual(mode, keys, cmd, options, category, unique_identifier, description)
  wk.register({
    [keys] = {
      cmd,
      description,
    },
  }, {
    mode = "v",
    noremap = opts.noremap,
    silent = opts.silent,
    nowait = opts.nowait,
  })
end

M.map_buf_virtual = function(bufnr, mode, keys, cmd, options, category, unique_identifier, description)
  local opts = {
    noremap = options.noremap == nil and default_opts.noremap or options.noremap,
    silent = options.silent == nil and default_opts.silent or options.silent,
    nowait = options.nowait == nil and default_opts.nowait or options.nowait,
  }

  mapper.map_buf_virtual(bufnr, mode, keys, cmd, options, category, unique_identifier, description)
  wk.register({
    [keys] = {
      cmd,
      description,
    },
  }, {
    mode = "v",
    buffer = bufnr,
    noremap = opts.noremap,
    silent = opts.silent,
    nowait = opts.nowait,
  })
end

return M
