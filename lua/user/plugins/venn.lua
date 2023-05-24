return function()
  -- venn.nvim: enable or disable keymappings
  function _G.Toggle_venn()
    local venn_enabled = vim.inspect(vim.b.venn_enabled)
    if venn_enabled == "nil" then
      vim.b.venn_enabled = true
      vim.cmd([[setlocal ve=all]])
      -- draw a line on HJKL keystokes
      vim.api.nvim_buf_set_keymap(0, "n", "J", "<C-v>j:VBox<CR>", { noremap = true })
      vim.api.nvim_buf_set_keymap(0, "n", "K", "<C-v>k:VBox<CR>", { noremap = true })
      vim.api.nvim_buf_set_keymap(0, "n", "L", "<C-v>l:VBox<CR>", { noremap = true })
      vim.api.nvim_buf_set_keymap(0, "n", "H", "<C-v>h:VBox<CR>", { noremap = true })
      vim.api.nvim_buf_set_keymap(0, "n", "<C-j>", "<C-v>j:VBoxH<CR>", { noremap = true })
      vim.api.nvim_buf_set_keymap(0, "n", "<C-k>", "<C-v>k:VBoxH<CR>", { noremap = true })
      vim.api.nvim_buf_set_keymap(0, "n", "<C-l>", "<C-v>l:VBoxH<CR>", { noremap = true })
      vim.api.nvim_buf_set_keymap(0, "n", "<C-h>", "<C-v>h:VBoxH<CR>", { noremap = true })
      -- draw a box by pressing "f" with visual selection
      vim.api.nvim_buf_set_keymap(0, "v", "f", ":VBox<CR>", { noremap = true })
      vim.api.nvim_buf_set_keymap(0, "v", "F", ":VBoxD<CR>", { noremap = true })
      vim.api.nvim_buf_set_keymap(0, "v", "<C-f>", ":VFill<CR>", { noremap = true })
      print("Venn enabled")
    else
      vim.cmd([[setlocal ve=]])
      vim.cmd([[mapclear <buffer>]])
      vim.b.venn_enabled = nil
      print("Venn disabled")
    end
  end
end
