{ lib, ... }:

{
  flake.modules = {
    homeManager.vcs = { pkgs, ... }: {
      programs.git = {
        enable = true;
        userName = lib.mkDefault "Yogesh Thambidurai";
        userEmail = lib.mkDefault "yogesh@gyoge.com";
      };
    };
  };
}
