{
  den.aspects.shell.zsh.homeManager = { pkgs, lib, ... }: {
    programs.zsh = {
      enable = true;
      enableCompletion = true;
      shellAliases = {
        ls = "ls -CF --color=auto";
        la = "ls -CFA --color=auto";
        ll = "ls -lFa --color=auto";
        upr = "source ~/.zshrc";
        epr = "$EDITOR ~/.zshrc";
        # nix flakes uses # a lot which zsh doesn't like
        nix = "noglob nix";
        upc = "noglob nh darwin switch ~/nix-config#mbp";
        upcd = "noglob nh darwin switch --dry ~/nix-config#mbp";
      };
      history = {
        ignoreDups = true;
        ignoreSpace = true;
        size = 10000;
        save = 10000;
      };
      # enable some useful zsh features
      initContent = lib.mkAfter ''
        # extended globbing
        setopt EXTENDED_GLOB
        # auto pushd
        setopt AUTO_PUSHD
        # correct command suggestions
        setopt CORRECT
        # vi mode screws with fzf
        bindkey -M viins '^R' fzf-history-widget
      '';
      autosuggestion.enable = true;
      plugins = [
        {
          name = "vi-mode";
          src = pkgs.zsh-vi-mode;
          file = "share/zsh-vi-mode/zsh-vi-mode.plugin.zsh";
        }
      ];
    };
  };
}
