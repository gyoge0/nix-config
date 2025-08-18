{
  flake.modules = {
    homeManager.utils =
      { ... }:
      {
        programs.zoxide = {
          enable = true;
        };
      };
  };
}
