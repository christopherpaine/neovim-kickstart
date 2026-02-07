vim.loader.enable()

--things are clear now


-- <leader> key. Defaults to `\`. Some people prefer space.
-- The default leader is '\'. Some people prefer <space>. Uncomment this if you do, too.
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '


-- greatest remap ever
 vim.keymap.set('x', '<leader>p', '"_dP', { noremap = true, silent = true })



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
vim.g.user_emmet_leader_key = '<C-1>'

























vim.keymap.set('n', '<leader>mt2', function()
  vim.api.nvim_put({
    '| Column 1 | Column 2 |',
    '|----------|----------|',
    '|          |          |',
  }, 'l', true, true)
end, { noremap = true, silent = true, desc = "2 column markdown table"})













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
  file_paths_module.list_paths() end,{desc = "get file paths etc"})







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
  vim.api.nvim_buf_set_lines(buf, -1, -1, false, {new_id .. ","})

  -- Move cursor to new line after ID
  local new_line = #lines
  vim.api.nvim_win_set_cursor(0, {new_line + 1, #new_id + 1})
end

-- Optional keymap, e.g., <Leader>n
vim.keymap.set('n', '<Leader>mrf', AddNewFigRow, {desc = "Add new fig_id row"})


-- Adds a new row at the end of CSV with auto-incremented fig_id
function AddNewbaseRow()
  local buf = vim.api.nvim_get_current_buf()
  local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
  
  -- Find the last fig_id
  local last_id = "B000"
  for i = #lines, 1, -1 do
    local id = lines[i]:match("^(B%d+)")
    if id then
      last_id = id
      break
    end
  end

  -- Increment numeric part
  local num = tonumber(last_id:sub(2)) + 1
  local new_id = string.format("B%03d", num)

  -- Append new row with empty fields
  vim.api.nvim_buf_set_lines(buf, -1, -1, false, {new_id .. ","})

  -- Move cursor to new line after ID
  local new_line = #lines
  vim.api.nvim_win_set_cursor(0, {new_line + 1, #new_id + 1})
end

-- Optional keymap, e.g., <Leader>n
vim.keymap.set('n', '<Leader>mrb', AddNewbaseRow, {desc = "Add new base_id row"})



local function get_visual_selection()
  local _, ls, cs = unpack(vim.fn.getpos("'<"))
  local _, le, ce = unpack(vim.fn.getpos("'>"))

  local lines = vim.api.nvim_buf_get_lines(0, ls - 1, le, false)
  if #lines == 0 then return "" end

  lines[#lines] = string.sub(lines[#lines], 1, ce)
  lines[1] = string.sub(lines[1], cs)

  return table.concat(lines, "")
end




local function get_visual_selection2()
-- Yank the current visual selection into register z and return it
vim.cmd('normal! "zy')   -- reselect visual area and yank into 'z'
local selection = vim.fn.getreg('z')
vim.notify(selection)
return selection
end











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




function InsertBaseImagesFromVisual()
  local name = get_visual_selection()
  if name == "" then return end
  local lines = {
    "  - name:  " .. name,
    "    query: |",
    "      SELECT image",
    "      FROM base_images",
    "      WHERE base_id in ('B058')",
    "    output_file: " .. name .. ".html",
    "    caption: \"relevant base images\"",
  }

  local row = vim.api.nvim_win_get_cursor(0)[1]
  vim.api.nvim_buf_set_lines(0, row, row, false, lines)
end


vim.keymap.set("v", "<leader>msbo", InsertBaseImagesFromVisual, {
  desc = "SQL table for base images",
})






function InsertBaseImagesandFigCodesFromVisual()
  local name = get_visual_selection()
  if name == "" then return end
  local lines = {
    "  - name:  " .. name,
    "    query: |",
    "      WITH basenhooks AS (",
    "      SELECT image, key_2, hook_number, base_id",
    "      FROM base_images",
    "      LEFT JOIN hooks",
    "      ON base_id = key_1",
    "      WHERE base_id in ('B005','B006','B007','B008','B009','B010','B011','B012')",
    "      )",
    "      SELECT basenhooks.image, interpretation",
    "      FROM basenhooks",
    "      LEFT JOIN figurative_codes",
    "      ON key_2 = fig_id",
    "      ORDER BY base_id, hook_number",
    "    output_file: " .. name .. ".html",
    "    caption: \"base image with fig codes\"",
  }

  local row = vim.api.nvim_win_get_cursor(0)[1]
  vim.api.nvim_buf_set_lines(0, row, row, false, lines)
end

vim.keymap.set("v", "<leader>msbf", InsertBaseImagesandFigCodesFromVisual, {
  desc = "SQL table for base images with figurative codes",
})

























function InsertIncludeFromRegister()
  local reg = vim.fn.getreg('"')
  local line = "{% include generated/" .. reg .. ".html%}"
  vim.api.nvim_put({ line }, 'c', true, true)
end


vim.keymap.set('n', '<leader>mts', InsertIncludeFromRegister, { noremap = true, silent = true, desc = "inclue the sql table" })




function _G.visual_append_to_filename()
--  -- get visual selection
--  local _, ls, cs = unpack(vim.fn.getpos("'<"))
--  local _, le, ce = unpack(vim.fn.getpos("'>"))
--  local lines = vim.fn.getline(ls, le)
--
--  if #lines == 0 then return end
--
--  lines[#lines] = string.sub(lines[#lines], 1, ce)
--  lines[1] = string.sub(lines[1], cs)
--  local selection = table.concat(lines, " ")


  local selection = get_visual_selection2()


  -- sanitize selection
  selection = selection:gsub("%s+", "-")






  -- current file info
  local fullpath = vim.fn.expand("%:p")
  local dir = vim.fn.fnamemodify(fullpath, ":h")
  local base = vim.fn.expand("%:t:r")
  local ext = vim.fn.expand("%:e")

  local newname = base .. "-" .. selection
  if ext ~= "" then
    newname = newname .. "." .. ext
  end

  local newpath = dir .. "/" .. newname

  -- open new file
  vim.cmd("edit " .. vim.fn.fnameescape(newpath))
end


vim.keymap.set("v", "<leader>mn", visual_append_to_filename, { silent = true, desc = "new file" })



function CopyFilenameNoExtToUnnamed()
  local name = vim.fn.expand("%:t:r")
  vim.fn.setreg('"', name)
end


vim.keymap.set("n", "<leader>mn", CopyFilenameNoExtToUnnamed, { desc = "Copy filename without extension" })




-- put this in lua/lookup_csv.lua or init.lua

local csv_path = vim.fn.expand("~/christopherpaine_org/_data/figurative_codes.csv")





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







vim.keymap.set('n', '<leader>te', function()
-- Get clipboard content into a Lua variable
local clipboard_text = vim.fn.getreg('+')  -- '+' is the system clipboard
clipboard_text = clipboard_text:gsub("http://127%.0%.0%.1:4000/", "")
clipboard_text = clipboard_text:gsub("%.html$", "")
local telescope = require('telescope.builtin')
--local input = vim.fn.input("Start typing file: ", "") -- prefill text
telescope.find_files({ default_text = clipboard_text })
end, { desc = '[t]elescope live grep with clipboard prefill for personal website and others' })




function _G.newfilewithfrontmatter()

-- Save current buffer
local cur_buf = vim.api.nvim_get_current_buf()
  visual_append_to_filename()
  InsertFrontMatter("none") 
  CopyFilenameNoExtToUnnamed()
-- Return to original buffer
vim.api.nvim_set_current_buf(cur_buf)

-- in Lua
vim.cmd('normal! viw')


end


vim.keymap.set("v", "<leader>mm",newfilewithfrontmatter , { silent = true, desc = "new file with front matter" })


require("user.closing")
require("user.markdown")
require("user.ai")
require("user.key-files")
require("user.memory")



vim.keymap.set("n", "<leader><CR>", function()
  vim.cmd("enew")        -- new empty buffer
  vim.cmd("terminal")    -- start terminal in it
  vim.cmd("startinsert") -- jump straight in
end, { desc = "Terminal in new buffer" })















