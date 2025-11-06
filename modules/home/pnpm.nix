{
  flake.modules = {
    homeManager.pnpm =
      { pkgs, ... }:
      {
        home.packages = [
          pkgs.pnpm
        ];
      };
  };
}
