-- inspired by
-- https://gist.github.com/Leenuus/7a2ea47b88bfe16430b42e4e48122718
-- https://gist.github.com/romainl/eae0a260ab9c135390c30cd370c20cd7

local function duckdb(args)
  local range = args.range
  local line1 = args.line1 - 1
  local line2 = args.line2
  line2 = line1 == line2 and line1 + 1 or line2
  local stdin = vim.api.nvim_buf_get_lines(0, line1, line2, false)

  if range ~= 0 then
    local output = vim.system({'bash', '-c', 'duckdb -csv'}, {text=true, stdin=stdin}):wait()
    local new_buf = vim.api.nvim_create_buf(true, false)
    vim.api.nvim_buf_set_lines(new_buf, 0, -1, false, vim.fn.split(output.stdout, "\n"))
    vim.api.nvim_set_option_value("ft", "csv", { buf = new_buf})
    local win = vim.api.nvim_open_win(new_buf, true, {vertical = false,})
  else
    print('no stdin')
  end
end

vim.api.nvim_create_user_command("Duckdb", duckdb, {
  range = true,
  bang = true,
})