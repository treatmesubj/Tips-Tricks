-- :h nvim_open_term()
-- :'<,'>ANSI
-- $ rg foo --color always | nvim +ANSI
vim.api.nvim_create_user_command('ANSI', function()
  local b = vim.api.nvim_create_buf(false, true)
  local chan = vim.api.nvim_open_term(b, {})
  vim.api.nvim_chan_send(
    chan,
    table.concat(vim.api.nvim_buf_get_lines(0, 0, -1, false), '\n')
  )
  vim.api.nvim_win_set_buf(0, b)
end, { desc = 'Highlights ANSI termcodes in curbuf' })
