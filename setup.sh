#!/bin/bash

DOTFILES_DIR="$HOME/dotfiles"

# .zprofile のシンボリックリンクを作成
if [ -e "$HOME/.zprofile" ]; then
    echo "~/.zprofile already exists. Backing up to ~/.zprofile.backup"
    mv "$HOME/.zprofile" "$HOME/.zprofile.backup"
fi

ln -s "$DOTFILES_DIR/.zprofile" "$HOME/.zprofile"
echo "Created symlink: ~/.zprofile -> $DOTFILES_DIR/.zprofile"
