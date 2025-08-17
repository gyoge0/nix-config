{
  flake.modules = {
    homeManager.utils =
      { pkgs, ... }:
      {
        home.packages = with pkgs; [
          sd
        ];
      };
  };
}
