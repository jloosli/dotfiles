#!/bin/bash
set -e

# ──────────────────────────────────────────────
# Dotfiles installer — powered by GNU Stow
# ──────────────────────────────────────────────

DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Install Stow if needed
if ! command -v stow &> /dev/null; then
    echo "Installing GNU Stow..."
    if [[ "$OSTYPE" == "darwin"* ]]; then
        brew install stow
    else
        sudo apt-get install -y stow
    fi
fi

cd "$DOTFILES_DIR"

# Create symlinks for all packages
echo "Creating symlinks..."
stow -t "$HOME" zsh tmux vim nvim

echo ""
echo "✓ Dotfiles installed!"
echo ""
echo "Useful commands:"
echo "  stow <package>      — enable a package"
echo "  stow -D <package>   — remove a package's symlinks"
echo "  stow -R <package>   — re-stow (remove + re-link)"
