{
  den.aspects.languages.js.homeManager =
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
