
require("which-key").add({
  { "<leader>o", group = "obsession session" },
})



function toggle_obsession()
  if vim.fn.exists(':Obsession') == 2 then
    vim.cmd('Obsession')
  else
    print('Obsession plugin is not installed.')
  end
end

vim.api.nvim_set_keymap('n', '<leader>ot', ':lua toggle_obsession()<CR>', { noremap = true, silent = true })

