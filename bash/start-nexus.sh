#!/usr/bin/env bash

PROJECT_NAME=$1
WINDOW_NAME=$2
PROJECT_DIR=$HOME/git/$1
 
select_project() {
    find "$PROJECT_DIR" -maxdepth 2 -type d | fzf --prompt="Please select a react project:"
}

setup_tmux_session() {
    local session_name=$1

    if [[ -z $session_name ]]; then
	echo "Failed to setup tmux session - missing args"
	return
    fi

    tmux new-session -ds "$session_name"
}

setup_window() {
    local session_name=$1
    local window_name=$2
    local project=$3

    if [[ -z $session_name || -z $window_name || -z $project ]]; then
	echo "Failed to setup window - missing args"
	return
    fi

    tmux new-window -t "$session_name" -n "$window_name"
    tmux kill-window -t "$session_name":0
    tmux split-window -ht "$session_name":"$window_name"
    tmux send-keys -t "$session_name:$window_name.0" "cd \"$project\" && nvim" C-m
    tmux send-keys -t "$session_name:$window_name.1" "cd \"$project\" && yarn run dev" C-m
}

main() {
    if [[ -z $PROJECT_NAME ]]; then
	echo "Please provide a session name"
	return
    fi
    if [[ -z $WINDOW_NAME ]]; then
	echo "Please provide a window name"
	return
    fi

    local project=$(select_project)
    if [[ -z $project ]]; then
	echo "No project selected"
	return
    fi

    if tmux has-session -t "$PROJECT_NAME" 2>/dev/null; then
	echo "Session already exists. Please close existing one."
	return
    fi

    if [[ ! -f $project/package.json ]]; then
	echo "Invalid react project"
	return
    fi

    setup_tmux_session $PROJECT_NAME
    setup_window $PROJECT_NAME $WINDOW_NAME $project
    tmux attach-session -t "$PROJECT_NAME"
}

main

