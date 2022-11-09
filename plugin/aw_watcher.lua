local config = require('aw_watcher.config').get()

if config.create_autocommands then
  local aw = require('aw_watcher')
  local aw_group = vim.api.nvim_create_augroup('ActivityWatch', {clear = true})
  vim.api.nvim_create_autocmd({'VimEnter'}, {
    group = aw_group,
    pattern = '*',
    callback = function() aw.start() end
  })
  vim.api.nvim_create_autocmd({'BufEnter', 'CursorMoved', 'CursorMovedI'}, {
    group = aw_group,
    pattern = '*',
    callback = function() aw.heartbeat() end
  })
  vim.api.nvim_create_autocmd({'CmdlineEnter', 'CmdlineChanged'}, {
    group = aw_group,
    pattern = '*',
    callback = function() aw.heartbeat() end
  })
end

if config.create_user_commands then
  local aw = require('aw_watcher')
  vim.api.nvim_create_user_command('AWHeartbeat', function() aw.heartbeat() end, {})
  vim.api.nvim_create_user_command('AWStart', function() aw.start() end, {})
  vim.api.nvim_create_user_command('AWStop', function() aw.stop() end, {})
  vim.api.nvim_create_user_command('AWStatus', function() aw.status() end, {})
end

if config.autostart then
  require('aw_watcher').start()
end
