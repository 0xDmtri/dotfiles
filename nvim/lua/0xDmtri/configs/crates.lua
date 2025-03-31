-- [[ Configure Crates ]]

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
