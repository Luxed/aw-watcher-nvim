aw-watcher-nvim
===============

### Dependencies

- `curl`
- `git` (Optional, only if `aw_branch` is true)

### Configuration

Even though this is a Neovim only version, its configuration is still fully backwards compatible with the [vim version](https://github.com/ActivityWatch/aw-watcher-vim).

| Variable Name        | Description                                   | Default Value |
|----------------------|-----------------------------------------------|---------------|
| `g:aw_autostart`     | Autostart the watcher                         | `true`        |
| `g:aw_autocommands`  | Create the watcher's required autocommands    | `true`        |
| `g:aw_user_commands` | Create user commands                          | `true`        |
| `g:aw_apiurl_host`   | Sets the _host_ of the Api Url                | `127.0.0.1`   |
| `g:aw_apiurl_port`   | Sets the _port_ of the Api Url                | `5600`        |
| `g:aw_api_timeout`   | Sets the _timeout_ seconds of the Api request | `2`           |
| `g:aw_hostname`      | Overrides the hostname                        | `hostname()`  |
| `g:aw_branch`        | Send the current git branch in the payload    | `false`       |

### Statusline example

#### [nvim-lualine](https://github.com/nvim-lualine/lualine.nvim)

![aw statusline enabled](https://user-images.githubusercontent.com/10234894/202309873-a12ed3b9-7c18-434f-8589-ba1be4990d47.png)
![aw statusline disabled](https://user-images.githubusercontent.com/10234894/202309900-2550b108-714f-4aeb-8c58-9b638ce1c127.png)

~~~lua
local aw_section = {
  function()
    return require('aw_watcher').is_connected() and '祥' or '精'
  end,
  cond = function()
    local has_aw, _ = pcall(require, 'aw_watcher')
    return has_aw
  end
}
~~~

To make this "section" work, see the lualine documentation [here](https://github.com/nvim-lualine/lualine.nvim#usage-and-customization).  
To have the same configuration as in the pictures, do the following:

~~~lua
require('lualine').setup({
  sections = {
    lualine_x = {
      'encoding',
      'fileformat',
      'filetype',
      aw_section,
    }
  },
})
~~~

You will also need a [nerd-font](https://www.nerdfonts.com/) patched font.
