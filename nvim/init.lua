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



 vim.api.nvim_set_keymap('n', '<leader>ml', 'i[<C-r><C-w>](<Esc>pa)<Esc>', {noremap = true, silent = true })
