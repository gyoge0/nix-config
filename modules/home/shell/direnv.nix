{
  flake.modules = {
    homeManager.shell =
      { ... }:
      {
        programs.direnv = {
          enable = true;
          enableBashIntegration = true;
        };
      };
  };
}
