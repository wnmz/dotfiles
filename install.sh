#!/bin/bash

DOTFILES="$(pwd)"
HOME="$(eval echo ~$(whoami))"
FILES="aerospace/.aerospace.toml:.aerospace.toml"

install() {
    echo "Installing dotfiles for $(whoami)..."
    
    for item in $FILES; do
        source="${item%:*}"
        target="${item#*:}"
        
        backup_msg=""
        if [[ -e "$HOME/$target" ]]; then
            mv "$HOME/$target" "$HOME/$target.backup"
            backup_msg="\n\tbackup: $HOME/$target.backup"
        fi
        ln -s "$DOTFILES/$source" "$HOME/$target"
        echo -e "\033[33mlinked $DOTFILES/$source -> $HOME/$target\033[0m$backup_msg"
    done
    
    echo "Dotfiles installed"
}

undo() {
    echo "Removing symlinks and restoring backups..."
    
    for item in $FILES; do
        target="${item#*:}"
        
        if [[ -L "$HOME/$target" ]]; then
            rm "$HOME/$target"
            echo "removed: $HOME/$target (symlink)"
        fi
        if [[ -f "$HOME/$target.backup" ]]; then
            mv "$HOME/$target.backup" "$HOME/$target"
            echo "restored: $HOME/$target.backup -> $HOME/$target"
        fi
    done
    
    echo "Dotfiles uninstalled"
}

if [[ "$1" == "--undo" ]]; then
    undo
else
    install
fi