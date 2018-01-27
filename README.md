# dotbash

## To get started
1. `echo MyMachineName > .hostname`
1. `curl -H 'Cache-Control: no-cache' https://raw.githubusercontent.com/henrylawson/dotbash/master/go > go && bash ./go`
1. Note, some steps are only run on certain hosts, check ./go for details

## Refresh the Brewfile
`./refresh`

## Reconfigure all
`./go`

## To configure iTerm2
1. Configure to use the config in ./iterm2 folder
1. Setup Google Cloud SDK in home

## tmux shortcuts
1. `tmux ls` view open sessions
1. `tmux attach -t <session name>` attach to session
1. `tmux kill-session -t <session name>` kill the session
1. `CTRL+B %` split vertical
1. `CTRL+B "` split horizontal
1. `CTRL+B <ARROW>` change pane
1. `CTRL+B z` toggle pane to full view
1. `CTRL+B c` new window
1. `CTRL+B <window number>` change window
1. `CTRL+B [` scroll mode
1. `CTRL+B ]` paste highlighted text
1. `CTRL+B d` detach from session
1. `CTRL+B :` change settings, such as `set synchronize-panes`
