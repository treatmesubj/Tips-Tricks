-- ~/.config/nvim/init.lua
vim.api.nvim_command('set runtimepath^=~/.vim runtimepath+=~/.vim/after')
vim.api.nvim_command('let &packpath = &runtimepath')
vim.api.nvim_command('source ~/.vimrc')

vim.opt.inccommand = "split"

-- Diagnositcs virtual-text
vim.diagnostic.config({
  virtual_text = {
    prefix = '🤮',
    virt_text_pos = 'right_align'
  },
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
})
-- Diagnostics keybinding for float-window
vim.api.nvim_set_keymap(
  'n', '<Leader>d', ':lua vim.diagnostic.open_float()<CR>',
  { noremap = true, silent = true }
)
-- https://github.com/python-lsp/python-lsp-server
-- https://github.com/python-lsp/python-lsp-server/blob/develop/CONFIGURATION.md
-- https://github.com/davidhalter/jedi
-- ~/.config/pycodestyle
vim.lsp.config('pylsp', {
  filetypes = { 'python' },
  cmd = {(os.getenv("HOME")..'/.venv/bin/pylsp')};
  settings = {
    pylsp = {
      plugins = {
        jedi = {
          environment = (os.getenv("HOME")..'/.venv/bin/python'),
          auto_import_modules = {},
        },
        jedi_completion = {
          enabled = true,
          include_params = true,
          include_class_objects = false,
          include_function_objects = false,
          fuzzy = false,
          eager = false,
        },
        jedi_definition = {
          follow_imports = true,
          follow_builtin_imports = true,
          follow_builtin_definitions = true,
        },
        jedi_hover = { enabled = true },
        jedi_references = { enabled = true },
        jedi_signature_help = { enabled = true },
        jedi_symbols = { enabled = true },
        jedi_type_definition = { enabled = true }
      }
    }
  }
})
vim.lsp.enable('pylsp')
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#yamlls
-- https://github.com/redhat-developer/yaml-language-serve
-- npm install -g yaml-language-server@latest
vim.lsp.config('yamlls', {
  filetypes = { 'yaml' },
  cmd = { "yaml-language-server", "--stdio" },
  settings = {
    yaml = {
      validate = true,
      completion = true,
      format = {
          enable = true,
      },
      root_markers = { ".git" },
      --  yq '.spec.versions[0].schema.openAPIV3Schema' my-CRD.yaml -o json > my-CRD-schema.json
      -- schemas = {
      --   ["kubernetes"] = "/**",
      -- },
      filetypes = { 'yaml', 'yml' },
    },
  }
})
vim.lsp.enable('yamlls')

vim.o.autocomplete = true
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(ev)
    local client = assert(vim.lsp.get_client_by_id(ev.data.client_id))
    if client:supports_method('textDocument/completion') then
      vim.lsp.completion.enable(true, client.id, ev.buf, {autotrigger = true})
      vim.keymap.set('n', 'K', vim.lsp.buf.hover, { buffer = ev.buf })
    end
  end,
})
vim.opt.complete:append('o')
vim.opt.completeopt = { 'menuone', 'noselect' }

-- https://github.com/nvim-treesitter/nvim-treesitter
require('nvim-treesitter').install { "yaml", "json" }
-- use old-school vim regex preservim/vim-markdown
vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    vim.treesitter.stop()
  end,
})

vim.api.nvim_create_autocmd({ "BufEnter", "FileType" }, {
  group = vim.api.nvim_create_augroup("bufent_winbar", { clear = true }),
  callback = function(opts)
    if vim.fn.line('$') < 10000 then
      -- https://github.com/cuducos/yaml.nvim
      if vim.bo[opts.buf].filetype == "yaml" then
        vim.opt_local.winbar = "." .. (require("yaml_nvim").get_yaml_key() or "")
        vim.api.nvim_create_autocmd({ "CursorMoved" }, {
          group = vim.api.nvim_create_augroup("curs_winbar", { clear = true }),
          callback = function()
            vim.opt_local.winbar = "." .. (require("yaml_nvim").get_yaml_key() or "")
          end,
        })
      -- https://github.com/phelipetls/jsonpath.nvim
      elseif vim.bo[opts.buf].filetype == "json" then
        vim.opt_local.winbar = "." .. (require("jsonpath").get():sub(2) or "")
        vim.api.nvim_create_autocmd({ "CursorMoved" }, {
          group = vim.api.nvim_create_augroup("curs_winbar", { clear = true }),
          callback = function()
            vim.opt_local.winbar = "." .. (require("jsonpath").get():sub(2) or "")
          end,
        })
      else
        vim.opt_local.winbar = ""
        vim.api.nvim_create_augroup("curs_winbar", { clear = true })
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
local highlight = {
    "RainbowRed",
    "RainbowYellow",
    "RainbowBlue",
    "RainbowOrange",
    "RainbowGreen",
    "RainbowViolet",
    "RainbowCyan",
}

local hooks = require "ibl.hooks"
-- create the highlight groups in the highlight setup hook, so they are reset
-- every time the colorscheme changes
hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
    vim.api.nvim_set_hl(0, "RainbowRed", { ctermfg = 88, fg = "#E06C75" })
    vim.api.nvim_set_hl(0, "RainbowYellow", { ctermfg = 3, fg = "#E5C07B" })
    vim.api.nvim_set_hl(0, "RainbowBlue", { ctermfg = 4, fg = "#61AFEF" })
    vim.api.nvim_set_hl(0, "RainbowOrange", { ctermfg = 202, fg = "#D19A66" })
    vim.api.nvim_set_hl(0, "RainbowGreen", { ctermfg = 2, fg = "#98C379" })
    vim.api.nvim_set_hl(0, "RainbowViolet", { ctermfg = 5, fg = "#C678DD" })
    vim.api.nvim_set_hl(0, "RainbowCyan", { ctermfg = 14, fg = "#56B6C2" })
end)
require("ibl").setup { indent = { highlight = highlight } }

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
