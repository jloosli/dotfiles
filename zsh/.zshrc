# ---- PATH & env ----
export PATH="$HOME/.local/bin:$PATH"
export EDITOR='vi'
export VISUAL="$EDITOR"

# ---- Oh My Zsh ----
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="candy"

plugins=(
  git
  macos
  brew
  docker
  docker-compose
  gh
  history-substring-search
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

# ---- SSH agent (cache env between shells so we don't spawn a new agent per shell) ----
SSH_ENV="$HOME/.ssh/agent.env"
_start_ssh_agent() {
  (umask 077; ssh-agent -s > "$SSH_ENV")
  . "$SSH_ENV" > /dev/null
  for key in ~/.ssh/id_*; do
    [[ "$key" == *.pub ]] && continue
    ssh-add --apple-use-keychain "$key" 2>/dev/null
  done
}
if [ -z "$SSH_AUTH_SOCK" ]; then
  if [ -f "$SSH_ENV" ]; then
    . "$SSH_ENV" > /dev/null
    ssh-add -l > /dev/null 2>&1 || _start_ssh_agent
  else
    _start_ssh_agent
  fi
fi

# ---- NVM (lazy-loaded so it doesn't slow shell startup) ----
# Note: helper name avoids leading underscore so Claude Code's shell-snapshot
# tool (which filters out _-prefixed user funcs) keeps it alongside the shims.
export NVM_DIR="$HOME/.nvm"
load_nvm() {
  unset -f nvm node npm npx 2>/dev/null
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
}
nvm()  { load_nvm; nvm "$@"; }
node() { load_nvm; command node "$@"; }
npm()  { load_nvm; command npm  "$@"; }
npx()  { load_nvm; command npx  "$@"; }

# ---- zsh-autosuggestions / zsh-syntax-highlighting ----
# Install: brew install zsh-autosuggestions zsh-syntax-highlighting
if command -v brew >/dev/null 2>&1; then
  _brew_prefix="$(brew --prefix)"
  [ -f "$_brew_prefix/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ] && \
    source "$_brew_prefix/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
  [ -f "$_brew_prefix/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ] && \
    source "$_brew_prefix/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
  unset _brew_prefix
fi

# ---- Functions ----
wt() {
  local target
  target=$(git worktree list | fzf --prompt="worktree> " | awk '{print $1}')
  [[ -n "$target" ]] && cd "$target"
}

# ---- Local overrides ----
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local
