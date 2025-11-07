{
  flake.modules.homeManager.js =
    { pkgs, ... }:
    {
      programs.bun = {
        enable = true;
      };
      home.packages = [
        pkgs.pnpm
        pkgs.nodejs_24
      ];
    };
}
