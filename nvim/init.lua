vim.loader.enable()

-- <leader> key. Defaults to `\`. Some people prefer space.
-- The default leader is '\'. Some people prefer <space>. Uncomment this if you do, too.
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '



vim.opt.ignorecase = true
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

vim.cmd([[
  command! -nargs=* Sg execute 'read ! sgpt ' . <q-args>
]])



 vim.keymap.set('n', '<leader>ml', 'i[<C-r><C-w>](<Esc>pa)<Esc>', {noremap = true, silent = true })







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






    print("Iframe inserted with correct view")
end


