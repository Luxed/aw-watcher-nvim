local M = {}

local function get_or_default(val, default)
  if val ~= nil then
    return val
  else
    return default
  end
end

function M.get()
  local config = {
    autostart = get_or_default(vim.g.aw_autostart, true),

    create_autocommands = get_or_default(vim.g.aw_autocommands, true),
    create_user_commands = get_or_default(vim.g.aw_user_commands, true),

    host = get_or_default(vim.g.aw_apiurl_host, '127.0.0.1'),
    port = get_or_default(vim.g.aw_apiurl_port, '5600'),
    timeout = get_or_default(vim.g.aw_api_timeout, 2),
    hostname = get_or_default(vim.g.aw_hostname, vim.fn.hostname()),
    pulsetime = get_or_default(vim.g.aw_pulsetime_secs, 30),

    branch = get_or_default(vim.g.aw_branch, false),
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
