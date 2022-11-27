--[[

BQ runner
bigqnewquery

* requires two files/buffers
`input.sql` and `output.sql`


]]

local input_bufnr = nil
local output_bufnr = nil

local get_buffers = function()

  for _, buffer in ipairs(vim.split(vim.fn.execute ":buffers! t", "\n")) do
    local match = tonumber(string.match(buffer, "%s*(%d+)"))
    local open_by_lsp = string.match(buffer, "line 0$")

    if match and not open_by_lsp then
      local file = vim.api.nvim_buf_get_name(match)

      if string.match(file, "input.sql") then
        input_bufnr = tonumber(match)
      end

      if string.match(file, "output.sql") then
        output_bufnr = tonumber(match)
      end

    end
  end
end



local run_bq = function()
  get_buffers()
  local query_buf = vim.api.nvim_buf_get_lines(input_bufnr, 0, -1, false)
  local strqbuf = table.concat(query_buf, "\n")
  local cmd = {
    "bq", "query", "--use_legacy_sql=false", strqbuf
  }

  print("running query...")

  vim.fn.jobstart(cmd, {
    stdout_buffered = true,
    on_stdout = function(_, data)
      if data then
        vim.api.nvim_buf_set_lines(output_bufnr, 0, -1, false, data)
      end
    end,
  })
end


run_bq()
