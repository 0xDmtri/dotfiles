local wk = require("which-key")

-- Rust bindings
wk.add({
    { "<leader>r", group = "+Rust", buffer = true },
    { "<leader>rr", "<cmd>RustLsp runnables<cr>", desc = "Runnables", buffer = true },
    { "<leader>rp", "<cmd>RustLsp parentModule<cr>", desc = "Go to parent module", buffer = true },
    { "<leader>rt", "<cmd>RustLsp openCargo<cr>", desc = "Open Cargo.toml", buffer = true },
    { "<leader>re", "<cmd>RustLsp explainError<cr>", desc = "Explain error", buffer = true },
    { "<leader>rm", "<cmd>RustLsp expandMacro<cr>", desc = "Expand macro recursively", buffer = true },
})
