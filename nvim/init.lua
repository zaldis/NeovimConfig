require('plugins')
require('config/dashboard')
require('config/auto-cmp')
require('config/lsp')
require('config/telescope')
require('config/bufferline')


vim.cmd([[
set number relativenumber
set completeopt=menu,menuone,noselect
set background=dark
set shiftwidth=4
set tabstop=4
set expandtab
colorscheme gruvbox
]])

