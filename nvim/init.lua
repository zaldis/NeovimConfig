require('plugins')
require('config/dashboard')
require('config/auto-cmp')
require('config/lsp')
require('config/telescope')
require('config/bufferline')
require('config/tree')
require('config/dap')


local opt = vim.opt                                -- to set options
local cmd = vim.cmd                                -- to execute Vim commands e.g. cmd('pwd')
local api = vim.api

opt.number = true                                  -- Show line numbers
opt.relativenumber = true                          -- Relative line numbers
opt.completeopt = {'menu', 'menuone', 'noselect'}  -- Completion options (for deoplete)
opt.background = 'dark'
opt.shiftwidth = 4                                 -- Size of an indent
opt.tabstop = 4                                    -- Number of spaces tabs count for
opt.expandtab = true                               -- Use spaces instead of tabs
cmd 'colorscheme gruvbox'


local function map(mode, bind, command, opts)
    -- mode: Vim Normal/Insert mode
    -- bind: The custom keybinds 
    -- command: The command or existing keybind to customise
    local options = { noremap = true }
    if opts then
        options = vim.tbl_extend("force", options, opts)
    end
    api.nvim_set_keymap(mode, bind, command, options)
end


map("n", "<Space>t", ":NvimTreeFindFileToggle<CR>", { silent = true })

