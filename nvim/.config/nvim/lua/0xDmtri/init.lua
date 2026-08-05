-- [[ Configure Core Settings]]

-- Load default Keymaps, Settings and Colorscheme
require("0xDmtri.core.set")
require("0xDmtri.core.remap")

-- Install package manager
--    https://github.com/folke/lazy.nvim
--    `:help lazy.nvim.txt` for more info
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local lockfile = vim.fn.stdpath("config") .. "/lazy-lock.json"
    local lazy_commit

    if vim.fn.filereadable(lockfile) == 1 then
        local ok, lock = pcall(vim.json.decode, table.concat(vim.fn.readfile(lockfile), "\n"))
        if ok and lock["lazy.nvim"] then
            lazy_commit = lock["lazy.nvim"].commit
        end
    end

    local clone_command = lazy_commit and { "git", "clone", "--filter=blob:none", lazyrepo, lazypath }
        or { "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath }
    local out = vim.fn.system(clone_command)
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out, "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end

    if lazy_commit then
        out = vim.fn.system({ "git", "-C", lazypath, "checkout", "--detach", lazy_commit })
        if vim.v.shell_error ~= 0 then
            vim.api.nvim_echo({
                { "Failed to check out the locked lazy.nvim revision:\n", "ErrorMsg" },
                { out, "WarningMsg" },
                { "\nPress any key to exit..." },
            }, true, {})
            vim.fn.getchar()
            os.exit(1)
        end
    end
end
vim.opt.rtp:prepend(lazypath)

-- Initialize Lazy plugin manager
require("lazy").setup({ import = "0xDmtri.plugins" })
