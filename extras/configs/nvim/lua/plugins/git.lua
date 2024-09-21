local icons = require 'utils.icons'

---@module 'lazy'
---@type LazySpec
return {
  {
    'lewis6991/gitsigns.nvim',
    event = 'VeryLazy',
    opts = {
      numhl = false,
      current_line_blame = true,
      current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = 'eol',
      },
      current_line_blame_formatter = '== <author>, <summary> ==',
      signs = {
        add = {
          text = icons.ui.BoldLineLeft,
        },
        change = {
          text = icons.ui.BoldLineLeft,
        },
        delete = {
          text = icons.ui.Triangle,
        },
        topdelete = {
          text = icons.ui.Triangle,
        },
        changedelete = {
          text = icons.ui.BoldLineLeft,
        },
      },
    },
  },
  {
    'akosho/toggleterm.nvim',
    init = function(_)
      local Terminal = require('toggleterm.terminal').Terminal
      local lazygit = Terminal:new {
        cmd = 'lazygit',
        hidden = true,
        direction = 'float',
        float_opts = {
          border = 'none',
          width = 100000,
          height = 100000,
          zindex = 200,
        },
        on_open = function(_)
          vim.cmd [[ startinsert! ]]
        end,
        on_close = function(_) end,
        count = 99,
      }

      require('legendary').keymap {
        itemgroup = '[T]erminals',
        keymaps = {
          {
            '<leader>Tl',
            function()
              lazygit:toggle()
            end,
            description = 'Open [L]azyGit Terminal',
          },
        },
      }
    end,
  },
}
