--which key settings for chris notes and front matter
require("which-key").add({
  { "<leader>m", group = "chris notes" },
})
require("which-key").add({
  { "<leader>mf", group = "frontmatter" },
})
require("which-key").add({
  { "<leader>mi", group = "include liquid" },
})

require("which-key").add({
  { "<leader>mr", group = "memory encoding" },
})

require("which-key").add({
  { "<leader>mr", group = "figurative codes", mode="v" },
})


--markdown -  insert a markdown link
function CreateMarkdownLink()

vim.api.nvim_put({ "[" .. vim.fn.getreg("a") .. "](" .. vim.fn.getreg("s") .. ")" }, "c", true, true)
end

vim.keymap.set('n', '<leader>ml', function() CreateMarkdownLink() end, { noremap = true, silent = true })



--FRONTMATTER---------------------------------------------------

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


--LIQUID---------------------------------------------------

function Include_mp3()

vim.api.nvim_put({ "{% include mp3.html file='/private_assets/' %}" }, "c", true, true)
end

function Include_mp4()

vim.api.nvim_put({ "{% include mp4.html file='/private_assets/' %}" }, "c", true, true)
end
function Include_img600()

vim.api.nvim_put({ "{% include img600px.html file='/images/' %}" }, "c", true, true)
end

vim.keymap.set('n', '<leader>miv', function() Include_mp4() end, { noremap = true, silent = true, desc = 'include mp3' })
vim.keymap.set('n', '<leader>mim', function() Include_mp3() end, { noremap = true, silent = true, desc = 'include mp3' })
vim.keymap.set('n', '<leader>mii', function() Include_img600() end, { noremap = true, silent = true, desc = 'include 600px image' })




