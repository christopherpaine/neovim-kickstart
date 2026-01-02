vim.loader.enable()

--things are clear now


-- <leader> key. Defaults to `\`. Some people prefer space.
-- The default leader is '\'. Some people prefer <space>. Uncomment this if you do, too.
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '


-- greatest remap ever
-- xnoremap("<leader>p", "\"_dP")

vim.opt.ignorecase = true
vim.opt.scrolloff = 999



-- so that cursor stays in the middle of the screen
vim.opt.scrolloff = 999





require("bufferline").setup{}




local cmd = vim.cmd
local opt = vim.o

-- See :h <option> to see what the options do

-- Search down into subfolders
opt.path = vim.o.path .. '**'

opt.number = true
opt.relativenumber = true
opt.cursorline = true
opt.lazyredraw = true
opt.showmatch = true -- Highlight matching parentheses, etc
opt.incsearch = true
opt.hlsearch = true

opt.spell = true
opt.spelllang = 'en'

opt.expandtab = true
opt.tabstop = 2
opt.softtabstop = 2
opt.shiftwidth = 2
opt.foldenable = true
opt.history = 2000
opt.nrformats = 'bin,hex' -- 'octal'
opt.undofile = true
opt.splitright = true
opt.splitbelow = true
opt.cmdheight = 0

opt.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]
opt.colorcolumn = '100'

-- Configure Neovim diagnostic messages

local function prefix_diagnostic(prefix, diagnostic)
  return string.format(prefix .. ' %s', diagnostic.message)
end

vim.diagnostic.config {
  virtual_text = {
    prefix = '',
    format = function(diagnostic)
      local severity = diagnostic.severity
      if severity == vim.diagnostic.severity.ERROR then
        return prefix_diagnostic('󰅚', diagnostic)
      end
      if severity == vim.diagnostic.severity.WARN then
        return prefix_diagnostic('⚠', diagnostic)
      end
      if severity == vim.diagnostic.severity.INFO then
        return prefix_diagnostic('ⓘ', diagnostic)
      end
      if severity == vim.diagnostic.severity.HINT then
        return prefix_diagnostic('󰌶', diagnostic)
      end
      return prefix_diagnostic('■', diagnostic)
    end,
  },
  signs = {
    text = {
      -- Requires Nerd fonts
      [vim.diagnostic.severity.ERROR] = '󰅚',
      [vim.diagnostic.severity.WARN] = '⚠',
      [vim.diagnostic.severity.INFO] = 'ⓘ',
      [vim.diagnostic.severity.HINT] = '󰌶',
    },
  },
  update_in_insert = false,
  underline = true,
  severity_sort = true,
  float = {
    focusable = false,
    style = 'minimal',
    border = 'rounded',
    source = 'if_many',
    header = '',
    prefix = '',
  },
}

-- Native plugins
cmd.filetype('plugin', 'indent', 'on')
cmd.packadd('cfilter') -- Allows filtering the quickfix list with :cfdo

-- let sqlite.lua (which some plugins depend on) know where to find sqlite
vim.g.sqlite_clib_path = require('luv').os_getenv('LIBSQLITE')






-- some personal bindings
vim.keymap.set('n', '<leader>q', ':bd<CR>', { desc = 'Close Buffer' })

--save file
vim.keymap.set('n', '<A-w>', ':w<CR>', { noremap = true, silent = true })

--copy and paste to system clipboard
vim.keymap.set('v', '<A-c>', '"+y', { noremap = true, silent = true })
vim.keymap.set('n', '<A-v>', ':put +<CR>', { noremap = true, silent = true })

--open netrw
vim.keymap.set('n', '<leader>n', vim.cmd.Ex, { desc = 'Open netrw' })

--save session
vim.keymap.set('n', 'Q', function()
  vim.cmd('mksession!')
end, { desc = 'Save session' })

--with tmux it gets current file directory and opens in ranger in another tmux window
vim.keymap.set('n', '<A-r>', function()
  local path = vim.fn.expand('%:p:h')
  os.execute('tmux new-window -c "' .. path .. '" ranger')
end, { noremap = true, silent = true })

--BUFFERLINE KEYBOARD SHORTCUTS

-- Move to the next buffer
vim.keymap.set('n', '<Tab>', '<cmd>BufferLineCycleNext<CR>', { desc = "Next buffer" })

-- Move to the previous buffer
vim.keymap.set('n', '<S-Tab>', '<cmd>BufferLineCyclePrev<CR>', { desc = "Previous buffer" })


-- Optional: set the leader key for emmet (default is <C-y>)
vim.g.user_emmet_leader_key = '<C-y>'

--using sgpt

--vim.cmd([[
--  command! -nargs=* Sg execute 'read ! sgpt ' . <q-args>
--]])
--

vim.cmd([[
  command! Sg execute 'read !sgpt ' . shellescape(join(getline("'<","'>"), "\n"))
]])


vim.keymap.set('v', 'ss', function()
  local lines = vim.fn.getline("'<", "'>")
  local text = table.concat(lines, "\n")
  vim.cmd('read !sgpt ' .. vim.fn.shellescape(text))
end, { noremap = true, silent = true })





--markdown -  insert a markdown link
 vim.keymap.set('n', '<leader>ml', 'i[<C-r><C-w>](<Esc>pa)<Esc>', {noremap = true, silent = true })




vim.keymap.set('n', '<leader>mt', function()
  vim.api.nvim_put({
    '| Column 1 | Column 2 |',
    '|----------|----------|',
    '|          |          |',
  }, 'l', true, true)
end, { noremap = true, silent = true, desc = "2 column markdown table"})



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



vim.keymap.set(
  'n',
  '<leader>mf',
  function() InsertFrontMatter() end,
  { noremap = true, silent = true, desc = 'Insert front matter' }
)
















_G.Street = function()

--  • local url: Declares a local variable named url.                              
--  • vim.fn.getreg('+'): Calls the Neovim function getreg to get the contents of  
--    the register specified by '+', which is typically the system clipboard.      


  local url = vim.fn.getreg('+')
    if url == '' then
        print("Clipboard is empty")
        return
    end


--  • url is the string you want to search.                                        
--  • pattern is the Lua pattern you want to match against the string.             
-- 
-- The function returns the first occurrence of the pattern in the string. If no   
-- match is found, it returns nil. Lua patterns are similar to regular expressions 
-- but have a different syntax and capabilities.                                   
    -- Extract lat, lng, heading, pitch
    local lat, lng, heading, pitch = url:match("@([%d%.%-]+),([%d%.%-]+),3a,[^,]*y,([%d%.%-]+)h,([%d%.%-]+)t")
-- • .: Matches any character except a newline.                                   
-- • %a: Matches any letter.                                                      
-- • %d: Matches any digit.                                                       
-- • %s: Matches any space character.                                             
-- • *: Matches 0 or more repetitions of the previous character/class.            
-- • +: Matches 1 or more repetitions of the previous character/class.            
-- • ?: Matches 0 or 1 occurrence of the previous character/class.                



    if not lat or not lng or not heading or not pitch then
        print("Failed to parse coordinates")
        return
    end
    lat, lng, heading, pitch = tonumber(lat), tonumber(lng), tonumber(heading), tonumber(pitch)

    -- Extract pano ID (robust: after !1s... in the URL)
    local pano = url:match("!1s([%w-_]+)")
    if not pano then
        print("Failed to parse pano ID")
        return
    end


    local pitch_for_iframe = 0  -- default value
    local pitch = url:match("pitch=([%d%.%-]+)")
    if pitch then
        pitch_for_iframe = tonumber(pitch)
    end




    -- Generate iframe string
    local iframe = string.format([[
<iframe 
  src="https://www.google.com/maps/embed?pb=!6m8!1m7!1s%s!2m2!1d%.7f!2d%.7f!3f%.2f!4f%.2f!5f0.7820865974627469" 
  width="600" height="450" style="border:0;" allowfullscreen="" loading="lazy" referrerpolicy="no-referrer-when-downgrade">
</iframe>]], pano, lat, lng, heading, pitch_for_iframe)

    -- Insert at cursor
    local row = vim.api.nvim_win_get_cursor(0)[1]
    vim.api.nvim_buf_set_lines(0, row, row, false, vim.split(iframe, "\n"))

    vim.cmd("normal! G")

    vim.cmd([[put =repeat([''], 2)]])
    vim.cmd("normal! G")





    print("Iframe inserted with correct view")
end



vim.keymap.set(
  'n',
  '<leader>mm',
  function() Street() end,
  { noremap = true, silent = true, desc = 'Street map iframe' }
)
























-- Define the module in init.lua
local file_paths_module = {}

local actions = require("telescope.actions")
local actions_state = require("telescope.actions.state")
local entry_display = require("telescope.pickers.entry_display")
local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local config = require("telescope.config").values
local log = require("plenary.log"):new()
log.level = "debug"

-- Function to get paths
function file_paths_module.file_paths()
  return {
    { type = "name", name = vim.fn.expand("%:t") },
    { type = "path", name = vim.fn.expand("%") },
    { type = "home", name = vim.fn.expand("%:~") },
    { type = "root", name = vim.fn.expand("%:p:h") },
  }
end

-- Create a displayer for Telescope
local displayer = entry_display.create({
  separator = " ",
  items = {
    { width = 4 },
    { remaining = true },
  },
})

-- Main function to list paths in Telescope
function file_paths_module.list_paths(opts)
  pickers.new(opts, {
    finder = finders.new_table({
      results = file_paths_module.file_paths(),
      entry_maker = function(entry)
        return {
          value = entry,
          display = function()
            return displayer({
              { entry.type, "TelescopeResultsNumber" },
              entry.name,
            })
          end,
          ordinal = entry.name,
        }
      end,
    }),
    layout_strategy = "cursor",
    layout_config = {
      height = 9,
      width = function(res)
        local max_width = 0
        for _, v in ipairs(res.finder.results) do
          if #v.value.name > max_width then max_width = #v.value.name end
        end
        return max_width + 14
      end,
    },
    sorter = config.generic_sorter(opts),
    prompt_title = "File Paths",
    attach_mappings = function(prompt_bufnr, map)
      local function handle_selection(selection)
        actions.close(prompt_bufnr)
        vim.fn.setreg('"', selection.value.name)
      end

      actions.select_default:replace(function()
        handle_selection(actions_state.get_selected_entry())
      end)

      map("i", "y", function()
        local selection = actions_state.get_selected_entry()
        actions.close(prompt_bufnr)
        vim.fn.setreg("+", selection.value.name)
      end)

      map("i", "<c-p>", function()
        local selection = actions_state.get_selected_entry()
        actions.close(prompt_bufnr)
        vim.api.nvim_paste(selection.value.name, true, -1)
      end)

      map("i", "P", function()
        local selection = actions_state.get_selected_entry()
        actions.close(prompt_bufnr)
        vim.api.nvim_put({ selection.value.name }, "l", false, false)
      end)

      map("i", "p", function()
        local selection = actions_state.get_selected_entry()
        actions.close(prompt_bufnr)
        vim.api.nvim_put({ selection.value.name }, "l", true, false)
      end)

      return true
    end,
  }):find()
end

-- Use it immediately or later
-- file_paths_module.list_paths()


_G.file_paths_module = file_paths_module



vim.keymap.set("n", "<leader>tt", function()
  file_paths_module.list_paths()
end)







-- Adds a new row at the end of CSV with auto-incremented fig_id
function AddNewFigRow()
  local buf = vim.api.nvim_get_current_buf()
  local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
  
  -- Find the last fig_id
  local last_id = "F000"
  for i = #lines, 1, -1 do
    local id = lines[i]:match("^(F%d+)")
    if id then
      last_id = id
      break
    end
  end

  -- Increment numeric part
  local num = tonumber(last_id:sub(2)) + 1
  local new_id = string.format("F%03d", num)

  -- Append new row with empty fields
  vim.api.nvim_buf_set_lines(buf, -1, -1, false, {new_id .. ",,"})

  -- Move cursor to new line after ID
  local new_line = #lines
  vim.api.nvim_win_set_cursor(0, {new_line + 1, #new_id + 1})
end

-- Optional keymap, e.g., <Leader>n
vim.keymap.set('n', '<Leader>mr', AddNewFigRow, {desc = "Add new fig_id row"})











