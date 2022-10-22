return require('packer').startup(
  function(use)
    use 'wbthomason/packer.nvim'  -- Packer can manage itself
    use 'neovim/nvim-lspconfig'  -- NVIM language server

    use 'glepnir/dashboard-nvim' -- Nice dashboard

    -- Themes
    use 'ellisonleao/gruvbox.nvim' 
  end
)

