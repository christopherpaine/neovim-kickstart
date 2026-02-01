require("which-key").add({
  { "<leader>i", group = "files" },
})


-- Function to open a file in a new buffer
local function OpenFile(filepath)
  vim.cmd('edit ' .. filepath)
end

-- Keybind
vim.keymap.set("n", "<leader>ii", function()
  OpenFile('/home/chris-jakoolit/neovim-kickstart/nvim/init.lua')
end, { desc = "init lua" })

 

vim.keymap.set("n", "<leader>ic", function()
  OpenFile('/home/chris-jakoolit/.chats/chats.csv')
end, { desc = "ai chats" })



vim.keymap.set("n", "<leader>in", function()
  OpenFile('/home/chris-jakoolit/christopherpaine_org/index.markdown')
end, { desc = "chris notes" })
