return {
  'neovim/nvim-lspconfig',
  lazy = false,
  dependencies = {
    { 'williamboman/mason.nvim', config = true },
    'williamboman/mason-lspconfig.nvim',
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    { 'j-hui/fidget.nvim', opts = {} },
    'hrsh7th/cmp-nvim-lsp',
  },
  config = function()
    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('happy-lsp-attach', { clear = true }),
      callback = function(event)
        local legend = require 'legendary'
        local toolbox = require 'legendary.toolbox'
        ---@type LegendKeys
        local keys = {}

        local builtins = setmetatable({}, {
          __index = function(_, k)
            return toolbox.lazy_required_fn('telescope.builtin', k)
          end,
        })

        keys = {
          {
            itemgroup = '[L]SP',
            description = 'LSP related commands',
            keymaps = {
              { 'gd', builtins.lsp_definitions, description = '[G]oto [D]efinitions' },
              { 'gr', builtins.lsp_references, description = '[G]oto [R]eferences' },
              { 'gI', builtins.lsp_implementations, description = '[G]oto [I]mplementations' },
              { '<leader>lt', builtins.lsp_type_definitions, description = '[T]ype Definition' },
              { '<leader>ld', builtins.lsp_document_symbols, description = '[D]ocument Symbols' },
              { '<leader>lw', builtins.lsp_workspace_symbols, description = '[W]orkspace Symbols' },
              { '<leader>lr', vim.lsp.buf.rename, description = '[R]ename' },
              { '<leader>la', vim.lsp.buf.code_action, description = 'Code [A]ction' },
              { 'gD', vim.lsp.buf.declaration, description = '[G]oto [D]eclaration' },
            },
          },
        }

        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
          legend.autocmds {
            {
              name = 'happy-lsp-highlight',
              clear = false,
              {
                { 'CursorHold', 'CursorMovedI' },
                vim.lsp.buf.clear_references,
                opts = { buffer = event.buf },
              },
              {
                { 'CursorMoved', 'CursorMovedI' },
                vim.lsp.buf.clear_references,
                opts = { buffer = event.buf },
              },
            },
            {
              name = 'happy-lsp-detach',
              clear = true,
              {
                'LspDetach',
                function(subevent)
                  vim.lsp.buf.clear_references()
                  vim.api.nvim_clear_autocmds { group = 'happy-lsp-highlight', buffer = subevent.buf }
                end,
              },
            },
          }

          if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
            vim.list_extend(keys[1].keymaps, {
              {
                '<leader>lh',
                function()
                  vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
                end,
                description = 'Toggle Inlay [H]int',
              },
            })
          end
          legend.keymaps(keys)
        end
      end,
    })

    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

    local servers = {
      lua_ls = {
        settings = {
          Lua = {
            completion = {
              callSnippet = 'Replace',
            },
          },
        },
      },
      nixd = {
        settings = {
          nixd = {
            nixpkgs = {
              expr = 'import <nixpkgs> { }',
            },
            formatting = {
              command = { 'nixpkgs-fmt' },
            },
            options = {
              nixos = {
                expr = '(builtins.getFlake "/home/happy/.config/nixos").nixosConfigurations.happypc.options',
              },
              homeManager = {
                expr = '(builtins.getFlake "/home/happy/.config/nixos").nixosConfigurations.happypc.options.home-manager.users.value.happy',
              },
            },
          },
        },
      },
      zls = {
        settings = {
          zls = {
            inlay_hints_hide_redundant_param_names = true,
            highlight_global_var_declarations = true,
          },
        },
      },
      omnisharp = {
        cmd = { 'OmniSharp' },
        settings = {
          FormattingOptions = {
            EnableEditorConfigSupport = true,
            OrganizeImports = true,
          },
        },
      },
    }

    local mason_install_exclude = {
      'nixd',
      'zls',
      'omnisharp',
    }

    require('mason').setup()
    local ensure_installed = {
      'stylua',
    }

    for key, server in pairs(servers) do
      if not vim.list_contains(mason_install_exclude, key) then
        vim.list_extend(ensure_installed, { key })
      else
        require('lspconfig')[key].setup(server)
      end
    end

    require('mason-tool-installer').setup { ensure_installed = ensure_installed }

    local mason_exclude_setup = {
      'rust_analyzer',
    }
    require('mason-lspconfig').setup {
      handlers = {
        function(server_name)
          if vim.list_contains(mason_exclude_setup, server_name) then return true end
          if server_name == 'tsserver' then server_name = 'ts_ls' end
          local server = servers[server_name] or {}
          server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
          require('lspconfig')[server_name].setup(server)
        end,
      },
    }
  end,
}
