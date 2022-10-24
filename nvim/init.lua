require('plugins')
require('config/dashboard')
require('config/auto-cmp')
require('config/lsp')
require('config/telescope')

local opt = vim.opt                                -- to set options
local cmd = vim.cmd                                -- to execute Vim commands e.g. cmd('pwd')

opt.number = true                                  -- Show line numbers
opt.relativenumber = true                          -- Relative line numbers
opt.completeopt = {'menu', 'menuone', 'noselect'}  -- Completion options (for deoplete)
opt.background = 'dark'
opt.shiftwidth = 4                                 -- Size of an indent
opt.tabstop = 4                                    -- Number of spaces tabs count for
opt.expandtab = true                               -- Use spaces instead of tabs
cmd 'colorscheme gruvbox'
