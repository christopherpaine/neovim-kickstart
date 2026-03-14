--which key settings for chris notes and front matter
require("which-key").add({
  { "<leader>ma", group = "figurative codes" },
})



-- put this in lua/lookup_csv.lua or init.lua

local csv_path = vim.fn.expand("~/christopherpaine_org/_data/figurative_codes.csv")




function add_next_fig_id()
  local line = vim.api.nvim_get_current_line()
  local prefix, ids_str, suffix = line:match("(.-%()(['%w,]*)(%))")
  if not ids_str then return end

  -- collect numeric parts
  local max_num = 0
  for id in ids_str:gmatch("'F(%d+)'") do
    local num = tonumber(id)
    if num > max_num then max_num = num end
  end

  -- next ID
  local next_id = string.format("'F%03d'", max_num + 1)

  -- append it to the list
  local new_ids_str
  if ids_str:match("%S") then
    new_ids_str = ids_str .. "," .. next_id
  else
    new_ids_str = next_id
  end

  -- reconstruct line
  local new_line = prefix .. new_ids_str .. suffix
  vim.api.nvim_set_current_line(new_line)
end


vim.keymap.set('n', '<Leader>maf', add_next_fig_id, {desc = "Add next fig_id within the brackets"})



function add_next_base_id()
  local line = vim.api.nvim_get_current_line()
  local prefix, ids_str, suffix = line:match("(.-%()(['%w,]*)(%))")
  if not ids_str then return end

  -- collect numeric parts
  local max_num = 0
  for id in ids_str:gmatch("'B(%d+)'") do
    local num = tonumber(id)
    if num > max_num then max_num = num end
  end

  -- next ID
  local next_id = string.format("'B%03d'", max_num + 1)

  -- append it to the list
  local new_ids_str
  if ids_str:match("%S") then
    new_ids_str = ids_str .. "," .. next_id
  else
    new_ids_str = next_id
  end

  -- reconstruct line
  local new_line = prefix .. new_ids_str .. suffix
  vim.api.nvim_set_current_line(new_line)
end


vim.keymap.set('n', '<Leader>mab', add_next_base_id, {desc = "Add next base_id within the brackets"})








function _G.lookup_csv_by_second_field()
  local key = get_visual_selection2()
  if key == "" then return end

  for line in io.lines(csv_path) do
    local f1, f2 = line:match("^%s*([^,]+),%s*([^,]+)")
    if f2 and vim.trim(f2) == key then
-- this bit puts what was found into register
      vim.fn.setreg('"', vim.trim(f1))
      return
    end
  end

  vim.notify("No match found for: " .. key, vim.log.levels.WARN)
end

vim.keymap.set("v", "<leader>mff",lookup_csv_by_second_field , { silent = true, desc = "get fig code description" })




function _G.lookup_csv_by_second_field_with_loop()
  local selection = get_visual_selection2()
vim.fn.setreg('"', "")
for key in selection:gmatch("%S+") do
  for line in io.lines(csv_path) do
    local f1, f2 = line:match("^%s*([^,]+),%s*([^,]+)")
    if f2 and vim.trim(f2) == key then
      local cur = vim.fn.getreg('"')
     vim.fn.setreg('"', cur .. "'" .. vim.trim(f1) .. "',")
      -- vim.fn.setreg('"', cur .. vim.trim(f1) )
      break
    end
    end
    end
    end

vim.keymap.set("v", "<leader>mfl",lookup_csv_by_second_field_with_loop , { silent = true, desc = "get fig code description for multiple words" })


function InsertFigurativeCodesFromVisual()
  local name = get_visual_selection2()
  if name == "" then return end

  local lines = {
    "  - name:  " .. name,
    "    query: |",
    "      SELECT interpretation as term, image",
    "      FROM figurative_codes",
    "      WHERE fig_id in ('F058')",
    "    output_file: " .. name .. ".html",
    "    caption: \"relevant figurative codes\"",
  }

  local row = vim.api.nvim_win_get_cursor(0)[1]
  vim.api.nvim_buf_set_lines(0, row, row, false, lines)
end


vim.keymap.set("v", "<leader>msf", InsertFigurativeCodesFromVisual, {
  desc = "SQL table for figurative codes",
})





















