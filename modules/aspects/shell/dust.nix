{
  den.aspects.shell.dust.homeManager =
    { pkgs, ... }:
    {
      home.packages = [
        pkgs.dust
      ];
    };
}
