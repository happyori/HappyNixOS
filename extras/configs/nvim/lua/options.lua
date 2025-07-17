local op = vim.opt

op.number = true
op.relativenumber = true
op.wrap = false

op.mouse = 'a'
op.showmode = false

vim.schedule(function()
  vim.opt.clipboard = 'unnamedplus'
end)

op.breakindent = false
op.undofile = false
op.ignorecase = true
op.smartcase = true

op.tabstop = 4
op.shiftwidth = 2
op.expandtab = true

op.signcolumn = 'yes'
op.updatetime = 250
op.timeoutlen = 300

op.splitright = true
op.splitbelow = true

op.list = true
op.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

op.inccommand = 'split'
op.fillchars = {
  foldopen = '',
  foldclose = '',
  fold = ' ',
  foldsep = ' ',
  diff = '╱',
  eob = ' ',
}
op.foldlevel = 99
op.grepprg = 'rg --vimgrep'
op.grepformat = '%f:%l:%c:%m'
op.virtualedit = 'block'

op.conceallevel = 2

op.cursorline = true
op.scrolloff = 16
op.winblend = 30
op.pumblend = 30
op.completeopt = 'menu,menuone,noselect'
op.formatexpr = "v:lua.require'conform'.formatexpr()"

if vim.g.neovide then
  vim.g.neovide_floating_blur_amount_x = 2.0
  vim.g.neovide_floating_blur_amount_y = 2.0
  vim.g.neovide_opacity = 0.8
  vim.g.neovide_refresh_rate = 144
  vim.g.neovide_cursor_smooth_blink = true
  vim.g.neovide_cursor_vfx_mode = 'railgun'
  -- vim.o.guifont = 'caskaydiacove nerd font'
end
