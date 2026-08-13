{
  den.aspects.nixvim.keymaps.nixvim =
    { lib, ... }:
    {
      # Leader keys
      globals = {
        mapleader = "m";
        maplocalleader = "m";
      };

      # General keymaps
      keymaps = [
        # Quick open and reload vimrc
        {
          key = "\\e";
          action = ":e ~/.config/nvim/<CR>";
          mode = "n";
          options.noremap = true;
        }
        {
          key = "\\r";
          action = ":source ~/.config/nvim/init.lua<CR>";
          mode = "n";
          options = {
            noremap = true;
            silent = true;
          };
        }
        # Split movements
        {
          key = "<A-h>";
          action = "<C-w>h";
          mode = "n";
          options.noremap = true;
        }
        {
          key = "<A-l>";
          action = "<C-w>l";
          mode = "n";
          options.noremap = true;
        }
        {
          key = "<A-j>";
          action = "<C-w>j";
          mode = "n";
          options.noremap = true;
        }
        {
          key = "<A-k>";
          action = "<C-w>k";
          mode = "n";
          options.noremap = true;
        }
        {
          key = "<Leader>.p";
          action = "<cmd>Trouble diagnostics open focus=true<CR>";
          mode = "n";
          options = {
            noremap = true;
            silent = true;
          };
        }
        # need to find out how to fold an lsp symbol
        # {
        #   key = "me";
        #   action = "?????";
        #   mode = "n";
        #   options.noremap = true;
        # }
      ];
      lsp.keymaps = [
        {
          key = "gd";
          lspBufAction = "definition";
        }
        {
          key = "gi";
          lspBufAction = "implementation";
        }
        {
          action = lib.nixvim.mkRaw "function() vim.lsp.buf.code_action() end";
          key = "<Space>";
        }
        {
          action = lib.nixvim.mkRaw "function() vim.lsp.buf.format({ async = true }) end";
          key = "<leader>l";
        }
      ];
    };
}
