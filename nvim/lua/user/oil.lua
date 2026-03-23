--vim.api.nvim_create_user_command('Oil', function()
--  vim.cmd('terminal oil')
--end, {})


--Why this is needed
--The file explorer plugin oil.nvim opens buffers that are not listed by default, so this autocmd ensures they appear in your buffer list (useful for buffer switching plugins).
vim.api.nvim_exec([[
  autocmd FileType oil setlocal buflisted
]], false)


vim.keymap.set('n', '<leader>oo', function()
    vim.cmd('Oil')
end, { desc = "oil" })
