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
