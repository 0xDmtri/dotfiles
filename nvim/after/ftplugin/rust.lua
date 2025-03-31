local status_wk, wk = pcall(require, "which-key")
if not status_wk then
    return
end

local status_crates, crates = pcall(require, "crates")

-- Helper function to create Crates mappings
local function crate_map(key, fn, desc)
    return {
        "<leader>C" .. key,
        function()
            fn()
        end,
        desc = desc,
        mode = "n",
    }
end

-- Crates bindings
if status_crates then
    wk.add({
        { "<leader>C", group = "+Crates" },
        crate_map("o", crates.show_popup, "Show Popup"),
        crate_map("r", crates.reload, "Reload"),
        crate_map("v", crates.show_versions_popup, "Show Versions"),
        crate_map("f", crates.show_features_popup, "Show Features"),
        crate_map("d", crates.show_dependencies_popup, "Show Deps"),
        crate_map("u", crates.update_crate, "Update Crate"),
        crate_map("a", crates.update_all_crates, "Update All Crates"),
        crate_map("U", crates.upgrade_crate, "Upgrade Crate"),
        crate_map("A", crates.upgrade_all_crates, "Upgrade All Crates"),
        crate_map("H", crates.open_homepage, "Open Homepage"),
        crate_map("R", crates.open_repository, "Open Repo"),
        crate_map("D", crates.open_documentation, "Open Docs"),
        crate_map("C", crates.open_crates_io, "Open Crates.io"),
    })
end

-- LSP bindings
wk.add({
    { "<leader>l", group = "+Lsp" },
    { "<leader>la", "<cmd>RustLsp codeAction<cr>", desc = "Rust Code Action" },
})

-- Rust bindings
wk.add({
    { "<leader>r", group = "+Rust" },
    { "<leader>rr", "<cmd>RustLsp runnables<cr>", desc = "Rust Runnables" },
    { "<leader>rp", "<cmd>RustLsp parentModule<cr>", desc = "Go to parent module" },
    { "<leader>rt", "<cmd>RustLsp openCargo<cr>", desc = "Open Cargo.toml" },
    { "<leader>re", "<cmd>RustLsp explainError<cr>", desc = "Explain error" },
    { "<leader>rm", "<cmd>RustLsp expandMacro<cr>", desc = "Expand macro recursively" },
})
