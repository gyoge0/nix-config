{
  flake.modules = {
    homeManager.utils =
      { ... }:
      {
        programs.ripgrep = {
          enable = true;
        };
      };
  };
}
