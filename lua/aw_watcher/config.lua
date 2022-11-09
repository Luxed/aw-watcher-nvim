local M = {}

function M.get()
  return {
    autostart = vim.g.aw_autostart or true,

    create_autocommands = vim.g.aw_autocommands or true,
    create_user_commands = vim.g.aw_user_commands or true,

    host = vim.g.aw_apiurl_host or '127.0.0.1',
    port = vim.g.aw_apiurl_port or '5600',
    timeout = vim.g.aw_api_timeout or 2,
    hostname = vim.g.aw_hostname or vim.fn.hostname(),

    branch = vim.g.aw_branch or false
  }
end

return M
