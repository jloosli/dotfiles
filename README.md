# dotfiles

Personal config files managed with [GNU Stow](https://www.gnu.org/software/stow/).

## Packages

| Package | Files |
|---------|-------|
| `zsh`   | `.zshrc` |
| `tmux`  | `.tmux.conf` |
| `vim`   | `.vimrc` |

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

This file is listed in `.gitignore` so it will never be accidentally committed. On machines where it doesn't exist, the shell starts cleanly with no errors.

## Adding a new package

```bash
# Example: adding git config
mkdir git
cp ~/.gitconfig git/
stow git
git add git/
git commit -m "Add git package"
```
