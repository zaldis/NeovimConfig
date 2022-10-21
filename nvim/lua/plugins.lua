return require('packer').startup(
  function(use)
    use 'wbthomason/packer.nvim'  -- Packer can manage itself
    use 'neovim/nvim-lspconfig'  -- NVIM language server

    -- Themes
    use 'ellisonleao/gruvbox.nvim' 
  end
)

