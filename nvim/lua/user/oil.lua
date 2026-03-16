--vim.api.nvim_create_user_command('Oil', function()
--  vim.cmd('terminal oil')
--end, {})




function oil_open()
    vim.cmd('Obsession')
end


vim.api.nvim_set_keymap('n', '<leader>oo', oil_open(), { noremap = true, silent = true, desc = "oil" })
