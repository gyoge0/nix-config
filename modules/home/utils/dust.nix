{
  flake.modules = {
    homeManager.utils =
      { pkgs, ... }:
      {
        home.packages = [
          pkgs.du-dust
        ];
      };
  };
}
