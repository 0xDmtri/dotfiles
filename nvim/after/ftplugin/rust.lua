local wk = require("which-key")

local status_crates, crates = pcall(require, "crates")

-- Crates bindings
if status_crates then
    wk.add({
        { "<leader>C", group = "+Crates" },
        { "<leader>Co", crates.show_popup, desc = "Show Popup" },
        { "<leader>Cr", crates.reload, desc = "Reload" },
        { "<leader>Cv", crates.show_versions_popup, desc = "Show Versions" },
        { "<leader>Cf", crates.show_features_popup, desc = "Show Features" },
        { "<leader>Cd", crates.show_dependencies_popup, desc = "Show Deps" },
        { "<leader>Cu", crates.update_crate, desc = "Update Crate" },
        { "<leader>Ca", crates.update_all_crates, desc = "Update All Crates" },
        { "<leader>CU", crates.upgrade_crate, desc = "Upgrade Crate" },
        { "<leader>CA", crates.upgrade_all_crates, desc = "Upgrade All Crates" },
        { "<leader>CH", crates.open_homepage, desc = "Open Homepage" },
        { "<leader>CR", crates.open_repository, desc = "Open Repo" },
        { "<leader>CD", crates.open_documentation, desc = "Open Docs" },
        { "<leader>CC", crates.open_crates_io, desc = "Open Crates.io" },
    })
end

-- Rust bindings
wk.add({
    { "<leader>r", group = "+Rust" },
    { "<leader>rr", "<cmd>RustLsp runnables<cr>", desc = "Runnables" },
    { "<leader>rp", "<cmd>RustLsp parentModule<cr>", desc = "Go to parent module" },
    { "<leader>rt", "<cmd>RustLsp openCargo<cr>", desc = "Open Cargo.toml" },
    { "<leader>re", "<cmd>RustLsp explainError<cr>", desc = "Explain error" },
    { "<leader>rm", "<cmd>RustLsp expandMacro<cr>", desc = "Expand macro recursively" },
})

-- Overwrite default LSP code action
wk.add({ "<leader>a", "<cmd>RustLsp codeAction<cr>", desc = "Code Action" })
