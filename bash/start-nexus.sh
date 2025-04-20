#!/usr/bin/env bash

tmux new-session -ds nexus
tmux new-window -t nexus -n client
tmux new-window -t nexus -n server
tmux kill-window -t nexus:0
tmux split-window -ht nexus:client
tmux split-window -ht nexus:server

react_proj=$HOME/git/nexus/Nexus.Client
dotnet_sol=$HOME/git/nexus/Nexus.Server
dotnet_proj=$HOME/git/nexus/Nexus.Server/Nexus.Server

tmux send-keys -t nexus:client.0 "cd $react_proj && nvim" C-m
tmux send-keys -t nexus:client.1 "cd $react_proj && yarn run dev" C-m
tmux send-keys -t nexus:server.0 "cd $dotnet_sol && nvim" C-m
tmux send-keys -t nexus:server.1 "cd $dotnet_proj && dotnet build -c Debug && dotnet run" C-m
tmux attach-session -t nexus
