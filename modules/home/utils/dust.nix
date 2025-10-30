{
  flake.modules = {
    homeManager.utils =
      { pkgs, ... }:
      {
        home.packages = [
          pkgs.dust
        ];
      };
  };
}
