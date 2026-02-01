local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local actions = require("telescope.actions")
local action_state = require('telescope.actions.state')
local conf = require('telescope.config').values


-- I am storing stuff in ~/.chats/
local items = {}

local file = io.open("/home/chris-jakoolit/.chats/chats.csv", "r")
if file then
    local line = file:read("*l")
    for value in string.gmatch(line, "([^,]+)") do
        table.insert(items, value)
    end
    file:close()
end








function _G.choose_item(on_choice)
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

-- Function to prompt and insert text
function _G.prompt_and_insert()
  choose_item(function(chatitem)
  vim.ui.input({ prompt = "Insert text: " }, function(input)
  local cmd2 = "sgpt --no-md --chat " .. chatitem .. " " .. vim.fn.shellescape(input)
  local output = vim.fn.system(cmd2)
  local lines = vim.split(output, "\n", { plain = true })


    if output then
      vim.api.nvim_put(lines, "l", true, true)
    end
  end)
end)
end


vim.keymap.set("n", "<leader>bv", prompt_and_insert, { desc = "Prompt and insert text" })


-- Keybind (change <leader>i if you want)
vim.keymap.set("n", "<leader>bb", prompt_and_insert, { desc = "Prompt and insert text" })


