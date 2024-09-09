return {
  'utilyre/sentiment.nvim',
  version = "*",
  event = "VeryLazy",
  opts = {},
  init = function ()
    vim.g.loaded_matchparen = 1
  end
}
