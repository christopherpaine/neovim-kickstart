--which key settings for chris notes and front matter
require("which-key").add({
  { "<leader>m", group = "chris notes" },
})
require("which-key").add({
  { "<leader>mf", group = "frontmatter" },
})
--markdown -  insert a markdown link
function CreateMarkdownLink()
  -- Get the selected text in visual mode
  local start_pos = vim.fn.getpos("'<")
  local end_pos = vim.fn.getpos("'>")
  local lines = vim.fn.getline(start_pos[2], end_pos[2])
  lines[1] = string.sub(lines[1], start_pos[3])
  lines[#lines] = string.sub(lines[#lines], 1, end_pos[3])
  local selected_text = table.concat(lines, '\n')

  -- Get the URL from the system clipboard
  local url = vim.fn.getreg('+')

  -- Format the Markdown link
  local markdown_link = string.format("[%s](%s)", selected_text, url)

  -- Replace the selected text with the Markdown link
  vim.api.nvim_buf_set_text(0, start_pos[2] - 1, start_pos[3] - 1, end_pos[2] - 1, end_pos[3], { markdown_link })
end

-- Map this function to a key combination in visual mode, for example:
vim.api.nvim_set_keymap('v', '<leader>ml', ':<C-u>lua Link()<CR>', { noremap = true, silent = true })

_G.InsertFrontMatter = function(parent)
    parent = parent or "Exploration"  -- default value
    local filename = vim.fn.expand('%:t:r')
    filename = filename:gsub("-", " ")
    filename = filename:gsub("(%w+)", function(w) return w:sub(1,1):upper() .. w:sub(2) end)
    local lines = {
        '---',
        'layout: default',
        'title: ' .. filename,
        'parent: ' .. parent,
        '---',
        ''
    }
    vim.api.nvim_buf_set_lines(0, 0, 0, false, lines)
end
-- set keymaps for frontmatter 
vim.keymap.set(
  'n',
  '<leader>mfe',
  function() InsertFrontMatter() end,
  { noremap = true, silent = true, desc = 'exploration' }
)
vim.keymap.set(
  'n',
  '<leader>mfn',
  function() InsertFrontMatter("none") end,
  { noremap = true, silent = true, desc = 'none' }
)
