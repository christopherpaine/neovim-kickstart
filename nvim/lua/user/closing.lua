require("which-key").add({
  { "<leader>q", group = "Close stuff down" },
})

-- some personal bindings
vim.keymap.set('n', '<leader>qq', ':bd<CR>', { desc = 'Close Buffer' })



function CloseOtherBuffers()
  local current_buf = vim.api.nvim_get_current_buf()
  local buffers = vim.api.nvim_list_bufs()

  for _, buf in ipairs(buffers) do
    if buf ~= current_buf and vim.api.nvim_buf_is_loaded(buf) then
      vim.api.nvim_buf_delete(buf, { force = true })
    end
  end
end

-- You can map this function to a key combination, for example:
vim.api.nvim_set_keymap('n', '<leader>qa', ':lua CloseOtherBuffers()<CR>', { noremap = true, silent = true, desc = 'close all other buffers' })



function QuitNeovim()
  vim.cmd('qa')
end

-- Optionally, map this function to a key combination, for example:
vim.api.nvim_set_keymap('n', '<leader>q4', ':lua QuitNeovim()<CR>', { noremap = true, silent = true })



