#!/bin/bash
# Dotfiles installation script
# Creates symlinks from home directory to this repo

set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$HOME/.dotfiles_backup/$(date +%Y%m%d_%H%M%S)"

backup_if_exists() {
    local target="$1"
    if [[ -e "$target" && ! -L "$target" ]]; then
        mkdir -p "$BACKUP_DIR"
        echo "Backing up $target to $BACKUP_DIR/"
        mv "$target" "$BACKUP_DIR/"
    elif [[ -L "$target" ]]; then
        rm "$target"
    fi
}

link() {
    local source="$DOTFILES_DIR/$1"
    local target="$2"
    mkdir -p "$(dirname "$target")"
    backup_if_exists "$target"
    echo "Linking $target -> $source"
    ln -sf "$source" "$target"
}

echo "Installing dotfiles from $DOTFILES_DIR"
echo ""

# Shell
link "zshrc" "$HOME/.zshrc"
link "p10k.zsh" "$HOME/.p10k.zsh"

# Ghostty
link "ghostty" "$HOME/.config/ghostty"

# Claude (individual files only - preserve session data)
mkdir -p "$HOME/.claude"
link "claude/CLAUDE.md" "$HOME/.claude/CLAUDE.md"
link "claude/settings.json" "$HOME/.claude/settings.json"
link "claude/statusline.sh" "$HOME/.claude/statusline.sh"
link "claude/agents/shipit.md" "$HOME/.claude/agents/shipit.md"
link "claude/skills/profile-python/SKILL.md" "$HOME/.claude/skills/profile-python/SKILL.md"
link "claude/rules" "$HOME/.claude/rules"

# VSCode (individual files)
VSCODE_USER="$HOME/Library/Application Support/Code/User"
mkdir -p "$VSCODE_USER"
link "vscode/settings.json" "$VSCODE_USER/settings.json"
link "vscode/keybindings.json" "$VSCODE_USER/keybindings.json"

# Emacs - copy instead of symlink (has its own git repo)
if [[ -d "$HOME/.emacs.d/.git" ]]; then
    echo ""
    echo "Note: ~/.emacs.d has its own git repo."
    echo "To sync: cp -r $DOTFILES_DIR/emacs.d/* ~/.emacs.d/"
else
    link "emacs.d" "$HOME/.emacs.d"
fi

# Git hooks
link "hooks/post-commit" "$DOTFILES_DIR/.git/hooks/post-commit"

echo ""
echo "Done!"
[[ -d "$BACKUP_DIR" ]] && echo "Existing files backed up to: $BACKUP_DIR"
echo ""
echo "Note: iTerm2 syncs automatically via its preferences."
echo "Restart your shell: exec zsh"
