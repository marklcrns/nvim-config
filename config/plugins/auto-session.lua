if
  (vim.api.nvim_eval('exists("g:neovide")')) == 1
  or (vim.api.nvim_eval('exists("g:Gui")')) == 1
  or (vim.api.nvim_eval('exists("g:GuiLoaded")')) == 1
  or (vim.api.nvim_eval('has("gui_running")')) == 1
  or (vim.api.nvim_eval('has("gui")')) == 1
then
  vim.g.auto_session_enabled = false
  return
end

require("auto-session").setup({
  auto_session_enabled = true,
  log_level = "error",
  auto_session_enable_last_session = false,
  auto_session_root_dir = vim.fn.stdpath("data") .. "/sessions/",
  auto_save_enabled = nil,
  auto_restore_enabled = nil,
  auto_session_suppress_dirs = { "~/", "~/Projects", "~/Downloads", "/" },
  auto_session_use_git_branch = nil,
  -- the configs below are lua only
  bypass_session_save_file_types = nil,
})

vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"
