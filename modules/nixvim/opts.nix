{
  den.aspects.nixvim.opts.nixvim = {
    # Options
    opts = {
      # Numbering
      number = true;
      relativenumber = true;

      # Indentation
      tabstop = 4;
      shiftwidth = 4;
      expandtab = true;
      softtabstop = 4;
      autoindent = true;
      backspace = "indent,eol,start";

      # Directory settings
      directory = "/tmp/";
      backupdir = "/tmp/";
      undodir = "/tmp/";

      # Other settings
      wrap = false;
      autochdir = true;
      hlsearch = false;
    };

    # Extra config for settings that don't have direct NixVim options
    extraConfigLua = ''
      vim.cmd("filetype plugin on")
      vim.opt.belloff:remove("all")
    '';
  };
}
