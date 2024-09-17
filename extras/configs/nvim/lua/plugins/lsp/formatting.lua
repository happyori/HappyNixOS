---@module 'lazy'
---@type LazySpec
return {
  'stevearc/conform.nvim',
  event = 'VeryLazy',
  opts = {
    formatters_by_ft = {
      lua = { 'stylua' },
      rust = { 'rustfmt', lsp_format = 'fallback' },
      javascript = { 'prettierd', stop_after_first = true },
      typescript = { 'prettierd', stop_after_first = true },
      nix = { 'nixpkgs-fmt' },
    },
    format_on_save = {
      timeout_ms = 500,
      lsp_format = 'fallback',
    },
  },
}
