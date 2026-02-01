local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local actions = require("telescope.actions")
local action_state = require('telescope.actions.state')
local conf = require('telescope.config').values
local items = {}

-- I am storing stuff in ~/.chats/
function _G.refresh_chat_list()
  items = {}
  local file = io.open("/home/chris-jakoolit/.chats/chats.csv", "r")
  if file then
      local line = file:read("*l")
      for value in string.gmatch(line, "([^,]+)") do
          table.insert(items, value)
      end
      file:close()
  end
end


function _G.choose_item(on_choice)
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


function writeValueToFile(filename, value)
    local file, err = io.open(filename, "w")  -- open in write mode
    if not file then
        error("Could not open file: " .. err)
    end
    file:write(tostring(value))  -- ensure the value is a string
    file:close()
end



function _G.set_current_chat()
  choose_item(function(chatitem)
  writeValueToFile("/home/chris-jakoolit/.chats/current-chat.txt", chatitem)
  end)
end



local function read_file_to_var(filepath)
    local file = io.open(filepath, "r")
    if not file then
        vim.notify("Could not open file: " .. filepath, vim.log.levels.ERROR)
        return nil
    end
    local content = file:read("*a") -- read entire file
    file:close()
    return content
end










-- Function to prompt and insert text
function _G.prompt_and_insert()
  local chatitem = read_file_to_var("/home/chris-jakoolit/.chats/current-chat.txt")
  vim.ui.input({ prompt = "Insert text: " }, function(input)
  local cmd2 = "sgpt --no-md --chat " .. chatitem .. " " .. vim.fn.shellescape(input)
  local output = vim.fn.system(cmd2)
  local lines = vim.split(output, "\n", { plain = true })


    if output then
      vim.api.nvim_put(lines, "l", true, true)
    end
  end)
end



function _G.prompt_and_insert_code()
  local chatitem = read_file_to_var("/home/chris-jakoolit/.chats/current-chat.txt")
  vim.ui.input({ prompt = "Insert text: " }, function(input)
  local cmd2 = "sgpt --code " .. chatitem .. " " .. vim.fn.shellescape(input)
  local output = vim.fn.system(cmd2)
  local lines = vim.split(output, "\n", { plain = true })


    if output then
      vim.api.nvim_put(lines, "l", true, true)
    end
  end)
end

















vim.keymap.set("n", "<leader>bv", set_current_chat, { desc = "set current chat" })

-- Keybind (change <leader>i if you want)
vim.keymap.set("n", "<leader>bb", prompt_and_insert, { desc = "Prompt and insert text" })
vim.keymap.set("n", "<leader>bc", prompt_and_insert_code, { desc = "Prompt and insert code" })


