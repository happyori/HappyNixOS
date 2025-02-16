---@module 'lazy'
---@type LazySpec
return {
  {
    'mrcjkb/rustaceanvim',
    version = '^5',
    lazy = false,
    dependencies = {
      'adaszko/tree_climber_rust.nvim',
    },
    config = function()
      vim.g.rustaceanvim = {
        tools = {},
        server = {
          on_attach = function(_, bufnr)
            local opts = { noremap = true, silent = true, buffer = bufnr }
            local bind = require('legendary').keymaps
            local toolbox = require 'legendary.toolbox'
            local run = function(fn)
              return toolbox.lazy_required_fn('tree_climber_rust', fn)
            end

            ---@type LegendKeys
            local keys = {
              { '<C-Space>', run 'init_selection', opts = opts, description = 'Initialize Rust Tree Climb' },
              { '<C-Space>', run 'select_incremental', opts = opts, description = 'Increment Climb', mode = 'x' },
              { '<C-S-Space>', run 'select_previous', opts = opts, description = 'Decrement Climb', mode = 'x' },
              {
                itemgroup = '[R]ust',
                keymaps = {
                  { '<leader>lRe', '<cmd>RustLsp expandMacro<cr>', description = '[E]xpand Macro' },
                  { '<leader>lRa', '<cmd>RustLsp codeAction<cr>', description = 'Code [A]ction (Rust)' },
                  { '<leader>lRx', '<cmd>RustLsp explainError<cr>', description = 'E[x]plain Error' },
                },
              },
            }

            bind(keys)
          end,
          -- settings = {
          --   ['rust-analyzer'] = {
          --     completion = {
          --       callable = {
          --         snippets = 'none',
          --       },
          --     },
          --   },
          -- },
        },
      }
    end,
  },
  {
    'saecki/crates.nvim',
    event = { 'BufRead Cargo.toml' },
    config = true,
    opts = {
      completion = {
        cmp = { enabled = true },
        crates = {
          enabled = true,
          max_results = 8,
          min_chars = 3,
        },
      },
      lsp = {
        enabled = true,
        actions = true,
        hover = true,
        completion = false,
        on_attach = function(_, bufnr)
          local bind = require('legendary').keymaps
          local toolbox = require 'legendary.toolbox'
          local opts = { buffer = bufnr }
          local run = function(fn, ...)
            return toolbox.lazy_required_fn('crates', fn, ...)
          end

          ---@type LegendKeys
          local keys = {
            {
              itemgroup = '[C]rate',
              keymaps = {
                { '<leader>lCr', run('reload', bufnr), description = '[R]eload Cargo.toml', opts = opts },
                {
                  '<leader>lCi',
                  run 'expand_plain_crate_to_inline_table',
                  description = '[I]nline the cargo table',
                  opts = opts,
                },
                { '<leader>lCv', run 'show_versions_popup', description = 'Show [V]ersions Popup', opts = opts },
                { '<leader>lCf', run 'show_features_popup', description = 'Show [F]eatures Popup', opts = opts },
              },
            },
          }

          bind(keys)
        end,
      },
    },
  },
}
