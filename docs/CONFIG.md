# Configuration

[Folders](#folders) ⬥ 
[settings.py](#settingspy) ⬥ 
[accounts.json](#accountsjson)


## Folders

On Linux:

- `$XDG_CONFIG_HOME/mirage` if the `XDG_CONFIG_HOME` environment variable is 
  set, else `~/.config/mirage` for config files
- `$XDG_DATA_HOME/mirage` if that variable is set, else `~/.local/share/mirage`
  for user data
- `$XDG_CACHE_HOME/mirage` if that variable is set, else `~/.cache/mirage` 
  for cache data

For Flatpak installations:

- `~/.var/app/io.github.mirukana.mirage/config/mirage` for config files
- `~/.var/app/io.github.mirukana.mirage/data/mirage` for user data
- `~/.var/app/io.github.mirukana.mirage/cache/mirage` for cache data

These locations can be overriden with environment variables, see 
`mirage --help`.  
The user data folder contains saved encryption data, interface states and
[themes](THEMING.md), while the cache contains downloaded files and thumbnails.


## settings.py

A file written in the [PCN format](PCN.md), located in the 
[config folder](#folders), which is manually created by the user to configure 
the application's behavior.

The default `settings.py`, used when no user-written file exists, documents all 
the possible options and can be found at:

- [`src/config/settings.py`][1] in this repository
- `/usr/local/share/examples/mirage/settings.py` or 
  `/usr/share/examples/mirage/settings.py` on Linux installations
- `~/.local/share/flatpak/app/io.github.mirukana.mirage/current/active/files/share/examples/mirage/settings.py` for per-user Flatpak installations
- `/var/lib/flatpak/app/io.github.mirukana.mirage/current/active/files/share/examples/mirage/settings.py` for system-wide Flatpak installations

Rather than copying the entire default file, it is recommended to 
[`include`](PCN.md#including-built-in-files) it and only add the settings 
you want to override.
For example, a user settings file that disables kinetic scrolling, 
sets a different theme, and changes some keybinds could look like this:

```python3
self.include_builtin("config/settings.py")

class General:
    theme: str = "Glass.qpl"

class Scrolling:
    kinetic: bool = False  # Has issues on trackpad

class Keys:
    # The default ctrl+= doesn't work on some keyboard layouts
    reset_zoom = ["Ctrl+Backspace", "Ctrl+="]

    class Messages:
        open_links_files            = ["Ctrl+Shift+O"]
        open_links_files_externally = ["Ctrl+O"]
```

When this file is saved while the application is running, the settings will
automatically be reloaded, except for some options which require a restart.
The default `settings.py` indicates which options require a restart.

You can also manually trigger a reload by updating the file's last change 
timestamp, e.g. with the `touch` command:

```sh
touch ~/.config/mirage/settings.py
```

[1]: https://github.com/mirukana/mirage/tree/master/src/config/settings.py


## accounts.json

This JSON file, located in the [config folder](#folders), is managed by the 
interface and doesn't need to be manually edited, except for changing account 
positions via their `order` key. 
The `order` key can be any number. If multiple accounts have the same `order`,
they are sorted lexically by user ID.

This file should never be shared, as anyone obtaining your access tokens will
be able to use your accounts.
Within the application, from the Sessions tab of your account's settings,
access tokens can be revoked by signing out sessions, 
provided you have the account's password.

Example file:

```json
{
    "@user_id:example.org": {
        "device_id": "ABCDEFGHIJ",
        "enabled": true,
        "homeserver": "https://example.org",
        "order": 0,
        "presence": "online",
        "status_msg": "",
        "token": "<a long access token>"
    },
    "@account_2:example.org": {
        "device_id": "KLMNOPQRST",
        "enabled": true,
        "homeserver": "https://example.org",
        "order": 1,
        "presence": "invisible",
        "status_msg": "",
        "token": "<a long access token>"
    }
}
```
