{
  flake.modules = {
    homeManager.ghostty =
      { pkgs, ... }:
      {
        programs.ghostty = {
          enable = true;
          # only do config for ghostty
          package = pkgs.emptyDirectory;
          enableBashIntegration = true;
          enableZshIntegration = true;
          settings = {
            theme = "iTerm2 Smoooooth";
            font-size = 180;
          };
        };
      };
  };
}
