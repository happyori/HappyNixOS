---@module 'lazy'
---@type LazySpec
return {
  'nvim-lualine/lualine.nvim',
  dependencies = {
    'folke/noice.nvim',
    'nvim-tree/nvim-web-devicons',
  },
  lazy = false,
  opts = function(_, opts)
    local noice = require 'noice'
    local lazy_status = require 'lazy.status'
    local icons = require 'utils.icons'
    local ext = require 'utils.lualine_ext.init'

    return vim.tbl_deep_extend('force', opts, {
      options = {
        theme = require 'neofusion.lualine',
        globalstatus = true,
        component_separators = '',
        section_separators = '',
        disabled_filetypes = { 'dashboard', 'packer', 'help' },
        ignore_focus = {},
      },
      sections = {
        lualine_a = { 'progress' },
        lualine_b = {
          {
            'branch',
            icon = icons.git.Branch,
            padding = { left = 1, right = 1 },
          },
        },
        lualine_c = {
          {
            'filetype',
            icon_only = true,
            padding = { left = 2, right = 0 },
            color = '_lualine_c_filetype',
          },
          {
            'filename',
            file_status = true,
            path = 1,
            symbols = {
              unnamed = '',
              readonly = icons.ui.Lock,
              modified = icons.ui.Pencil,
            },
            padding = { left = 1 },
            color = { gui = 'bold' },
          },
        },
        lualine_x = {
          {
            lazy_status.updates,
            cond = lazy_status.has_updates,
          },
          {
            'diff',
            colored = true,
            padding = { right = 2 },
            symbols = {
              added = icons.git.LineAdded,
              modified = icons.git.LineModified,
              removed = icons.git.LineRemoved,
            },
          },
          {
            ---@diagnostic disable-next-line: undefined-field
            noice.api.status.mode.get,
            ---@diagnostic disable-next-line: undefined-field
            cond = noice.api.status.mode.has,
          },
        },
        lualine_y = {},
        lualine_z = {
          { 'location' },
        },
      },
      tabline = {},
      extensions = {
        'toggleterm',
        'mason',
        'quickfix',
        'man',
        'lazy',
        ext.telescope,
        ext.lsp_info,
      },
    })
  end,
}
