# Auth-Switcher

## Description

It's a small bash script to manage your composer _auth.json_ files.


## Commands

* `auth-switcher list` - provides a list of files with credentials

* `auth-switcher editor <editor>` - use this command to configure the editor to edit files with credentials

* `auth-switcher new <filename>` - use this command to create a file with credentials

* `auth-switcher edit <filename>` - use this command to edit a file with credentials

* `auth-switcher remove <filename>` - use this command to remove a file with credentials

* `auth-switcher use <filename>` - use this command to copy a file with credentials to the current directory,
If you use the --global option, a file with credentials will be copied to the Composer config directory, e.g., `auth-switcher use <filename> --global`

* `auth-switcher backup` - use this command to copy the _auth.json_ file from the current directory to the **auth-switcher** storage directory,
If you use the **--global** option, the _auth.json_ file from the Composer config directory will be copied to the **auth-switcher** storage directory, e.g., `auth-switcher backup --global`

## How to install

* `curl -LJO https://github.com/BaDos/auth-switcher/releases/download/1.0.0/auth-switcher.sh`

* `chmod +x auth-switcher.sh`

* `sudo mv auth-switcher.sh /usr/local/bin/auth-switcher`

## Requirements

Installed [Composer](https://getcomposer.org/download/).
