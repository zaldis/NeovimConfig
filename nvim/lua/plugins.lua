return require('packer').startup(
  function(use)
    use 'wbthomason/packer.nvim'  -- Packer can manage itself
    use 'neovim/nvim-lspconfig'  -- NVIM language server

    -- Auto complete
    use 'L3MON4D3/LuaSnip'
    use 'hrsh7th/cmp-nvim-lsp'
    use 'hrsh7th/cmp-buffer'
    use 'hrsh7th/cmp-path'
    use 'hrsh7th/cmp-cmdline'
    use 'hrsh7th/nvim-cmp'

    -- Tabs
    use {'akinsho/bufferline.nvim', tag = "v3.*", requires = 'kyazdani42/nvim-web-devicons'}

    -- Finders
    use {
  	    'nvim-telescope/telescope.nvim', tag = '0.1.0',
  	    requires = { {'nvim-lua/plenary.nvim'} }
    }

    use 'glepnir/dashboard-nvim' -- Nice dashboard

    -- Themes
    use 'ellisonleao/gruvbox.nvim' 
  end
)

