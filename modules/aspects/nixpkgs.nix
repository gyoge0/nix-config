{
  inputs,
  ...
}:
let
  common = {
    nixpkgs = {
      config.allowUnfree = true;
      overlays = [
        (final: prev: {
          unstable = import inputs.nixpkgs-unstable {
            system = final.stdenv.hostPlatform.system;
            config.allowUnfree = true;
          };
        })
      ];
    };
  };
in
{
  den.aspects.nixpkgs = {
    provides.to-users = {
      home-manager.useGlobalPkgs = true;
    };
    nixos = common;
    darwin = common;
    homeManager = common;
  };
}
