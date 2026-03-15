--which key settings for chris notes and front matter

local wk = require("which-key")

wk.add({
{ "<leader>m", group = "chris notes" },
{ "<leader>mf", group = "frontmatter" },

{ "<leader>mf", group = "figurative codes", mode="v" },

{ "<leader>ml", group = "markdown links" },
{ "<leader>mla", group = "markdown link reg a nd reg b" },

{ "<leader>mi", group = "include liquid" },
})




function markdownlinkstarter()
  vim.cmd('normal! i(')
  vim.cmd('stopinsert')    -- safer than trying to send <Esc> in normal mode
  -- Paste from default register
  vim.cmd('normal! pb')
  vim.cmd('normal! a)')
end




function CreateMarkdownLink()
  vim.api.nvim_put({ "[" .. vim.fn.getreg("a") .. "](" .. vim.fn.getreg("s") .. ")" }, "c", true, true)
end


vim.keymap.set('n', '<leader>mlp', function() markdownlinkstarter() end, { noremap = true, silent = true, desc = 'paste " register' })


vim.keymap.set('n', '<leader>mla', function() CreateMarkdownLink() end, { noremap = true, silent = true })



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




