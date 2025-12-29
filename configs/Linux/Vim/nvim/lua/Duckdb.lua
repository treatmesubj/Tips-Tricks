-- inspired by
-- https://gist.github.com/Leenuus/7a2ea47b88bfe16430b42e4e48122718
-- https://gist.github.com/romainl/eae0a260ab9c135390c30cd370c20cd7

local function results_pane(output)
  vim.opt_local.winbar = nil
  local new_buf = vim.api.nvim_create_buf(true, false)
  if output.code == 0 then -- results data
    vim.api.nvim_set_option_value("ft", "csv", { buf = new_buf})
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

  if output.code == 0 then
    vim.cmd "CSVInit"  -- chrisbra/csv.vim
  end

end

local function duckdb(args)
  local range = args.range
  local line1 = args.line1 - 1
  local line2 = args.line2
  line2 = line1 == line2 and line1 + 1 or line2
  local stdin = vim.api.nvim_buf_get_lines(0, line1, line2, false)

  if range ~= 0 then
    vim.opt_local.winbar = "Duckdb: " .. table.concat(stdin, " ") .. "%="
    -- log sql to tmp-file
    local file, err = io.open("/tmp/duckdb-nvim.sql", "a")
    file:write(table.concat(stdin, "\n") .. "\n/* --- */\n\n")
    file:close()
    local output = vim.system({'bash', '-c', 'duckdb -csv'}, {text=true, stdin=stdin}, vim.schedule_wrap(results_pane))
  else
    print('no stdin')
  end
end

-- :'<,'>Duckdb
vim.api.nvim_create_user_command("Duckdb", duckdb, {
  range = true,
  bang = true,
})
