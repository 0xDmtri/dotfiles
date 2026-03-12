# Homebrew (should stay first)
eval "$(/opt/homebrew/bin/brew shellenv)"

# Obsidian CLI (already added by the app — good)
export PATH="$PATH:/Applications/Obsidian.app/Contents/MacOS"

# Rust / Cargo
. "$HOME/.cargo/env"

# Foundry, Huff, Bifrost, user bins (group toolchain/user paths here)
export PATH="$PATH:$HOME/.foundry/bin"
export PATH="$PATH:$HOME/.huff-neo/bin"
export PATH="$PATH:$HOME/.bifrost/bin"

if [ -d "$HOME/.local/bin" ]; then
    export PATH="$HOME/.local/bin:$PATH"
fi

# other env vars that need to be seen by GUI / scripts
export EDITOR="nvim"
