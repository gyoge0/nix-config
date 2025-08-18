{
  flake.modules = {
    homeManager.utils =
      { ... }:
      {
        programs.fd = {
          enable = true;
        };
      };
  };
}
