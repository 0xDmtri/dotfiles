-- [[ Rust Crates Helper ]]

return {
    "saecki/crates.nvim",
    name = "crates",
    event = { "BufReadPost Cargo.toml", "BufNewFile Cargo.toml" },
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
        local crates = require("crates")

        crates.setup({
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

        local function add_keymaps(bufnr)
            if vim.b[bufnr].crates_keymaps_set then
                return
            end

            local mappings = {
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
            }

            for _, mapping in ipairs(mappings) do
                mapping.buffer = bufnr
            end

            require("which-key").add(mappings)
            vim.b[bufnr].crates_keymaps_set = true
        end

        local function setup_cargo_buffer(args)
            local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(args.buf), ":t")
            if filename == "Cargo.toml" then
                add_keymaps(args.buf)
            end
        end

        local group = vim.api.nvim_create_augroup("CratesKeymaps", { clear = true })
        vim.api.nvim_create_autocmd("BufEnter", {
            group = group,
            pattern = "Cargo.toml",
            callback = setup_cargo_buffer,
        })

        setup_cargo_buffer({ buf = vim.api.nvim_get_current_buf() })
    end,
}
