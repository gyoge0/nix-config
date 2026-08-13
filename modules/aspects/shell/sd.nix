{
  den.aspects.shell.sd.homeManager =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        sd
      ];
    };
}
