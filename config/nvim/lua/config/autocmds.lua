-- lua/config/autocmds.lua

-- Views live in the state dir, not the config dir. Config is what you'd put in
-- git; view files are per-machine runtime junk that regenerates itself.
local viewdir = vim.fn.stdpath("state") .. "/view"
vim.fn.mkdir(viewdir, "p")
vim.opt.viewdir = viewdir

-- folds + cursor only. `options` is deliberately absent: it makes a stale view
-- restore local option values too, which is how a file silently comes back with
-- last year's tabstop or foldmethod.
vim.opt.viewoptions = { "folds", "cursor" }

-- A view is only meaningful for a real, named, on-disk file. The old check
-- tested `filetype ~= "nofile"`, but nofile is a *buftype* — so the test never
-- matched anything and unnamed buffers reached mkview and threw
-- "E32: No file name" on every close.
local function view_worth_keeping()
    return vim.bo.buftype == ""
        and vim.bo.buflisted
        and vim.api.nvim_buf_get_name(0) ~= ""
        and not vim.tbl_contains(
            { "gitcommit", "gitrebase", "help", "diff", "NvimTree" }, vim.bo.filetype)
end

local group = vim.api.nvim_create_augroup("SaveViews", { clear = true })

vim.api.nvim_create_autocmd("BufWinLeave", {
    group = group,
    pattern = "*",
    desc = "Save view (including folds) when closing a file",
    callback = function()
        if view_worth_keeping() then
            vim.cmd("silent! mkview")
        end
    end,
})

vim.api.nvim_create_autocmd("BufWinEnter", {
    group = group,
    pattern = "*",
    desc = "Load view (including folds) when opening a file",
    callback = function()
        if view_worth_keeping() then
            vim.cmd("silent! loadview")
        end
    end,
})
