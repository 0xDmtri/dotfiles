# Created by Zap installer — plugins & prompt
[ -f "${XDG_DATA_HOME:-$HOME/.local/share}/zap/zap.zsh" ] && source "${XDG_DATA_HOME:-$HOME/.local/share}/zap/zap.zsh"
plug "zsh-users/zsh-autosuggestions"
plug "zap-zsh/supercharge"
plug "zap-zsh/satoshi-prompt"
plug "zsh-users/zsh-syntax-highlighting"
plug "wintermi/zsh-brew"
plug "wintermi/zsh-lsd"
plug "wintermi/zsh-rust"

# Init zfunc completions
fpath+=~/.zfunc

# Load and initialise completion system
autoload -Uz compinit
compinit

# Fuzzy find
source <(fzf --zsh)

# CD replacement
eval "$(zoxide init zsh)"

# Bun completions (interactive-only)
[ -s "/Users/dmtri/.bun/_bun" ] && source "/Users/dmtri/.bun/_bun"

# Aliases
alias ssh-agent="/opt/homebrew/bin/ssh-agent"
alias ssh-add="/opt/homebrew/bin/ssh-add"
alias vim="nvim"
alias fucksleep="caffeinate -d -i -s"

# Ethereum RPC default endpoints
export RPC_WS="ws://127.0.0.1:8546"
export RPC_URL="http://127.0.0.1:8545"

# Secrets (API keys, tokens — not tracked by git)
[ -f "$HOME/.secrets" ] && source "$HOME/.secrets"

# ────────────────────────────────────────
# SSH-agent startup
#
# All shells share one agent, reached through the stable symlink below.
# This openssh binds its sockets under ~/.ssh/agent — inside $HOME, which is
# never cleared at boot the way /tmp is — and nothing reaps dead ones. So
# "a socket file is there" does NOT mean "an agent is listening": after an
# unclean shutdown the leftover path outlives the process behind it.
# Probe the agent instead. ssh-add exits 2 only when it can't reach one
# (0 = keys listed, 1 = reachable but holding none).
export SSH_AUTH_SOCK="$HOME/.ssh/ssh_auth_sock"

/opt/homebrew/bin/ssh-add -l >/dev/null 2>&1
if (( $? == 2 )); then
    rm -f "$SSH_AUTH_SOCK"
    eval "$(/opt/homebrew/bin/ssh-agent -s)" >/dev/null   # overwrites SSH_AUTH_SOCK with the real path
    ln -sf "$SSH_AUTH_SOCK" "$HOME/.ssh/ssh_auth_sock"
    export SSH_AUTH_SOCK="$HOME/.ssh/ssh_auth_sock"
    # id_ed25519_sk left out on purpose: it would demand a security-key touch every boot
    /opt/homebrew/bin/ssh-add ~/.ssh/id_ed25519 ~/.ssh/id_ecdsa >/dev/null 2>&1
fi
