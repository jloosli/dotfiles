# ---- Homebrew ----
# Put Homebrew ahead of /usr/bin so brew-installed tools win over Apple's copies.
# (/etc/paths.d/homebrew also adds it, but *after* the system dirs.)
if [ -x /opt/homebrew/bin/brew ]; then
  eval "$(/opt/homebrew/bin/brew shellenv zsh)"
elif [ -x /usr/local/bin/brew ]; then
  eval "$(/usr/local/bin/brew shellenv zsh)"
fi
