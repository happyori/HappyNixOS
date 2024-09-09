---@module 'lazy'
---@type LazySpec
return {
  'stevearc/oil.nvim',
  ---@module 'oil'
  ---@type oil.SetupOpts
  opts = {
    default_file_explorer = true,
    columns = { 'icon' },
    win_options = { winblend = 30 },
    skip_confirm_for_simple_edits = true,
    prompt_save_on_select_new_entry = true,
    keymaps = {
      ["<BS>"] = "actions.parent",
      ["q"] = "actions.close",
      ["<Esc>"] = "actions.close",
      ["l"] = "actions.select",
      ["h"] = "actions.parent"
    },
    float = {
      win_options = {
        winblend = 30
      }
    }
  },
  dependencies = {
    'nvim-tree/nvim-web-devicons'
  },
  event = 'VeryLazy',
  keys = {
    { '<leader>e', '<cmd>Oil --float<cr>', desc = 'Open Oil Float (navigation)' }
  }
}
