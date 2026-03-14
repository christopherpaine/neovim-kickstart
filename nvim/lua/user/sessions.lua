local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local actions = require("telescope.actions")
local action_state = require('telescope.actions.state')
local conf = require('telescope.config').values
local items = {}

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




function getVimFiles(folderPath)
    local p = io.popen('ls "'..folderPath..'"')
    for file in p:lines() do
        if file:match("%.vim$") then
            table.insert(items, file)
        end
    end
    p:close()
    return items
end

-- Example usage:
-- local vimFiles = getVimFiles("/path/to/folder")
-- for _, file in ipairs(vimFiles) do
--     print(file)
-- end



vim.api.nvim_set_keymap('n', '<leader>os', ':lua getVimFiles("/home/chris-jakoolit/christopherpaine_org/_sessions")<CR>', { noremap = true, silent = true })
