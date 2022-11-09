local connected = false

-- TODO: getting the branch with every heartbeat seems a bit excessive. But at the same time, I have no idea when the branch is going to change. Maybe some integration with other plugins could be used instead?
-- Or as an example, the lualine plugin finds the ".git/HEAD" file and parses it to know the current branch
local function get_current_git_branch(callback)
  local config = require('aw_watcher.config').get()

  if not config.branch then
    callback(nil)
    return
  end

  local git_branch = ''

  vim.fn.jobstart({'git', 'branch', '--show-current', '--format="%(refname)"'}, {
    detach = true,
    on_stdout = function(jobid, data, event)
      if data[1] ~= '' then
        git_branch = data[1]
      end
    end,
    on_exit = function(jobid, code, eventtype)
      if code ~= 0 then
        git_branch = ''
      end

      callback(git_branch)
    end
  })
end

local function make_bucket_name()
  local config = require('aw_watcher.config').get()
  return string.format('aw-watcher-nvim_%s', config.hostname)
end

local function make_base_apiurl()
  local config = require('aw_watcher.config').get()
  return string.format('http://%s:%s/api/0', config.host, config.port)
end

local function make_bucket_apiurl()
  return string.format('%s/buckets/%s', make_base_apiurl(), make_bucket_name())
end

local function make_heartbeat_apiurl()
  return string.format('%s/heartbeat?pulsetime=30', make_bucket_apiurl())
end

local function handle_post_res(res)
  if res == 0 then
    vim.notify('aw-watcher-nvim: Failed to connect to aw-server, logging will be disabled. You can retry to connect with :AWStart', vim.log.levels.ERROR)
    connected = false
  elseif res >= 100 and res < 300 or res == 304 then
    connected = true
  else
    vim.notify(string.format('aw-watcher-nvim: aw-server did not accept our request with status code %d. See aw-server logs for reason or stop aw-watcher-vim with :AWStop', res), vim.log.levels.ERROR)
  end
end

local function create_bucket()
  local config = require('aw_watcher.config').get()
  local body = {
    name = make_bucket_name(),
    hostname = config.hostname,
    client = 'aw-watcher-nvim',
    type = 'app.editor.activity',
  }

  require('aw_watcher.curl').post(make_bucket_apiurl(), body, handle_post_res)
end

local last_file = ''
local last_heartbeat = vim.fn.localtime()
local function heartbeat()
  if not connected then
    return
  end

  local localtime = vim.fn.localtime()
  local timestamp = vim.fn.strftime('%FT%H:%M:%S%z')
  local file = vim.fn.expand('%p')
  local language = vim.bo.filetype
  -- TODO: Current project could also be determined using the current LSP project path.
  -- Or it could also be the closest git root.
  local project = vim.fn.getcwd()

  if file ~= last_file or (localtime - last_heartbeat) > 1 then
    get_current_git_branch(function(branch)
      local body = {
        duration = 0,
        timestamp = timestamp,
        data = {
          file = file,
          language = language,
          project = project,
          branch = branch
        }
      }

      require('aw_watcher.curl').post(make_heartbeat_apiurl(), body, handle_post_res)
      last_file = file
      last_heartbeat = localtime
    end)
  end
end

local function start()
  create_bucket()
end

local function stop()
  connected = false
end

local function status()
  vim.notify(string.format('aw-watcher-nvim running: %s', connected))
end

return {
  heartbeat = heartbeat,
  start = start,
  stop = stop,
  status = status,
  statusline = {
    status = function()
      return connected and '祥' or '精'
    end,
    is_available = function() return connected end
  },
}
