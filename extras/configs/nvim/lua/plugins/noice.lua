---@type LazySpec
return {
  'folke/noice.nvim',
  event = "VeryLazy",
  opts = {
    lsp = {
      override = {
        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
        ["vim.lsp.util.stylize_markdown"] = true,
        ["cmp.entry.get_documentation"] = true
      },
      presets = {
        bottom_search = true,
        command_pallete = false,
        long_message_to_split = true,
        lsp_doc_border = true
      },
    },
    views = {
      popup = {
        win_options = {
          winblend = 30
        }
      }
    }
  },
  dependencies = {
    'MunifTanjim/nui.nvim',
    { 'rcarriga/nvim-notify', opts = { background_colour = "#000000" } }
  }
}
