-- lua/plugins/nvim-lspconfig.lua

-- Since v2, nvim-lspconfig is essentially a data package: it ships lsp/<name>.lua
-- definitions that Neovim's built-in vim.lsp.config / vim.lsp.enable read off the
-- runtimepath. The old require('lspconfig').<server>.setup{} framework is
-- deprecated and is removed in lspconfig v3.0.0, so this uses the native API.
return {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },

    config = function()
        -- Overrides layered on top of the definitions lspconfig ships.
        vim.lsp.config("clangd", {
            cmd = { "clangd", "--background-index" },
        })

        vim.lsp.config("lua_ls", {
            settings = {
                Lua = {
                    -- Stop it complaining about `vim` in this config.
                    diagnostics = { globals = { "vim" } },
                    workspace = {
                        library = vim.api.nvim_get_runtime_file("", true),
                        checkThirdParty = false,
                    },
                    telemetry = { enable = false },
                },
            },
        })

        -- Servers matched to what actually gets edited here: C++, TypeScript/TSX
        -- and Python. lua_ls is wired but stays inert until its binary exists.
        -- The value is the binary that must be on $PATH for the server to start;
        -- enabling one that isn't installed would error on every matching buffer.
        local servers = {
            clangd  = "clangd",
            ts_ls   = "typescript-language-server",
            pyright = "pyright-langserver",
            lua_ls  = "lua-language-server",
        }

        for name, binary in pairs(servers) do
            if vim.fn.executable(binary) == 1 then
                vim.lsp.enable(name)
            end
        end

        -- gd and gr are already buffer keymaps in config/keymaps.lua (:bd, and
        -- friends), so LSP lives under the <leader>g namespace instead.
        -- Neovim 0.11+ also gives you grn/gra/grr/gri/gO and K for free; these
        -- are the explicit equivalents, plus go-to-definition, which has no
        -- built-in mapping.
        vim.api.nvim_create_autocmd("LspAttach", {
            group = vim.api.nvim_create_augroup("LspKeymaps", { clear = true }),
            callback = function(ev)
                local function map(lhs, rhs, desc)
                    vim.keymap.set("n", lhs, rhs,
                        { buffer = ev.buf, noremap = true, silent = true, desc = desc })
                end

                map("<leader>gd", vim.lsp.buf.definition,     "LSP: Go to Definition")
                map("<leader>gD", vim.lsp.buf.declaration,    "LSP: Go to Declaration")
                map("<leader>gr", vim.lsp.buf.references,     "LSP: References")
                map("<leader>gi", vim.lsp.buf.implementation, "LSP: Implementation")
                map("<leader>gn", vim.lsp.buf.rename,         "LSP: Rename Symbol")
                map("<leader>ga", vim.lsp.buf.code_action,    "LSP: Code Action")
                map("K",          vim.lsp.buf.hover,          "LSP: Hover Docs")

                -- goto_prev/goto_next are deprecated since 0.11 in favour of jump()
                map("[d", function() vim.diagnostic.jump({ count = -1, float = true }) end,
                    "LSP: Previous Diagnostic")
                map("]d", function() vim.diagnostic.jump({ count = 1, float = true }) end,
                    "LSP: Next Diagnostic")
            end,
        })

        vim.diagnostic.config({
            virtual_text = true,
            severity_sort = true,
            float = { border = "rounded" },
        })
    end,
}
