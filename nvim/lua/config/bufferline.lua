vim.opt.termguicolors = true
require("bufferline").setup{
    options = {
        highlights = {
            fill = {
                bg = {
                    attribute = "fg",
                    highlight = "Pmenu"
                }
            },
            tab_selected = {
                fg = 'White',
                bg = 'Purple'
            }
        }
    }
}
