{
  den.aspects.nixvim.treesitter.nixvim.plugins = {
    treesitter = {
      enable = true;
      # setting this to true causes random folds after lsp formatting
      folding.enable = false;
      nixvimInjections = true;
      # treesitter doesn't support lazy loading
      # https://github.com/nvim-treesitter/nvim-treesitter/blob/9866036ec3c5db40700a9178494e0cfdcfe6ecfd/README.md?plain=1#L47-L48
      lazyLoad.enable = false;
      settings = {
        autoInstall = true;
        highlight = {
          enable = true;
        };
      };
    };
  };
}
