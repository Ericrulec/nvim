--vim.lsp.set_log_level("debug")

local status, nvim_lsp = pcall(require, "lspconfig")
if (not status) then return end

local protocol = require('vim.lsp.protocol')

local augroup_format = vim.api.nvim_create_augroup("Format", { clear = true })
local enable_format_on_save = function(_, bufnr)
    vim.api.nvim_clear_autocmds({ group = augroup_format, buffer = bufnr })
    vim.api.nvim_create_autocmd("BufWritePre", {
        group = augroup_format,
        buffer = bufnr,
        callback = function()
            vim.lsp.buf.format({ bufnr = bufnr })
        end,
    })
end

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
    local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end

    --Enable completion triggered by <c-x><c-o>
    --local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end
    --buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

    -- Mappings.
    local opts = { noremap = true, silent = true }

    -- See `:help vim.lsp.*` for documentation on any of the below functions
    buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
    buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
    buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
    --buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
end

protocol.CompletionItemKind = {
    "󰉿",
    "󰆧",
    "󰊕",
    "",
    "󰜢",
    "󰀫",
    "󰠱",
    "",
    "",
    "󰜢",
    "󰑭",
    "󰎠",
    "",
    "󰌋",
    "",
    "󰏘",
    "󰈙",
    "󰈇",
    "󰉋",
    "",
    "󰏿",
    "󰙅",
    "",
    "󰆕",
    "",
}

-- Set up completion using nvim_cmp with LSP source
local capabilities = require('cmp_nvim_lsp').default_capabilities()
local util = require "lspconfig/util"

nvim_lsp.tailwindcss.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    filetypes = { "html", "templ", "javascriptreact", "tsx", "jsx", "vue" },
    init_options = { userLanguages = { templ = "html" } },
}

local mason_registry = require('mason-registry')
local vue_language_server_path = mason_registry.get_package('vue-language-server'):get_install_path() ..
    '/node_modules/@vue/language-server'

nvim_lsp.ts_ls.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    init_options = {
        plugins = {
            {
                name = '@vue/typescript-plugin',
                location = vue_language_server_path,
                --location = "/usr/local/lib/node_modules/@vue/typescript-plugin",
                languages = { "javascript", "typescript", "vue" },
            },
        },
    },
    filetypes = { "javascript", "json", "typescript", "typescriptreact", "typescript.tsx", "javascriptreact", "vue" },
    --cmd = { "typescript-language-server", "--stdio" },
}

nvim_lsp.volar.setup {
    on_attach = on_attach,
    capabilities = capabilities,
}

nvim_lsp.pylsp.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
        pylsp = {
            plugins = {
                -- formatter options
                black = { enabled = true },
                autopep8 = { enabled = false },
                yapf = { enabled = false },
                -- linter options
                pylint = { enabled = false, executable = "pylint" },
                pyflakes = { enabled = false },
                pycodestyle = { enabled = false },
                -- type checker
                pylsp_mypy = { enabled = true },
                -- auto-completion options
                jedi_completion = { fuzzy = true },
                -- import sorting
                pyls_isort = { enabled = true },
            },
        },
    },
    flags = {
        debounce_text_changes = 200,
    },

}

nvim_lsp.gopls.setup {
    cmd = { "/home/erik/go/bin/gopls", "--remote=auto" },
    on_attach = on_attach,
    capabilities = capabilities,
    init_options = {
        usePlaceholders = true,
        completeUnimported = true,
    },
}

vim.filetype.add({ extension = { templ = "templ" } })
nvim_lsp.templ.setup {
    on_attach = on_attach,
    capabilities = capabilities,
}
--[[
nvim_lsp.biome.setup {
    on_attach = on_attach,
    capabilities = capabilities,
}
nvim_lsp.rust_analyzer.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    filetypes = { "rust" },
    root_dir = util.root_pattern("Cargo.toml"),
    settings = {
        ["rust-analyzer"] = {
            cargo = {
                allFeatures = true,
            }
        }
    }
}
nvim_lsp.htmx.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    filetypes = { "html", "ejs", "templ" },
}
nvim_lsp.ltex.setup {
    on_attach = on_attach,
    capabilities = capabilities
}
]]
nvim_lsp.html.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    filetypes = { "html", "ejs", "templ" },
}
nvim_lsp.lua_ls.setup {
    capabilities = capabilities,
    on_attach = function(client, bufnr)
        on_attach(client, bufnr)
        enable_format_on_save(client, bufnr)
    end,
    settings = {
        Lua = {
            diagnostics = {
                -- Get the language server to recognize the `vim` global
                globals = { 'vim' },
            },
            workspace = {
                -- Make the server aware of Neovim runtime files
                library = vim.api.nvim_get_runtime_file("", true),
                checkThirdParty = false
            },
        },
    },
}

nvim_lsp.cssls.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    filetypes = { "html", "css" },
}


vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics, {
        underline = true,
        update_in_insert = false,
        virtual_text = { spacing = 4, prefix = "●" },
        severity_sort = true,
    }
)

-- Diagnostic symbols in the sign column (gutter)
local signs = { Error = "", Warn = "", Hint = "", Info = " " }
for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

vim.diagnostic.config({
    virtual_text = {
        prefix = '●'
    },
    update_in_insert = true,
    float = {
        source = "always", -- Or "if_many"
    },
})

-- If volar is active turn off ts_ls
-- vim.api.nvim_create_autocmd('LspAttach', {
--     group = vim.api.nvim_create_augroup('LspAttachConflicts', { clear = true }),
--     desc = 'Prevent ts_ls and volar conflict',
--     callback = function(args)
--         if not (args.data and args.data.client_id) then
--             return
--         end
--
--         local active_clients = vim.lsp.get_clients()
--         local client = vim.lsp.get_client_by_id(args.data.client_id)
--
--         if client ~= nil and client.name == 'volar' then
--             for _, c in ipairs(active_clients) do
--                 if c.name == 'ts_ls' then
--                     c.stop()
--                 end
--             end
--         end
--     end,
-- })
