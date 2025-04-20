#!/usr/bin/env bash

tmux send-keys -t session:0.0 "cd $1 && yarn run dev" C-m
