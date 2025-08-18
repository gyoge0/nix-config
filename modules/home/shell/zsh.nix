{
  flake.modules = {
    homeManager.shell =
      { ... }:
      {
        programs.zsh = {
          enable = true;
          enableCompletion = true;
          shellAliases = {
            ls = "ls -CF --color=auto";
            la = "ls -CFA --color=auto";
            ll = "ls -lFa --color=auto";
            upr = "source ~/.zshrc";
            epr = "$EDITOR ~/.zshrc";
          };
          history = {
            ignoreDups = true;
            ignoreSpace = true;
            # Optional: set history size
            size = 10000;
            save = 10000;
          };
          sessionVariables = {
            # this isn't working
            # setting manually instead
            # PROMPT = ''%B%F{orange}zsh%f%b %F{green}''${''${USER#gyoge}:+''${USER}@}''${''${HOST#mbp}:+''${HOST}}%f %F{blue}%~%f ''$ '';
          };

          # Optional: Enable some useful zsh features
          initContent = ''
            # Enable extended globbing
            setopt EXTENDED_GLOB
            # Enable auto pushd
            setopt AUTO_PUSHD
            # Enable correct command suggestions
            setopt CORRECT
            export PROMPT="%B%F{yellow}zsh%f%b %F{green}''${''${USER#gyoge}:+''${USER}}@''${''${HOST#mbp}:+''${HOST}}%f %F{blue}%~%f ''$ "
          '';
        };
      };
  };
}
