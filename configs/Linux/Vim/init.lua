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
-- keybinding: show all diagnostics on current line in floating window
-- <Leader>d to show diagnostic message
vim.api.nvim_set_keymap(
  'n', '<Leader>d', ':lua vim.diagnostic.open_float()<CR>', 
  { noremap = true, silent = true }
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
  ensure_installed = { "yaml", "json" },
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
-- https://github.com/phelipetls/jsonpath.nvim
vim.api.nvim_create_autocmd({ "BufEnter", "CursorMoved" },{
  pattern = { "*.json" },
  callback = function()
    vim.opt_local.winbar = require("jsonpath").get()
  end,
})
vim.api.nvim_command('hi winbar ctermbg=89')
-- Highlight on yank
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  pattern = { '*' },
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
})
-- https://github.com/mrquantumcodes/bufferchad.nvim
require("bufferchad").setup({
  mapping = "<leader>bb", -- Map any key, or set to NONE to disable key mapping
  mark_mapping = "<leader>bm", -- The keybinding to display just the marked buffers
  order = "LAST_USED_UP", -- LAST_USED_UP (default)/ASCENDING/DESCENDING/REGULAR
  style = "default", -- default, modern (requires dressing.nvim and nui.nvim), telescope (requires telescope.nvim)
  close_mapping = "<Esc><Esc>", -- only for the default style window. 
})

-- https://github.com/lukas-reineke/indent-blankline.nvim
vim.cmd('hi RainbowRed ctermfg=1 guifg=#E06C75')
vim.cmd('hi RainbowYellow ctermfg=3 guifg=#E5C07B')
vim.cmd('hi RainbowBlue ctermfg=4 guifg=#61AFEF')
vim.cmd('hi RainbowOrange ctermfg=202 guifg=#D19A66')
vim.cmd('hi RainbowGreen ctermfg=2 guifg=#98C379')
vim.cmd('hi RainbowViolet ctermfg=5 guifg=#C678DD')
vim.cmd('hi RainbowCyan ctermfg=14 guifg=#56B6C2')
local highlite = {
    "RainbowRed",
    "RainbowOrange",
    "RainbowYellow",
    "RainbowGreen",
    "RainbowBlue",
    "RainbowViolet",
    "RainbowCyan",
}
require("ibl").setup({
  indent = { highlight = highlite }
})
