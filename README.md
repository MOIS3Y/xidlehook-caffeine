# xidlehook-caffeine
Script to suspend the xidlehook process and then start it again


## How it work ?
The script finds the xidlehook process using the psutil library.
Depending on the status of the process, returns an icon.
If the script is run with the --notify flag, 
a notification will also be generated and sent via dunstify.

If the process is not found, the script will return an icon indicating this
(an empty crossed out cup of coffee)


## Dependencies:
- xidlehook
- python ^3.10
- python-psutil
- dunst (optional)


## Usage:

```sh
usage: xidlehook-caffeine [--help] [--toggle] [--notify] [--version]

Caffeine app for xidlehook

options:
  --help,    -h   show this help message and exit
  --toggle,  -t   toggle xidlehook status
  --notify,  -n   send notification message
  --version, -v   show version
```

## Examples:

```sh
xidlehook-caffeine                    # return status
xidlehook-caffeine --toggle           # switch start/stop
xidlehook-caffeine --toggle --notify  # switch start/stop and send notification
```
