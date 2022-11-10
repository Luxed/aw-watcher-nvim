local M = {}

function M.get()
  local config = {
    autostart = vim.g.aw_autostart or true,

    create_autocommands = vim.g.aw_autocommands or true,
    create_user_commands = vim.g.aw_user_commands or true,

    host = vim.g.aw_apiurl_host or '127.0.0.1',
    port = vim.g.aw_apiurl_port or '5600',
    timeout = vim.g.aw_api_timeout or 2,
    hostname = vim.g.aw_hostname or vim.fn.hostname(),
    pulsetime = vim.g.aw_pulsetime_secs or 30,

    branch = vim.g.aw_branch or false,
  }

  config.bucket_name = string.format('aw-watcher-nvim_%s', config.hostname)

  local url_base = string.format('http://%s:%s/api/0', config.host, config.port)
  local url_bucket = string.format('%s/buckets/%s', url_base, config.bucket_name)
  config.urls = {
    bucket = url_bucket,
    heartbeat = string.format('%s/heartbeat?pulsetime=%d', url_bucket, config.pulsetime)
  }

  return config
end

return M
