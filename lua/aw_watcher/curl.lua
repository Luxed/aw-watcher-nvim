local M = {}

function M.post(url, body, callback_res)
  local config = require('aw_watcher.config').get()
  local http_response_code = ''

  local command = {
    'curl', '-s', url,
    '-H', 'Content-Type: application/json',
    '-X', 'POST',
    '-d', vim.fn.json_encode(body),
    '-o', '/dev/null',
    '-m', config.timeout,
    '-w', "%{http_code}"
  }

  vim.fn.jobstart(command, {
    detach = true,
    on_stdout = function(_, data, _)
      if data[1] ~= '' then
        http_response_code = data[1]
      end
    end,
    on_exit = function(_, _, _)
      local status_code = tonumber(http_response_code)

      callback_res(status_code)
    end
  })
end

return M
