{
  den.aspects.desktop.spotify.homeManager =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        spotify
      ];
    };
}
