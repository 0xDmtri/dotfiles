-- [[ Rust Crates Helper ]]

return {
    "saecki/crates.nvim",
    name = "crates",
    event = { "BufRead Cargo.toml" },
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
        require("crates").setup({
            completion = {
                crates = {
                    enabled = true,
                },
            },
            lsp = {
                enabled = true,
                actions = true,
                completion = true,
                hover = true,
            },
            popup = {
                autofocus = true,
                hide_on_select = false,
            },
        })
    end,
}
