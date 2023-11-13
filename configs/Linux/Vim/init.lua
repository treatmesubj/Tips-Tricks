-- ~/.config/nvim/init.lua
vim.api.nvim_command('set runtimepath^=~/.vim runtimepath+=~/.vim/after')
vim.api.nvim_command('let &packpath = &runtimepath')
vim.api.nvim_command('source ~/.vimrc')

local lsp_zero = require('lsp-zero')
lsp_zero.on_attach(function(client, bufnr)
  lsp_zero.default_keymaps({buffer = bufnr})

  --if client.server_capabilities.documentSymbolProvider then
  --  require('nvim-navic').attach(client, bufnr)
  --end
end)
-- auto-complete source: words already in buffer
-- https://github.com/hrsh7th/cmp-buffer
local cmp = require('cmp')
local cmp_format = lsp_zero.cmp_format()
cmp.setup({
  sources = {
    {name = 'nvim_lsp'},
    {name = 'buffer'},
  },
  formatting = cmp_format,
})

-- show most severe errors on top
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics, {
        severity_sort = true
    }
)
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
-- https://github.com/python-lsp/python-lsp-server
require('lspconfig').pylsp.setup{
  cmd = {(os.getenv("HOME")..'/.venv_pynvim/bin/pylsp')};
  settings = {
    pylsp = {
      plugins = {
        jedi = {
          environment = (os.getenv("HOME")..'/.venv_pynvim/bin/python')
        }
      }
    }
  },
}
-- https://github.com/nvim-treesitter/nvim-treesitter
require'nvim-treesitter.configs'.setup {
  -- A list of parser names, or "all" (the five listed parsers should always be installed)
  ensure_installed = { "yaml", },
  highlight = {
    enable = false,
    additional_vim_regex_highlighting = false,
  }
}
-- https://github.com/cuducos/yaml.nvim
vim.api.nvim_create_autocmd({ "BufEnter", "CursorMoved" },{
  pattern = { "*.yaml" },
  callback = function()
    vim.opt_local.winbar = require("yaml_nvim").get_yaml_key()
  end,
})
vim.api.nvim_command('hi winbar ctermbg=89')