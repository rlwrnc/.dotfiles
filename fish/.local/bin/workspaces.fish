#!/usr/bin/fish

set IN_TMUX 1
if test -z $TMUX
    set IN_TMUX 0
end

set PREFIX $HOME/repos/
set TMUX_DEFAULT_SESSION repos
set LOCATION_PATH (find ~/repos -mindepth 1 -maxdepth 1 | fzf)

if test $status != 0
    exit 1
end

set LOCATION_DIR (echo $LOCATION_PATH | sed "s|$PREFIX||")

if test $IN_TMUX = 1
    tmux new-window -c $LOCATION_PATH -n $LOCATION_DIR > /dev/null
else
    tmux has -t $TMUX_DEFAULT_SESSION > /dev/null

    if test $status = 0
        tmux new-window -c $LOCATION_PATH -t $TMUX_DEFAULT_SESSION -n $LOCATION_DIR > /dev/null
        tmux attach -t $TMUX_DEFAULT_SESSION > /dev/null
    else
        tmux new-session -c $LOCATION_PATH -n $LOCATION_DIR -s $TMUX_DEFAULT_SESSION > /dev/null
    end
end
