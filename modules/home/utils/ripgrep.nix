{
  flake.modules = {
    homeManager.utils = { pkgs, ... }: {
      programs.ripgrep = {
        enable = true;
      };
    };
  };
}
