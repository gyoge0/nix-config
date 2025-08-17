{
  flake.modules = {
    homeManager.utils = { pkgs, ... }: {
      programs.fd = {
        enable = true;
      };
    };
  };
}
