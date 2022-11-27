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
local globals = vim.g                              -- to set vim globals

opt.number = true                                  -- Show line numbers
opt.relativenumber = true                          -- Relative line numbers
opt.completeopt = {'menu', 'menuone', 'noselect'}  -- Completion options (for deoplete)
opt.background = 'dark'
opt.shiftwidth = 4                                 -- Size of an indent
opt.tabstop = 4                                    -- Number of spaces tabs count for
opt.expandtab = true                               -- Use spaces instead of tabs
globals.python3_host_prog = os.getenv("HOME") .. "/.config/nvim/venv/bin/python"
cmd 'set clipboard+=unnamedplus'
cmd 'colorscheme gruvbox'



local function map(mode, bind, command, opts)
    -- mode: Vim Normal/Insert mode
    -- bind: The custom keybinds 
    -- command: The command or existing keybind to customise
    local options = { noremap = true }
    if opts then
        options = vim.tbl_extend('force', options, opts)
    end
    vim.keymap.set(mode, bind, command, options)
end


map('n', '<leader>e', vim.diagnostic.open_float, { silent=true })


-- Key maps for Nvim Tree
map('n', '<leader>t', ':NvimTreeFindFileToggle<CR>', { silent=true })


-- Key maps for DAP
local widgets = require('dap.ui.widgets')
local dap = require('dap')
map('n', '<leader>db', dap.toggle_breakpoint, { silent=true })
map('n', '<leader>dr', dap.repl.open, { silent=true })
map('n', '<leader>ds', function ()
    widgets.centered_float(widgets.scopes)
end, {})
map('n', '<leader>df', function ()
    widgets.centered_float(widgets.frames)
end, {})
map('n', '<leader>de', require('dap.ui.widgets').hover, {})
map('n', '<F5>', dap.continue, {})
map('n', '<F10>', dap.step_over, {})
map('n', '<F11>', dap.step_into, {})
map('n', '<F12>', dap.step_out, {})


-- Key maps for telescope
local tele_builtin = require('telescope.builtin')
map('n', 'ff', tele_builtin.find_files, {})
map('n', 'fg', tele_builtin.live_grep, {})
map('n', 'fb', tele_builtin.buffers, {})
map('n', 'fh', tele_builtin.help_tags, {})
