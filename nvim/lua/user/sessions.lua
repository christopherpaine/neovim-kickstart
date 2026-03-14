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
    local items = {}
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


function choose_item(on_choice)
  refresh_chat_list()
  pickers.new({}, {
    prompt_title = "Choose an Item",
    finder = finders.new_table {
      results = items,
    },
    sorter = conf.generic_sorter({}),
    attach_mappings = function(prompt_bufnr)
      actions.select_default:replace(function()
        actions.close(prompt_bufnr)
        local selection = action_state.get_selected_entry()
        on_choice(selection[1])  -- ← hand it back
      end)
      return true
    end,
  }):find()
end


function _G.set_current_session()
  choose_item(function(item)
vim.cmd('source ' .. "/home/chris-jakoolit/christopherpaine_org/_sessions/" .. item)
  end)
end




vim.keymap.set('n', '<leader>os', function() set_current_session() end, { desc = "change session" ,noremap = true, silent = true })

