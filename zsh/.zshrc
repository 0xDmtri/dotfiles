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
export SSH_AUTH_SOCK="$HOME/.ssh/ssh_auth_sock"

if [[ ! -S "$SSH_AUTH_SOCK" ]]; then
    eval "$(/opt/homebrew/bin/ssh-agent -s)" >/dev/null
    ln -sf "$SSH_AUTH_SOCK" "$HOME/.ssh/ssh_auth_sock"
fi
