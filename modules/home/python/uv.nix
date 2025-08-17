{
  flake.modules = {
    homeManager.python = { pkgs, ... }: {
      programs.uv = {
        enable = true;
      };
    };
  };
}
