local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = "U+005C"
vim.g.maplocalleader = "U+005C"

local status, lazy = pcall(require, "lazy")
if (not status) then
    print("Lazy is not installed")
    return
end

lazy.setup({

    {
        "blazkowolf/gruber-darker.nvim",
        opts = {
            bold = false,
            italic = {
                strings = false,
            },
        },
    },
    {
        "ej-shafran/compile-mode.nvim", -- Compile-mode like Emacs
        branch = "latest",
        -- or a specific version:
        -- tag = "v2.0.0"
        dependencies = {
            "nvim-lua/plenary.nvim",
            { "m00qek/baleia.nvim", tag = "v1.3.0" },
        },
        opts = {
            -- you can disable colors by uncommenting this line
            -- no_baleia_support = true,
            default_command = ""
        }
    },
    'nvim-lualine/lualine.nvim', -- Statusline
    'nvim-lua/plenary.nvim',     -- Common utilities
    'onsails/lspkind-nvim',      -- vscode-like pictograms

    {
        'hrsh7th/nvim-cmp', -- Completion
        dependencies = {
            {
                'L3MON4D3/LuaSnip',
                build = (function()
                    -- Build Step is needed for regex support in snippets
                    -- This step is not supported in many windows environments
                    -- Remove the below condition to re-enable on windows
                    if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
                        return
                    end
                    return 'make install_jsregexp'
                end)(),
            },
            "saadparwaiz1/cmp_luasnip",
            "rafamadriz/friendly-snippets",

            'hrsh7th/cmp-nvim-lsp', -- nvim-cmp source for neovim',s built-in LSP
            'hrsh7th/cmp-buffer',   -- nvim-cmp source for buffer words
            'hrsh7th/cmp-path',     -- nvim-cmp source for path
        },
    },
    'neovim/nvim-lspconfig',  -- LSP
    'nvimtools/none-ls.nvim', --  Neovim as a language server to inject LSP diagnostics, code actions, and more via Lua
    'williamboman/mason.nvim',
    'williamboman/mason-lspconfig.nvim',

    'nvimdev/lspsaga.nvim', -- LSP UIs
    {
        'nvim-treesitter/nvim-treesitter',
        build = ":TSUpdate",
    },
    'kyazdani42/nvim-web-devicons', -- File icons
    'nvim-telescope/telescope.nvim',
    'nvim-telescope/telescope-file-browser.nvim',
    'windwp/nvim-autopairs',
    'windwp/nvim-ts-autotag',
    {
        'numToStr/Comment.nvim',
        dependencies = {
            'JoosepAlviste/nvim-ts-context-commentstring'
        }
    },
    'norcalli/nvim-colorizer.lua',
    'folke/zen-mode.nvim',
    ({
        "iamcco/markdown-preview.nvim",
        build = function() vim.fn["mkdp#util#install"]() end,
    }),
    'akinsho/nvim-bufferline.lua',
    'lewis6991/gitsigns.nvim',
})
