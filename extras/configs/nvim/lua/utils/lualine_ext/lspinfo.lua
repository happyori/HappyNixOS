local function get_display_name()
  return 'LspInfo'
end

local M = {
  sections = {
    lualine_a = {
      { get_display_name },
    },
  },
  filetypes = { 'lspinfo' },
}

return M
