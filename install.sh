#!/bin/bash
set -e

# ──────────────────────────────────────────────
# Dotfiles installer — powered by GNU Stow
# ──────────────────────────────────────────────

DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

FORCE=0
for arg in "$@"; do
    case "$arg" in
        -f|--force) FORCE=1 ;;
        -h|--help)
            echo "Usage: $0 [-f|--force]"
            echo "  -f, --force   Back up conflicting files to <file>.bak before stowing"
            exit 0
            ;;
        *) echo "Unknown option: $arg" >&2; exit 1 ;;
    esac
done

PACKAGES=(zsh tmux vim nvim)

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

if [[ "$FORCE" -eq 1 ]]; then
    echo "Force mode: backing up conflicting files..."
    # Parse stow's conflict output and back up each existing target
    conflicts=$(stow -n -t "$HOME" "${PACKAGES[@]}" 2>&1 | \
        grep -oE 'existing target [^ ]+' | awk '{print $3}' | sort -u)
    for rel in $conflicts; do
        target="$HOME/$rel"
        if [[ -e "$target" && ! -L "$target" ]]; then
            backup="${target}.bak"
            echo "  $target -> $backup"
            mv "$target" "$backup"
        fi
    done
fi

# Create symlinks for all packages
echo "Creating symlinks..."
stow -t "$HOME" "${PACKAGES[@]}"

echo ""
echo "✓ Dotfiles installed!"
echo ""
echo "Useful commands:"
echo "  stow <package>      — enable a package"
echo "  stow -D <package>   — remove a package's symlinks"
echo "  stow -R <package>   — re-stow (remove + re-link)"
