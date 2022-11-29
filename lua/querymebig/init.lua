
local M = {}

local output_tmpfile = nil

M.run_bq = function()
  local input_bufnr = vim.api.nvim_get_current_buf()

  if output_tmpfile == nil then
    output_tmpfile = os.tmpname()
  end

  local buf_has_window_opened = function(buf_number)
    for _, win in ipairs(vim.api.nvim_list_wins()) do
      local buf = vim.api.nvim_win_get_buf(win)
      if tonumber(buf_number) == tonumber(buf) then
        return true
      end
    end
  end

  -- TODO: maybe also a condition to not do this everytime
  local output_bufnr = vim.fn.bufadd(output_tmpfile)

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
        if not buf_has_window_opened(output_bufnr) then
          vim.api.nvim_exec("belowright sb " .. output_bufnr, false)
        end
        vim.api.nvim_buf_set_lines(output_bufnr, 0, -1, false, data)
        vim.api.nvim_exec("echon", false)
      end
    end,
  })


end


return M
