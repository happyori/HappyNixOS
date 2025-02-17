---@module 'lazy'
---@type LazySpec
return {
  'miikanissi/modus-themes.nvim',
  lazy = false,
  priority = 100000,
  opts = {
    style = 'modus_vivendi',
    transparent = true,
    styles = {
      comments = { italic = true },
      keywords = { bold = true },
    },
    line_nr_column_background = false,
    sign_column_background = false,
    on_highlights = function(highlights, colors)
      highlights.WhichKeyFloat = { bg = colors.bg_main }
      highlights.NormalFloat = { bg = colors.bg_main }
      highlights.CursorLineBG = { bg = colors.bg_active }
    end,
  },
}
