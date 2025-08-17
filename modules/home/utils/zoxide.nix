{
  flake.modules = {
    homeManager.utils = { pkgs, ... }: {
      programs.zoxide = {
        enable = true;
      };
    };
  };
}
