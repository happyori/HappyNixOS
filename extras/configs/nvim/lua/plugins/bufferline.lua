local icons = require 'utils.icons'
local function is_ft(b, ft)
  return vim.bo[b].filetype == ft
end

local function diagnostics_indicator(num, _, diagnostics, _)
  local result = {}
  local symbols = {
    error = icons.diagnostics.Error,
    warning = icons.diagnostics.Warning,
    info = icons.diagnostics.Information,
  }
  for name, count in pairs(diagnostics) do
    if symbols[name] and count > 0 then table.insert(result, symbols[name] .. ' ' .. count) end
  end
  local concat_result = table.concat(result, ' ')
  return #concat_result > 0 and concat_result or ''
end

local function custom_filter(buf, buf_nums)
  local logs = vim.tbl_filter(function(b)
    return is_ft(b, 'log')
  end, buf_nums or {})
  if vim.tbl_isempty(logs) then return true end
  local tab_num = vim.fn.tabpagenr()
  local last_tab = vim.fn.tabpagenr '$'
  local is_log = is_ft(buf, 'log')
  if last_tab == 1 then return true end
  -- only show log buffers in secondary tabs
  return (tab_num == last_tab and is_log) or (tab_num ~= last_tab and not is_log)
end

---@module 'lazy'
---@type LazySpec
return {
  'akinsho/bufferline.nvim',
  version = '*',
  dependencies = {
    'nvim-tree/nvim-web-devicons',
  },
  event = 'VeryLazy',
  opts = function()
    local bufferline = require 'bufferline'
    return {
      options = {
        get_element_icon = nil,
        show_duplicate_prefix = true,
        duplicates_across_groups = true,
        auto_toggle_bufferline = true,
        move_wraps_at_ends = false,
        groups = { items = {}, options = { toggle_hidden_on_enter = true } },
        mode = 'buffers',
        numbers = 'ordinal',
        style_preset = bufferline.style_preset.default,
        color_icons = true,
        indicator = {
          icon = icons.ui.BoldLineLeft,
          style = 'icon',
        },
        buffer_close_icon = nil,
        modified_icon = icons.ui.Circle,
        close_icon = nil,
        left_trunc_marker = icons.ui.ArrowCircleLeft,
        right_trunc_marker = icons.ui.ArrowCircleRight,
        max_name_length = 18,
        max_prefix_length = 15,
        truncate_names = true,
        tab_size = 18,
        diagnostics = 'nvim_lsp',
        diagnostics_update_in_insert = false,
        diagnostics_indicator = diagnostics_indicator,
        custom_filter = custom_filter,
        offsets = {
          {
            filetype = 'undotree',
            text = 'Undotree',
            highlight = 'PanelHeading',
            padding = 1,
          },
          {
            filetype = 'DiffviewFiles',
            text = 'Diff View',
            highlight = 'PanelHeading',
            padding = 1,
          },
          {
            filetype = 'flutterToolsOutline',
            text = 'Flutter Outline',
            highlight = 'PanelHeading',
          },
          {
            filetype = 'lazy',
            text = 'Lazy',
            highlight = 'PanelHeading',
            padding = 1,
          },
        },
        show_buffer_icons = true,
        show_buffer_close_icons = false,
        show_close_icon = false,
        show_tab_indicators = true,
        persist_buffer_sort = true,
        separator_style = 'thin',
        enforce_regular_tabs = false,
        always_show_bufferline = true,
        hover = { enabled = false },
        sort_by = 'id',
        debug = { logging = false },
      },
    }
  end,
}
