-- ~/.config/nvim/init.lua
vim.api.nvim_command('set runtimepath^=~/.vim runtimepath+=~/.vim/after')
vim.api.nvim_command('let &packpath = &runtimepath')
vim.api.nvim_command('source ~/.vimrc')

vim.opt.inccommand = "split"

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
-- <Leader>d to show diagnostic (error) message
vim.api.nvim_set_keymap(
  'n', '<Leader>d', ':lua vim.diagnostic.open_float()<CR>',
  { noremap = true, silent = true }
)
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
-- https://github.com/python-lsp/python-lsp-server
require('lspconfig').pylsp.setup {
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
require('nvim-treesitter.configs').setup {
  -- A list of parser names, or "all"
  ensure_installed = { "yaml", "json" },
  highlight = {
    enable = false,
    additional_vim_regex_highlighting = false,
  }
}

vim.api.nvim_create_autocmd({ "BufEnter", "FileType" }, {
  group = vim.api.nvim_create_augroup("bufent_winbar", { clear = true }),
  callback = function(opts)
    if vim.fn.line('$') < 10000 then
      -- https://github.com/cuducos/yaml.nvim
      if vim.bo[opts.buf].filetype == "yaml" then
        vim.api.nvim_create_autocmd({ "CursorMoved" }, {
          group = vim.api.nvim_create_augroup("curs_winbar", { clear = true }),
          callback = function()
            vim.opt_local.winbar = "." .. (require("yaml_nvim").get_yaml_key() or "")
          end,
        })
      -- https://github.com/phelipetls/jsonpath.nvim
      elseif vim.bo[opts.buf].filetype == "json" then
        vim.api.nvim_create_autocmd({ "CursorMoved" }, {
          group = vim.api.nvim_create_augroup("curs_winbar", { clear = true }),
          callback = function()
            vim.opt_local.winbar = "." .. (require("jsonpath").get():sub(2) or "")
          end,
        })
      end
    else
      vim.opt_local.winbar = ""
      vim.api.nvim_create_augroup("curs_winbar", { clear = true })
    end
  end,
})
vim.api.nvim_command('hi winbar ctermbg=89')
-- :Nowinbar
local function nowinbar()
  vim.api.nvim_command('autocmd! curs_winbar')
  vim.opt_local.winbar = ""
end
vim.api.nvim_create_user_command("Nowinbar", nowinbar, {
})

-- Highlight on yank
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  pattern = { '*' },
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
})

-- https://github.com/lukas-reineke/indent-blankline.nvim
vim.cmd('hi RainbowRed ctermfg=88 guifg=#E06C75')
vim.cmd('hi RainbowYellow ctermfg=3 guifg=#E5C07B')
vim.cmd('hi RainbowBlue ctermfg=4 guifg=#61AFEF')
vim.cmd('hi RainbowOrange ctermfg=202 guifg=#D19A66')
vim.cmd('hi RainbowGreen ctermfg=2 guifg=#98C379')
vim.cmd('hi RainbowViolet ctermfg=5 guifg=#C678DD')
vim.cmd('hi RainbowCyan ctermfg=14 guifg=#56B6C2')
local highlite = {
    "RainbowRed",
    "RainbowYellow",
    "RainbowBlue",
    "RainbowOrange",
    "RainbowGreen",
    "RainbowViolet",
    "RainbowCyan",
}
require("ibl").setup({
  indent = { highlight = highlite }
})

-- https://github.com/chentoast/marks.nvim
require('marks').setup {
  default_mappings = true,
  builtin_marks = { ".", "<", ">", "^" },
  cyclic = true,
  force_write_shada = false,
  refresh_interval = 250,
  sign_priority = { lower=10, upper=15, builtin=8, bookmark=20 },
  excluded_filetypes = {},
  excluded_buftypes = {},
  bookmark_0 = {
    sign = "⚑",
    virt_text = "hello world",
    annotate = false,
  },
  mappings = {}
}

-- https://github.com/fei6409/log-highlight.nvim
require('log-highlight').setup {
    extension = 'log',
}

-- ~/.config/nvim/lua/Duckdb.lua
require('Duckdb')


-- ~/.config/nvim/lua/ANSI.lua
require('ANSI')
