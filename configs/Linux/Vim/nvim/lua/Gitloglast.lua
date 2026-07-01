local function results_pane(output)
  vim.opt_local.winbar = nil
  local new_buf = vim.api.nvim_create_buf(true, false)
  if output.code == 0 then -- results data
    vim.api.nvim_set_option_value("ft", "diff", { buf = new_buf})
    vim.api.nvim_buf_set_lines(new_buf, 0, -1, false, vim.fn.split(output.stdout, "\n"))
  else -- error
    vim.api.nvim_buf_set_lines(new_buf, 0, -1, false,
      vim.fn.split(tostring(output.code) .. ": " .. output.stderr, "\n")
    )
  end

  -- resize pane
  local line_count = vim.api.nvim_buf_line_count(new_buf)
  local height = nil
  if line_count < 20 then
    height = line_count + 1
  else
    height = 20
  end
  local win = vim.api.nvim_open_win(new_buf, true, {
    split='above',
    height=height,
  })

end

local function gitloglast()
  local rel_file = vim.fn.expand("%:.")
  local current_line = vim.api.nvim_win_get_cursor(0)[1]

  local cmd = { "git", "log", "-1", '--pretty=%h %>(10)%ad (%cr) %aN%d %s',
    "--date=short", "-L", current_line .. "," .. current_line .. ":" .. rel_file }
  vim.opt_local.winbar = "git log -1 ..."

  local output = vim.system(cmd, {text=true}, vim.schedule_wrap(results_pane))
end

-- :'<,'>Gitloglast
vim.api.nvim_create_user_command("Gitloglast", gitloglast, {
  range = false,
  bang = false,
})
