# ---- PATH & env ----
# Keep PATH/fpath entries unique: re-prepending an existing entry moves it to the front.
typeset -U path PATH fpath FPATH
path=("$HOME/.local/bin" $path)
export EDITOR='nvim'
export VISUAL="$EDITOR"

# ---- Oh My Zsh ----
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="candy"
# Keep the completion cache out of $HOME.
[[ -d "$HOME/.cache/zsh" ]] || mkdir -p "$HOME/.cache/zsh"
ZSH_COMPDUMP="$HOME/.cache/zsh/zcompdump-${HOST%%.*}-${ZSH_VERSION}"

# history-substring-search is loaded below, after zsh-syntax-highlighting,
# because it must be sourced after that plugin to work correctly.
plugins=(
  git
  macos
  brew
  docker
  docker-compose
  gh
)

zstyle ':omz:update' mode auto

source $ZSH/oh-my-zsh.sh

# ---- History ----
HISTSIZE=50000
SAVEHIST=50000
HISTFILE="$HOME/.zsh_history"
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS
setopt SHARE_HISTORY
setopt EXTENDED_HISTORY

# ---- SSH agent ----
# macOS launchd already provides an agent (SSH_AUTH_SOCK). Keys load from the
# Keychain on first use via `AddKeysToAgent yes` + `UseKeychain yes` in ~/.ssh/config.

# ---- NVM (lazy-loaded so it doesn't slow shell startup) ----
# Note: helper name avoids leading underscore so Claude Code's shell-snapshot
# tool (which filters out _-prefixed user funcs) keeps it alongside the shims.
export NVM_DIR="$HOME/.nvm"
load_nvm() {
  unset -f nvm node npm npx 2>/dev/null
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  # Completion only in interactive shells: non-interactive shells (Claude Code's
  # Bash tool) never ran compinit, so sourcing it errors with "compdef:153".
  [[ -o interactive ]] && [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
}
nvm()  { load_nvm; nvm "$@"; }
node() { load_nvm; command node "$@"; }
npm()  { load_nvm; command npm  "$@"; }
npx()  { load_nvm; command npx  "$@"; }

# ---- zsh-autosuggestions / zsh-syntax-highlighting / history-substring-search ----
# Install: brew install zsh-autosuggestions zsh-syntax-highlighting
# HOMEBREW_PREFIX comes from `brew shellenv` in ~/.zprofile.
_brew_prefix="${HOMEBREW_PREFIX:-/opt/homebrew}"
[ -f "$_brew_prefix/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ] && \
  source "$_brew_prefix/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
[ -f "$_brew_prefix/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ] && \
  source "$_brew_prefix/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
unset _brew_prefix
[ -f "$ZSH/plugins/history-substring-search/history-substring-search.plugin.zsh" ] && \
  source "$ZSH/plugins/history-substring-search/history-substring-search.plugin.zsh"

# ---- Functions ----
wt() {
  command -v fzf >/dev/null || { echo "wt: fzf not installed (brew install fzf)"; return 1; }
  git rev-parse --is-inside-work-tree >/dev/null 2>&1 || { echo "wt: not inside a git repository"; return 1; }
  local target
  target=$(git worktree list --porcelain | sed -n 's/^worktree //p' | fzf --prompt="worktree> ")
  [[ -n "$target" ]] && cd "$target"
}

# ---- Local overrides ----
# Machine-specific PATH entries (installer-added lines, SDKs, etc.) belong here.
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local

# Real node binaries on PATH (newest installed) so non-shell spawners like MCP
# servers find npx; the nvm default alias is "lts/*", not a version directory.
_node_bin="$(ls -1d "$HOME"/.nvm/versions/node/v* 2>/dev/null | sort -V | tail -1)/bin"
[[ -d "$_node_bin" ]] && path=("$_node_bin" $path)
unset _node_bin

# ---- zoxide (`z <dir>` jumps to frequent directories) ----
# Keep near the end: it hooks into directory changes.
command -v zoxide >/dev/null && eval "$(zoxide init zsh)"
