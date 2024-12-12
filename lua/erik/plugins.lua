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

--[[ function ColorMyGruvbox()
    vim.opt.background = "dark"
    vim.opt.termguicolors = true
    vim.cmd.colorscheme("gruvbox")
end ]]

function ColorMyOceangruber()
    vim.opt.background = "dark"
    vim.opt.termguicolors = true
    vim.cmd.colorscheme("ocean-gruber")

    vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
    vim.api.nvim_set_hl(0, "ZenBg", { bg = "none" })
end

lazy.setup({
    {
        "https://codeberg.org/ericrulec/ocean-gruber.nvim",
        name = "ocean-gruber",
        opts = {
            bold = false,
            italic = {
                strings = true,
            },
        },
    },
    --[[ {
        "ellisonleao/gruvbox.nvim",
        name = "gruvbox",
    }, ]]
    {
        "ej-shafran/compile-mode.nvim", -- Compile-mode like Emacs
        branch = "latest",
        dependencies = {
            "nvim-lua/plenary.nvim",
            { "m00qek/baleia.nvim", tag = "v1.3.0" },
        },
        config = function()
            ---@type CompileModeOpts
            vim.g.compile_mode = {
                baleia_setup = true,
            }
        end
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
            'hrsh7th/cmp-cmdline',  -- nvim-cmp source for cmdline
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
    --'norcalli/nvim-colorizer.lua',
    'folke/zen-mode.nvim',
    ({
        "iamcco/markdown-preview.nvim",
        build = function() vim.fn["mkdp#util#install"]() end,
    }),
    'akinsho/nvim-bufferline.lua',
    'lewis6991/gitsigns.nvim',

    -- RUST
    --[[ {
        "rust-lang/rust.vim",
        ft = "rust",
        init = function()
            vim.g.rustfmt_autosave = 1
        end
    },
    {
        'mrcjkb/rustaceanvim',
        version = '^4', -- Recommended
        lazy = false,   -- This plugin is already lazy
    } ]]
})

-- Colorscheme
ColorMyOceangruber()
