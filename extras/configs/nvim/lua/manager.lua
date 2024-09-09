-- Install Lazy
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lzyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lzyrepo, lazypath }
  if vim.v.shell_error ~= 0 then error('Error cloning lazy.nvim:\n' .. out) end
end
vim.opt.rtp:prepend(lazypath)

-- Setup Lazy

require('lazy').setup {
  spec = {
    { import = 'plugins' },
    { import = 'plugins.lsp' },
    { import = 'plugins.colorschemes' },
  },
  defaults = {
    lazy = true,
  },
  install = { colorscheme = { 'habamax' } },
  checker = { enabled = true },
}
