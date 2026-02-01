--which key settings for chris notes and front matter
require("which-key").add({
  { "<leader>m", group = "chris notes" },
})
require("which-key").add({
  { "<leader>mf", group = "frontmatter" },
})
--markdown -  insert a markdown link
function CreateMarkdownLink()
vim.cmd("'<,'>yank z")

end

vim.keymap.set('v', '<leader>ml', function() CreateMarkdownLink() end, { noremap = true, silent = true })

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
