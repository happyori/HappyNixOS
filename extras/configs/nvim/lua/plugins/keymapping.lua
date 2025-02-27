---@alias KeyOpts vim.api.keyset.keymap
---@alias LegendKey { [0]: string, [1]: string|fun(), description?: string, mode?: string|string[], opts?: KeyOpts }
---@alias LegendItemGroup { itemgroup: string, icon?: string, description?: string, keymaps: LegendKey[] }
---@alias LegendKeys (LegendItemGroup|LegendKey)[]

---@module 'lazy'
---@type LazySpec
return {
  {
    'mrjones2014/legendary.nvim',
    version = '*',
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
        { '<Esc><Esc>', '<C-\\><C-n>', description = 'Exit terminal mode', mode = 't' },
        { '<C-s>', '<cmd>w<cr><Esc>', description = '[W]rite to file', mode = { 'n', 'i' } },
        { '<leader>uc', '<cmd>NoNeckPain<cr>', description = '[C]enter UI' },
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
            { '<leader>bv', '<cmd>vsplit<cr>', description = '[V]ertical split' },
            { '<leader>bh', '<cmd>split<cr>', description = '[H]orizontal split' },
            { '<leader>bo', '<cmd>BufferLineCloseOthers<cr>', description = 'Close [O]ther buffers' },
            { '<leader>bp', '<cmd>BufferLineTogglePin<cr>', description = 'Toggle Buffer [P]in' },
            { '<leader>bP', '<cmd>BufferLinePick<cr>', description = 'Start [P]icking' },
            { '<leader>w', '<cmd>w<cr>', description = '[W]rite to file' },
          },
        },
        {
          itemgroup = 'Git commands',
          keymaps = {
            { '<leader>gh', '<cmd>Gitsigns preview_hunk_inline<cr>', description = '|Preview [H]unk' },
            { '<leader>gn', '<cmd>Neogit kind=vsplit<cr>', description = '|Open [N]eogit' },
            { '<leader>gc', '<cmd>Neogit commit kind=floating<cr>', description = '|Open [C]ommits' },
            { '<leader>gb', '<cmd>Neogit branch kind=vsplit<cr>', description = '|Open [B]raches' },
          },
        },
        {
          itemgroup = 'Lazy commands',
          keymaps = {
            { '<leader>Lu', '<cmd>Lazy sync<cr>', description = '[L]azy [U]pdate' },
            { '<leader>Lh', '<cmd>Lazy home<cr>', description = '[L]azy [H]ome' },
          },
        },
      },
      sort = {
        frecency = false,
      },
      autocmds = {
        {
          name = 'happy_highlight_on_yank',
          clear = true,
          {
            'TextYankPost',
            function()
              vim.highlight.on_yank { higroup = 'Visual' }
            end,
            description = 'Highlight when yanking text',
          },
        },
      },
      commands = {},
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
        { '<leader>d', group = '[D]ignostics' },
        { '<leader>T', group = '[T]erminals' },
        { '<leader>b', group = '[B]uffer' },
        { '<leader>lC', group = '[C]argo' },
        { '<leader>lR', group = '[R]ust' },
        { '<leader>u', group = '[U]I' },
        { '<leader>g', group = '[G]it' },
        { '<leader>L', group = '[L]azy' },
        { '<leader>n', group = '[N]eorg' },
      },
    },
  },
}
