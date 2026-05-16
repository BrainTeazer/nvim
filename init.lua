---
--- VIM SETTINGS
---
local option = vim.opt

option.autocomplete = true
option.complete = "o"
option.completeopt = "fuzzy,menuone,noselect,popup"

option.winborder = "rounded"
option.textwidth = 80
option.shiftwidth = 4 -- Size of indent
option.tabstop = 4    -- Number of spaces tabs count for
option.softtabstop = 4
option.scrolloff = 8

option.swapfile = false
option.backup = false
option.undodir = os.getenv("HOME") .. "/local/share/nvim/undodir"
option.undofile = true

option.signcolumn = "yes"
option.wrap = false

option.termguicolors = true
option.autoindent = true
option.relativenumber = true -- Line numbers
option.hlsearch = false      -- Get results as you type.
option.incsearch = true      -- Get results as you type.
option.cursorline = true
option.number = true         -- show line number
option.expandtab = true      -- spaces instead of tabs
option.ignorecase = true     -- ignore case when finding text
option.smartindent = true

option.ch = 0                 -- command height
option.colorcolumn = "80"
option.formatoptions.j = true -- remove comment leader when joining lines,

--
-- PLUGINS
--
vim.pack.add({
    { src = "https://github.com/nvim-tree/nvim-web-devicons" },
    { src = "https://github.com/lewis6991/gitsigns.nvim" },
    {
        src = "https://github.com/nvim-treesitter/nvim-treesitter",
        version = "main"
    },
    { src = "https://github.com/nvim-treesitter/nvim-treesitter-textobjects" },
    { src = "https://github.com/ibhagwan/fzf-lua" },
    { src = "https://github.com/neovim/nvim-lspconfig" },
    { src = "https://github.com/nvim-mini/mini.files" },
    { src = "https://github.com/mason-org/mason.nvim" },
    { src = "https://github.com/L3MON4D3/LuaSnip" },
    -- Themes
    { src = "https://github.com/aktersnurra/no-clown-fiesta.nvim" },
    { src = "https://github.com/EdenEast/nightfox.nvim" },
    -- Debugger
    -- { src = "https://github.com/mfussenegger/nvim-dap" },
    -- { src = "https://github.com/MironPascalCaseFan/debugmaster.nvim",
    -- version = "main" },
})

require("mason").setup {}
require("mini.files").setup {}
vim.cmd("packadd nvim.undotree")
vim.cmd("packadd nvim.difftool")

-- Show line diagnostics automatically in hover window
vim.diagnostic.enable = true
option.updatetime = 400
vim.cmd [[autocmd CursorHold,CursorHoldI * lua vim.diagnostic.open_float(nil, {focus=false})]]

-- Requires tree-sitter-cli
vim.api.nvim_create_autocmd('FileType', {
    pattern = {
        'svelte', 'markdown', 'yaml', 'lua', 'rust', 'typescript',
        'javascript', 'c', 'cpp', 'cmake', 'txt', 'python', 'typst' },
    callback = function() vim.treesitter.start() end,
})

local theme = "duskfox"
local fzf_lua = require("fzf-lua")

fzf_lua.setup {
    winopts = {
        height   = 0.5,
        width    = 0.5,
        backdrop = 70,
        preview  = {
            layout = "vertical"
        },
    },
}
fzf_lua.register_ui_select {}

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
vim.lsp.config('neocmake', {
    capabilities = capabilities,
})

vim.lsp.enable({
    "clangd", "texlab", "lua_ls", "rust-analyzer",
    "svelte", "tailwindcss", "ts_ls", "emmet_language_server",
    "emmet_ls", "neocmake", "ruff", "basedpyright",
    "tinymist"
})
vim.lsp.config("rust-analyzer", vim.lsp.config["rust_analyzer"])
vim.lsp.config("clangd", {
    cmd = { 'clangd', '--clang-tidy' }
})

--
-- KEY MAPPINGS
--
local map = vim.keymap.set
vim.g.mapleader = " "
-- Remove highlight after search
map("n", "<leader>ch", ":noh<cr>", { silent = true })

map({ "n", "v", "x" }, "<leader>wl", "<C-w>l", { silent = true })
map({ "n", "v", "x" }, "<leader>wh", "<C-w>h", { silent = true })
map({ "n", "v", "x" }, "<leader>wj", "<C-w>j", { silent = true })
map({ "n", "v", "x" }, "<leader>wk", "<C-w>k", { silent = true })

-- Move lines in visual mode (auto indents)
map("v", "J", ":m '>+1<CR>gv=gv")
map("v", "K", ":m '<-2<CR>gv=gv")

-- In visual mode, do not get replace the item in register when pasting
map("x", "<leader>p", [["_dP]])
-- Similar to above for deleting
map({ "n", "v" }, "<leader>d", "\"_d")

-- system clipboard yank
map({ "n", "v" }, "<leader>y", [["+y]])
map("n", "<leader>Y", [["+Y]])

-- Substitution mode in selection
map({ "n", "v", "x" }, "<C-s>", [[:s/\%V]])
-- Substitution mode of selection for whole file
map("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

map({ "n", "v", "x" }, "n", "nzz", { silent = true })
map({ "n", "v", "x" }, "N", "Nzz", { silent = true })

map({ "n", "v", "x" }, "<C-u>", "<C-u>zz", { silent = true })
map({ "n", "v", "x" }, "<C-d>", "<C-d>zz", { silent = true })
map({ "n", "v", "x" }, "{", "{zz", { silent = true })
map({ "n", "v", "x" }, "}", "}zz", { silent = true })

map("n", "<leader>u", ":Undotree<cr>", { desc = "Toggle undotree" })

-- Go to next (:bn)/prev (:bp) or cycle between two (:b#) buffers
map({ "n", "v", "x" }, "<leader>bn", ":bn<cr>", { silent = true })
map({ "n", "v", "x" }, "<leader>bp", ":bp<cr>", { silent = true })
map({ "n", "v", "x" }, "<leader>bc", ":b#<cr>", { silent = true })

---
--- LSP
---
map("n", "gd", "<cmd>lua vim.lsp.buf.definition()<cr>", { silent = true, noremap = true })
map("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<cr>", { silent = true, noremap = true })
map("n", "gr", "<cmd>lua vim.lsp.buf.references()<cr>", { silent = true, noremap = true })
map("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<cr>", { silent = true, noremap = true })
map("n", "<leader>lf", "<cmd>lua vim.lsp.buf.format({ async = false })<cr>", { silent = true, noremap = true })
map("n", "<leader>pu", "<cmd>lua vim.pack.update()<cr>", { silent = true, noremap = true })

--
-- File Picker
--
map("n", "<leader>ff", fzf_lua.files, { desc = "Find files" })
map("n", "<leader>fb", fzf_lua.buffers, { desc = "Open buffers" })
map("n", "<leader>m", fzf_lua.marks, { desc = "Open marks" })
map("n", "<leader>fs", fzf_lua.live_grep, { desc = "Live grep" })
map("n", "<leader>fh", fzf_lua.help_tags, { desc = "Help tags" })
map("n", "<leader>fgf", fzf_lua.git_files, { desc = "Find modified files (git)" })
map("n", "<leader>fm", fzf_lua.man_pages)
map("n", "<leader>fgg", fzf_lua.git_status, { desc = "Find modified files (git)" })
map("n", "<leader>fr", fzf_lua.oldfiles, { desc = "Old files" })
map("n", "<leader>fd", fzf_lua.diagnostics_document, { desc = "Diagnostics" })

local function toggle_minifiles()
    local minifiles = require("mini.files")
    if not minifiles.close() then
        minifiles.open(vim.api.nvim_buf_get_name(0))
        minifiles.reveal_cwd()
    end
end

map('n', '<leader>e', toggle_minifiles, { desc = "Toggle minifiles" })

vim.cmd("colorscheme " .. theme)

--
-- Statusline
--
local cmp = {}
vim.api.nvim_set_hl(0, "ModeHL", { fg = '#080808', bg = '#80a0ff', bold = true })
vim.api.nvim_set_hl(0, "VcsHL", { fg = '#c6c6c6', bg = '#303030' })
vim.api.nvim_set_hl(0, "RecordingHL", { fg = '#79dac8' })

function _G._statusline_component(name)
    return cmp[name]()
end

function cmp.macro_recording()
    local recording_msg = vim.fn.reg_recording()

    if recording_msg ~= "" then
        return "Recording @" .. recording_msg
    end

    return ""
end

function cmp.git()
    local git_info = vim.b.gitsigns_status_dict

    if not git_info then
        return ""
    end

    return '%#VcsHL# ' .. git_info.head .. ' %*'
end

function cmp.mode()
    local modes = {
        ["n"] = "NORMAL",
        ["no"] = "NORMAL",
        ["v"] = "VISUAL",
        ["V"] = "VISUAL LINE",
        [""] = "VISUAL BLOCK",
        ["s"] = "SELECT",
        ["S"] = "SELECT LINE",
        [""] = "SELECT BLOCK",
        ["i"] = "INSERT",
        ["ic"] = "INSERT",
        ["R"] = "REPLACE",
        ["Rv"] = "VISUAL REPLACE",
        ["c"] = "COMMAND",
        ["cv"] = "VIM EX",
        ["ce"] = "EX",
        ["r"] = "PROMPT",
        ["rm"] = "MOAR",
        ["r?"] = "CONFIRM",
        ["!"] = "SHELL",
        ["t"] = "TERMINAL",
    }
    local current_mode = vim.api.nvim_get_mode().mode
    return string.format("%s", modes[current_mode]):upper()
end

function cmp.diagnostic_status()
    local errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
    local diagnositc_msg = " "

    if errors > 0 then
        diagnositc_msg = diagnositc_msg .. ' ' .. errors .. ' '
    end

    local warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })

    if warnings > 0 then
        diagnositc_msg = diagnositc_msg .. ' ' .. warnings .. ' '
    end

    return diagnositc_msg
end

local function create_status_line()
    return table.concat {
        '%#ModeHL# %{%v:lua._statusline_component("mode")%} %*',
        '%{%v:lua._statusline_component("git")%}',
        " %<%f",
        '%{%v:lua._statusline_component("diagnostic_status")%}',
        '%#RecordingHL# %{%v:lua._statusline_component("macro_recording")%}%*',
        " %h%m",
        "%=",
        "%{&filetype} ",
        "%#ModeHL# %l:%c%V %*"
    }
end

vim.o.statusline = create_status_line()
