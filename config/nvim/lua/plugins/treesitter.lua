-- lua/plugins/treesitter.lua

-- Treesitter (nvim-treesitter `main` branch).
--
-- The `master` branch is frozen at Neovim 0.11 and breaks on 0.12: Neovim
-- changed query directives so `match[capture_id]` yields a LIST of TSNodes
-- rather than one node, and master's directives (e.g. markdown's
-- `set-lang-from-info-string!`) still assume the old shape. That crashed the
-- highlighter on every fenced code block with
--   "attempt to call method 'range' (a nil value)".
--
-- `main` is a full rewrite with no `configs.setup()`: highlight, indent and
-- selection are Neovim features now, enabled per-buffer below. Requires the
-- `tree-sitter` CLI (brew install tree-sitter-cli) and does not lazy-load.
return {
    'nvim-treesitter/nvim-treesitter',
    branch = 'main',
    build = ':TSUpdate',
    lazy = false, -- main does not support lazy-loading
    config = function()
        local ts = require('nvim-treesitter')

        -- Parsers and queries install to stdpath('data')/site, which is
        -- already on 'runtimepath'.
        ts.setup({})

        local ensure_installed = {
            'lua',
            'javascript',
            'typescript',
            'python',
            'html',
            'css',
            'json',
            'bash',
            'markdown',
            'markdown_inline',
            'vim',
            'tsx',
            'cpp',
            'c',
            'php',
        }
        ts.install(ensure_installed)

        -- `main` dropped `auto_install`, so rebuild it by hand. Both lookups
        -- are cached: get_installed() scans a directory and get_available()
        -- fires a `User TSUpdate` autocmd, and this runs on every FileType.
        local installed, available
        local function is_installed(lang)
            if not installed then
                installed = {}
                for _, l in ipairs(ts.get_installed('parsers')) do
                    installed[l] = true
                end
            end
            return installed[lang] == true
        end
        local function is_available(lang)
            if not available then
                available = {}
                for _, l in ipairs(ts.get_available()) do
                    available[l] = true
                end
            end
            return available[lang] == true
        end

        vim.api.nvim_create_autocmd('FileType', {
            desc = 'Enable treesitter highlighting and indentation',
            callback = function(ev)
                local lang = vim.treesitter.language.get_lang(ev.match)
                if not lang then
                    return
                end

                if not is_installed(lang) then
                    -- auto_install: fetch in the background, then let the next
                    -- buffer of this filetype pick it up.
                    if is_available(lang) then
                        installed = nil -- force a rescan once it lands
                        ts.install(lang)
                    end
                    return
                end

                -- Highlighting. pcall because a parser can be present but
                -- unloadable (ABI mismatch after an upgrade).
                if not pcall(vim.treesitter.start, ev.buf, lang) then
                    return
                end

                -- Indentation is still experimental upstream, and not every
                -- language ships an indents query.
                if vim.treesitter.query.get(lang, 'indents') then
                    vim.bo[ev.buf].indentexpr =
                        "v:lua.require'nvim-treesitter'.indentexpr()"
                end
            end,
        })

        -- Incremental selection is native in 0.12, so it no longer needs a
        -- plugin. Kept on the same keys as before: 'gnn' is avoided because
        -- 'gn' is :bnext in config/keymaps.lua.
        vim.keymap.set({ 'n', 'x' }, '<C-space>', function()
            vim.treesitter.select('parent')
        end, { desc = 'Treesitter: grow selection' })

        vim.keymap.set('x', '<BS>', function()
            vim.treesitter.select('child')
        end, { desc = 'Treesitter: shrink selection' })
    end,
}
