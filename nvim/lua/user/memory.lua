--which key settings for chris notes and front matter
require("which-key").add({
  { "<leader>ma", group = "figurative codes" },
})



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





























