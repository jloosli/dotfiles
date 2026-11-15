# dotfiles

Personal config files managed with [GNU Stow](https://www.gnu.org/software/stow/).

## Packages

| Package | Files |
|---------|-------|
| `zsh`   | `.zshrc`, `.zprofile` (Homebrew PATH) |
| `git`   | `.gitconfig`, `.config/git/ignore` |
| `tmux`  | `.tmux.conf` |
| `vim`   | `.vimrc` |
| `nvim`  | `.config/nvim/` (LazyVim) |

## Recommended installs

These tools are used by `.zshrc` and the configs in this repo. Install them before or after running `install.sh`.

```bash
# Package manager (macOS)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Everything in the Brewfile (install.sh runs this for you on macOS),
# including fzf, zsh-autosuggestions, zsh-syntax-highlighting, zoxide, ripgrep, fd, bat
brew bundle --file=~/.config/dotfiles/Brewfile

# Refresh the Brewfile after installing/removing packages
brew bundle dump --file=~/.config/dotfiles/Brewfile --force --no-vscode

# Oh My Zsh (zsh theme + plugin framework)
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Node version manager
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/HEAD/install.sh | bash
```

> **Note:** `zsh-autosuggestions` and `zsh-syntax-highlighting` are sourced via Homebrew paths in `.zshrc`. If you install them another way, source them manually in `~/.zshrc.local`.

## Install on a new machine

```bash
# Clone
git clone https://github.com/yourusername/dotfiles ~/.config/dotfiles

# Install
cd ~/.config/dotfiles
./install.sh
```

That's it — Stow creates symlinks from `~` into this repo, so edits to `~/.zshrc` etc. are automatically tracked.

## Day-to-day workflow

```bash
# Edit a config as normal
vim ~/.zshrc

# Commit the change
cd ~/.config/dotfiles
git add .
git commit -m "Update zsh prompt"
git push
```

## Managing packages

```bash
# Enable a package
stow zsh

# Disable a package (removes symlinks, keeps files)
stow -D zsh

# Re-stow after adding files to a package
stow -R zsh
```

## Machine-specific overrides

The `zsh` package sources `~/.zshrc.local` at the end of `.zshrc` if the file exists. Use this for anything that shouldn't be shared across machines — different `$PATH` entries, work credentials, machine-specific aliases, etc.

```bash
# ~/.zshrc.local (not tracked in git)
export PATH="/opt/work-sdk/bin:$PATH"
export SOME_API_KEY="abc123"
alias vpn='open -a "Corporate VPN"'
```

This file is listed in `.gitignore` so it will never be accidentally committed.

> **Installers that append to `~/.zshrc`** (Antigravity, SDK installers, etc.) write into this repo through the symlink. Move those lines into `~/.zshrc.local` before committing, using `$HOME` rather than a hard-coded home path. On machines where it doesn't exist, the shell starts cleanly with no errors.

## Adding a new package

```bash
# Example: adding git config
mkdir git
cp ~/.gitconfig git/
stow git
git add git/
git commit -m "Add git package"
```
