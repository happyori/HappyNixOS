local function get_display_name()
  return 'Telescope'
end

local telescope = {
  sections = {
    lualine_a = {
      { get_display_name },
    },
  },
  filetypes = { 'TelescopePrompt' },
}

return telescope
