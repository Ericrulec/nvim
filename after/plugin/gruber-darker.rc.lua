local status, n = pcall(require, "gruber-darker")
if (not status) then return end

n.setup({
  opts = {
    bold = false,
    italic = {
      strings = false,
    },
  },
})

vim.cmd.colorscheme("gruber-darker")
