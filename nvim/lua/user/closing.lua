require("which-key").add({
  { "<leader>q", group = "Close stuff down" },
})

-- some personal bindings
vim.keymap.set('n', '<leader>qq', ':bd<CR>', { desc = 'Close Buffer' })
