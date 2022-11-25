--[[

* read a buffer
* run a `bq` command with the buffer as query
* get output and add it to a buffer


Future
* read a visual part of a buffer
  * format SQL
  * add jinja and df templates
    * identify template type
    * save templates into some temp file


]]

local upbufnr = 105
local dwbufnr = 50


local qbuf = vim.api.nvim_buf_get_lines(upbufnr, 0, -1, false)
local strqbuf = table.concat(qbuf, "\n")
local cmd = {
  "bq", "query", "--use_legacy_sql=false", strqbuf
}
vim.fn.jobstart(cmd, {
  stdout_buffered = true,
  on_stdout = function(_, data)
    if data then
      vim.api.nvim_buf_set_lines(dwbufnr, 0, -1, false, data)
    end
  end,
  on_stderr = function(_, data)
    if data then
      vim.api.nvim_buf_set_lines(dwbufnr, 0, -1, false, "deu ruim")
    end
  end,
})

-- runs a job
--[[ vim.fn.jobstart()

get data from stdout
write it to a temp buffer
vim.api.nvim_buf_set_lines ]]
