--vim.api.nvim_create_user_command('Oil', function()
--  vim.cmd('terminal oil')
--end, {})




vim.keymap.set('n', '<leader>oo', function()
    vim.cmd('Oil')
end, { desc = "oil" })
