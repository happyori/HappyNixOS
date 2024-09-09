---@module 'lazy'
---@type LazySpec
return {
  {
    'numToStr/Comment.nvim',
    event = 'VeryLazy',
  },
  {
    'folke/todo-comments.nvim',
    event = 'VeryLazy',
    dependencies = { 'nvim-lua/plenary.nvim' },
  },
}
