-- Applies the wallust-generated hyprland-match.conf palette as Neovim
-- highlight groups, mirroring how kitty picks up the same file.
-- Run :Wallust to re-read the file after wallust regenerates it.

local M = {}

local palette_file = vim.fn.expand('~/hyprland-match.conf')

local function parse_palette(path)
  local f = io.open(path, 'r')
  if not f then
    vim.notify('wallust: could not open ' .. path, vim.log.levels.ERROR)
    return nil
  end

  local colors = {}
  for line in f:lines() do
    local key, value = line:match('^%s*(%S+)%s+(#%x%x%x%x%x%x)')
    if key then
      colors[key] = value
    end
  end
  f:close()
  return colors
end

function M.load()
  local c = parse_palette(palette_file)
  if not c then
    return
  end

  vim.o.termguicolors = true
  vim.o.background = 'dark'
  vim.cmd('highlight clear')
  if vim.fn.exists('syntax_on') == 1 then
    vim.cmd('syntax reset')
  end
  vim.g.colors_name = 'wallust'

  local hl = vim.api.nvim_set_hl

  hl(0, 'Normal', { fg = c.foreground, bg = c.background })
  hl(0, 'NormalFloat', { fg = c.foreground, bg = c.color1 })
  hl(0, 'FloatBorder', { fg = c.color8, bg = c.color1 })
  hl(0, 'Comment', { fg = c.color8, italic = true })
  hl(0, 'CursorLine', { bg = c.color1 })
  hl(0, 'CursorLineNr', { fg = c.foreground, bold = true })
  hl(0, 'LineNr', { fg = c.color8 })
  hl(0, 'Visual', { bg = c.color2 })
  hl(0, 'Search', { fg = c.background, bg = c.color3 })
  hl(0, 'IncSearch', { fg = c.background, bg = c.color11 })
  hl(0, 'MatchParen', { bg = c.color2, bold = true })
  hl(0, 'StatusLine', { fg = c.foreground, bg = c.color1 })
  hl(0, 'StatusLineNC', { fg = c.color8, bg = c.color1 })
  hl(0, 'WinSeparator', { fg = c.color1 })
  hl(0, 'Pmenu', { fg = c.foreground, bg = c.color1 })
  hl(0, 'PmenuSel', { fg = c.background, bg = c.color7 })
  hl(0, 'ColorColumn', { bg = c.color1 })
  hl(0, 'NonText', { fg = c.color8 })
  hl(0, 'SpecialKey', { fg = c.color8 })

  hl(0, 'Constant', { fg = c.color3 })
  hl(0, 'String', { fg = c.color2 })
  hl(0, 'Character', { fg = c.color2 })
  hl(0, 'Number', { fg = c.color11 })
  hl(0, 'Boolean', { fg = c.color11 })
  hl(0, 'Identifier', { fg = c.foreground })
  hl(0, 'Function', { fg = c.color4, bold = true })
  hl(0, 'Statement', { fg = c.color5 })
  hl(0, 'Keyword', { fg = c.color5, italic = true })
  hl(0, 'Conditional', { fg = c.color5 })
  hl(0, 'Repeat', { fg = c.color5 })
  hl(0, 'PreProc', { fg = c.color6 })
  hl(0, 'Type', { fg = c.color6 })
  hl(0, 'Special', { fg = c.color13 })
  hl(0, 'Underlined', { fg = c.color12, underline = true })
  hl(0, 'Error', { fg = c.color9, bold = true })
  hl(0, 'Todo', { fg = c.color11, bg = c.color1, bold = true })

  hl(0, 'DiagnosticError', { fg = c.color9 })
  hl(0, 'DiagnosticWarn', { fg = c.color11 })
  hl(0, 'DiagnosticInfo', { fg = c.color12 })
  hl(0, 'DiagnosticHint', { fg = c.color14 })

  hl(0, 'DiffAdd', { fg = c.color2 })
  hl(0, 'DiffChange', { fg = c.color3 })
  hl(0, 'DiffDelete', { fg = c.color1 })
  hl(0, 'DiffText', { fg = c.color4 })

  for i = 0, 15 do
    vim.g['terminal_color_' .. i] = c['color' .. i]
  end

  vim.notify('wallust colors reloaded from ' .. palette_file, vim.log.levels.INFO)
end

vim.api.nvim_create_user_command('Wallust', M.load, {
  desc = 'Reload colors from ~/hyprland-match.conf (wallust palette)',
})

M.load()

return M
