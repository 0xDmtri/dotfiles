local M = {}

M.lualine = {
    options = {
        theme = "gruvbox",
        icons_enabled = true,
        component_separators = "|",
        section_separators = "",
        disabled_filetypes = { "lazy", "neo-tree" },
    },
}

M.gruvbox = {
    transparent_mode = vim.g.transparent_enabled,
    contrast = "hard",
}

M.ibl = {
    indent = {
        char = "┊",
    },
}

return M
