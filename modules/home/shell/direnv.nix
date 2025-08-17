{
  flake.modules = {
    homeManager.shell = { pkgs, ... }: {
      programs.direnv = {
        enable = true;
        enableBashIntegration = true;
      };
    };
  };
}
