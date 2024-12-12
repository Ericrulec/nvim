local status, zenMode = pcall(require, "zen-mode")
if (not status) then return end

zenMode.setup {
    window = {
        backdrop = 0.95,
    },
    plugins = {
        alacritty = {
            enabled = true,
            font = "16",
        }
    }
}

vim.keymap.set('n', '<C-w>o', '<cmd>ZenMode<cr>', { silent = true })
