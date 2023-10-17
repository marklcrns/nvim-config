return function()
  -- Credits: https://github.com/ecosse3/nvim/blob/master/lua/plugins/dap.lua

  local present_dapui, dapui = pcall(require, "dapui")
  local present_dap, dap = pcall(require, "dap")
  -- local _, shade = pcall(require, "shade")

  if not present_dapui or not present_dap then
    return
  end

  -- ╭──────────────────────────────────────────────────────────╮
  -- │ DAP Setup                                                │
  -- ╰──────────────────────────────────────────────────────────╯
  dap.set_log_level("TRACE")

  -- Automatically open UI
  dap.listeners.after.event_initialized["dapui_config"] = function()
    dapui.open()
    -- shade.toggle()
  end
  dap.listeners.before.event_terminated["dapui_config"] = function()
    dapui.close()
    -- shade.toggle()
  end
  -- dap.listeners.before.event_exited["dapui_config"] = function()
  --   dapui.close()
  --   -- shade.toggle()
  -- end

  -- ╭──────────────────────────────────────────────────────────╮
  -- │ Icons                                                    │
  -- ╰──────────────────────────────────────────────────────────╯

  vim.fn.sign_define("DapBreakpoint", { text = "🟥", texthl = "", linehl = "", numhl = "" })
  vim.fn.sign_define("DapStopped", { text = "⭐️", texthl = "", linehl = "", numhl = "" })

  -- ╭──────────────────────────────────────────────────────────╮
  -- │ Adapters                                                 │
  -- ╰──────────────────────────────────────────────────────────╯
  -- NODE / TYPESCRIPT
  dap.adapters.node2 = {
    type = "executable",
    command = "node",
    args = { vim.fn.stdpath("data") .. "/mason/packages/node-debug2-adapter/out/src/nodeDebug.js" },
  }

  -- Chrome
  dap.adapters.chrome = {
    type = "executable",
    command = "node",
    args = { vim.fn.stdpath("data") .. "/mason/packages/chrome-debug-adapter/out/src/chromeDebug.js" },
  }

  -- C/C++/Rust
  dap.adapters.cppdbg = {
    id = "cppdbg",
    type = "executable",
    command = vim.fn.stdpath("data") .. "/mason/packages/cpptools/extension/debugAdapters/bin/OpenDebugAD7",
  }

  -- ╭──────────────────────────────────────────────────────────╮
  -- │ Configurations                                           │
  -- ╰──────────────────────────────────────────────────────────╯
  dap.configurations.javascript = {
    {
      type = "node2",
      request = "launch",
      program = "${file}",
      cwd = vim.fn.getcwd(),
      sourceMaps = true,
      protocol = "inspector",
      console = "integratedTerminal",
    },
  }

  dap.configurations.javascript = {
    {
      type = "chrome",
      request = "attach",
      program = "${file}",
      cwd = vim.fn.getcwd(),
      sourceMaps = true,
      protocol = "inspector",
      port = 9222,
      webRoot = "${workspaceFolder}",
    },
  }

  dap.configurations.javascriptreact = {
    {
      type = "chrome",
      request = "attach",
      program = "${file}",
      cwd = vim.fn.getcwd(),
      sourceMaps = true,
      protocol = "inspector",
      port = 9222,
      webRoot = "${workspaceFolder}",
    },
  }

  dap.configurations.typescriptreact = {
    {
      type = "chrome",
      request = "attach",
      program = "${file}",
      cwd = vim.fn.getcwd(),
      sourceMaps = true,
      protocol = "inspector",
      port = 9222,
      webRoot = "${workspaceFolder}",
    },
  }

  dap.configurations.c = {
    {
      name = "Launch file",
      type = "cppdbg",
      request = "launch",
      program = function()
        return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
      end,
      cwd = "${workspaceFolder}",
      stopAtEntry = true,
      args = { "$arg1", "$arg2", "$arg3" },
      runInTerminal = true,
    },
    {
      name = "Attach to gdbserver :1234",
      type = "cppdbg",
      request = "launch",
      MIMode = "gdb",
      miDebuggerServerAddress = "localhost:1234",
      miDebuggerPath = "/usr/bin/gdb",
      cwd = "${workspaceFolder}",
      program = function()
        return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
      end,
    },
  }

  dap.configurations.cpp = {
    {
      name = "Launch file",
      type = "cppdbg",
      request = "launch",
      program = function()
        return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
      end,
      cwd = "${workspaceFolder}",
      stopAtEntry = true,
      args = { "$arg1", "$arg2", "$arg3" },
      runInTerminal = true,
    },
    {
      name = "Attach to gdbserver :1234",
      type = "cppdbg",
      request = "launch",
      MIMode = "gdb",
      miDebuggerServerAddress = "localhost:1234",
      miDebuggerPath = "/usr/bin/gdb",
      cwd = "${workspaceFolder}",
      program = function()
        return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
      end,
    },
  }
end
