#!/bin/bash

session=$1

tmux new-session -d -s $session -c $HOME/Algo/$session

window=1
tmux rename-window -t $session:$window 'vim'
tmux send-keys -t $session:$window "conda activate ${session}-dev" Enter
tmux send-keys -t $session:$window "vim" Enter
tmux send-keys -t $session:$window "\v"
tmux split-pane -t $session:$window
tmux send-keys -t $session:$window "conda activate ${session}-dev" Enter
tmux send-keys -t $session:$window "cd $HOME/Algo/$session" Enter
tmux resize-pane -t $session:$window -D 5

tmux attach-session -t $session
