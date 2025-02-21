---@module 'lazy'
---@type LazySpec
return {
  {
    'nvim-telescope/telescope.nvim',
    event = 'VimEnter',
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make',
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
      'nvim-telescope/telescope-ui-select.nvim',
      'nvim-tree/nvim-web-devicons',
      'folke/trouble.nvim',
    },
    config = function(_, opts)
      local telescope = require 'telescope'
      local trouble = require 'trouble.sources.telescope'
      opts = vim.tbl_deep_extend('force', opts, {
        defaults = {
          mappings = {
            i = { ['<C-t>'] = trouble.open, ['<C-S-t>'] = trouble.add },
            n = { ['<C-t>'] = trouble.open, ['<C-S-t>'] = trouble.add },
          },
        },
      })
      telescope.setup(opts)

      pcall(telescope.load_extension, 'fzf')
      pcall(telescope.load_extension, 'ui-select')
    end,
    opts = {
      defaults = {
        winblend = 50,
      },
      extensions = {
        ['ui-select'] = {
          require('telescope.themes').get_dropdown(),
        },
      },
    },
    keys = function()
      local bind = require('legendary').keymaps
      local toolbox = require 'legendary.toolbox'
      local builtins = setmetatable({}, {
        __index = function(_, k)
          return toolbox.lazy_required_fn('telescope.builtin', k)
        end,
      })

      ---@type LegendKeys
      local keys = {
        { '<leader><leader>', builtins.find_files, description = '[ ] Search Files' },
        {
          itemgroup = '[S]earch',
          description = 'General Telescope Search Commands',
          keymaps = {
            { '<leader>sh', builtins.help_tags, description = '[S]earch [H]elp' },
            { '<leader>sk', builtins.keymaps, description = '[S]earch [K]eymaps' },
            { '<leader>sb', builtins.builtin, description = '[S]earch Telescope [B]uiltins' },
            { '<leader>sw', builtins.grep_string, description = '[S]earch current [W]ord' },
            { '<leader>sg', builtins.live_grep, description = '[S]earch by [G]rep' },
            { '<leader>sd', builtins.diagnostics, description = '[S]earch [D]iagnostics' },
            { '<leader>sr', builtins.oldfiles, description = '[S]earch [R]ecent' },
            {
              '<leader>sn',
              toolbox.lazy_required_fn('telescope.builtin', 'find_files', { cwd = vim.fn.stdpath 'config' }),
              description = '[S]earch [N]eovim Files',
            },
          },
        },
        {
          '<leader>/',
          function()
            builtins.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
              winblend = 10,
              previewer = false,
            })
          end,
          description = '[/] Fuzzy find in current buffer',
        },
      }

      bind(keys)

      return {}
    end,
  },
}
