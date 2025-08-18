{ lib, ... }:

{
  flake.modules = {
    homeManager.core =
      { ... }:
      {
        home = {
          username = lib.mkDefault "gyoge";
          homeDirectory = lib.mkDefault "/home/gyoge";
          stateVersion = lib.mkDefault "24.05";
        };

        programs.home-manager.enable = true;
      };
  };
}
