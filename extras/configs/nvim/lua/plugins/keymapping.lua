---@alias KeyOpts vim.api.keyset.cmd_opts
---@alias LegendKey { [0]: string, [1]: string|fun(), description?: string, mode?: string|string[], opts?: KeyOpts }
---@alias LegendItemGroup { itemgroup: string, icon?: string, description?: string, keymaps: LegendKey[] }
---@alias LegendKeys (LegendItemGroup|LegendKey)[]

---@module 'lazy'
---@type LazySpec
return {
  {
    'mrjones2014/legendary.nvim',
    version = 'v2.13.11',
    priority = 10000,
    lazy = false,
    dependencies = {
      'folke/which-key.nvim',
    },
    opts = {
      extensions = {
        lazy_nvim = true,
      },
      ---@type LegendKeys
      keymaps = {
        { '<Esc>', '<cmd>nohlsearch<cr>' },
        { '<leader>q', '<cmd>q<cr>', description = '[Q]uit window' },
        { '<leader>Dq', vim.diagnostic.setloclist, description = 'Open [D]iagnostic [Q]uickfix list' },
        { '<Esc><Esc>', '<C-\\><C-n>', description = 'Exit terminal mode', mode = 't' },
        { '<leader>`', '<cmd>LegendaryScratchToggle<cr>', description = '[`] Toggle open scratch pad' },
        { '<C-s>', '<cmd>w<cr><Esc>', description = '[W]rite to file', mode = { 'n', 'i' } },
        {
          itemgroup = 'Window Movement',
          description = 'Keys for movement',
          keymaps = {
            { '<C-h>', '<C-w><C-h>', description = 'Move focus to the left window' },
            { '<C-l>', '<C-w><C-l>', description = 'Move focus to the right window' },
            { '<C-j>', '<C-w><C-j>', description = 'Move focus to the lower window' },
            { '<C-k>', '<C-w><C-k>', description = 'Move focus to the upper window' },
          },
        },
        {
          itemgroup = 'Buffer Controls',
          keymaps = {
            { '<S-h>', '<cmd>BufferLineCyclePrev<cr>', description = 'Move focus to the previous buffer' },
            { '<S-l>', '<cmd>BufferLineCycleNext<cr>', description = 'Move focus to the next buffer' },
            { '<leader>W', '<cmd>bdelete<cr>', description = 'Close Buffer' },
            { '<leader>bo', '<cmd>BufferLineCloseOthers<cr>', description = 'Close [O]ther buffers' },
            { '<leader>bp', '<cmd>BufferLineTogglePin<cr>', description = 'Toggle Buffer [P]in' },
            { '<leader>bP', '<cmd>BufferLinePick<cr>', description = 'Start [P]icking' },
            { '<leader>w', '<cmd>w<cr>', description = '[W]rite to file' },
          },
        },
      },
      autocmds = {
        {
          name = 'happy-highlight-yank',
          clear = true,
          {
            'TextYankPost',
            function()
              vim.highlight.on_yank()
            end,
            description = 'Highlight when yanking text',
          },
        },
      },
    },
  },
  {
    'folke/which-key.nvim',
    event = 'VeryLazy',
    ---@module 'which-key'
    ---@type wk.Opts
    opts = {
      preset = 'helix',
      delay = 200,
      spec = {
        { '<leader>s', group = '[S]earch' },
        { '<leader>l', group = '[L]SP' },
        { '<leader>t', group = '[T]rouble' },
        { '<leader>D', group = 'Quickfix [D]iagnostics' },
        { '<leader>T', group = '[T]erminals' },
        { '<leader>b', group = '[B]uffer' },
        { '<leader>lC', group = '[C]argo' },
        { '<leader>lR', group = '[R]ust' },
      },
    },
  },
}
