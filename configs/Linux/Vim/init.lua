vim.api.nvim_command('set runtimepath^=~/.vim runtimepath+=~/.vim/after')
vim.api.nvim_command('let &packpath = &runtimepath')
vim.api.nvim_command('source ~/.vimrc')

local lsp_zero = require('lsp-zero')
lsp_zero.on_attach(function(client, bufnr)
  lsp_zero.default_keymaps({buffer = bufnr})
end)
-- show most severe errors on top
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics, {
        severity_sort = true
    }
)
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
  }
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
