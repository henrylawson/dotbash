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
`tmux ls` view open sessions
`tmux attach -t <session name>` attach to session
`tmux kill-session -t <session name>` kill the session

`CTRL+B %` split vertical
`CTRL+B "` split horizontal
`CTRL+B <ARROW>` change pane
`CTRL+B z` toggle pane to full view
`CTRL+B c` new window
`CTRL+B <window number>` change window
`CTRL+B d` detach from session
