{ lib, ... }:

{
  flake.modules = {
    homeManager.nixpkgs = { pkgs, ... }: {
      nixpkgs.config.allowUnfree = true;
    };
  };
}
