vim.api.nvim_create_user_command('Oil', function()
  vim.cmd('terminal oil')
end, {})
