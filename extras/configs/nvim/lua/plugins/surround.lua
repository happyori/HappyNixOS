---@module 'lazy'
---@type LazySpec
return {
  {
    'kylechui/nvim-surround',
    version = '*',
    event = 'VeryLazy',
    opts = {
      keymaps = {
        normal = 'ma',
        normal_cur = 'maa',
        normal_line = 'mA',
        normal_cur_line = 'mAA',
        delete = 'md',
        change = 'mc',
        change_line = 'mC',
      },
    },
  },
}
