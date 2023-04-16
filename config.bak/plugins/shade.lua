if
  (vim.api.nvim_eval('exists("g:neovide")')) == 1
  or (vim.api.nvim_eval('exists("g:Gui")')) == 1
  or (vim.api.nvim_eval('exists("g:GuiLoaded")')) == 1
  or (vim.api.nvim_eval('has("gui_running")')) == 1
  or (vim.api.nvim_eval('has("gui")')) == 1
then
  return
end

require("shade").setup({
  overlay_opacity = 25,
  opacity_step = 1,
  keys = {
    brightness_up = "<C-Up>",
    brightness_down = "<C-Down>",
    toggle = "<LocalLeader>sd",
  },
})
