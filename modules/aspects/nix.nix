{
  den.aspects.nix =
    let
      common = {
        nix.settings = {
          extra-experimental-features = [
            "flakes"
            "nix-command"
          ];
          substituters = [
            "https://cache.nixos.org"
            "https://nix-community.cachix.org"
            "https://devenv.cachix.org"
            "https://numtide.cachix.org"
          ];

          trusted-substituters = [
            "https://nix-community.cachix.org"
            "https://devenv.cachix.org"
            "https://numtide.cachix.org"
          ];

          trusted-public-keys = [
            "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
            "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
            "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
            "numtide.cachix.org-1:2ps1kLBUWjxIneOy1Ik6cQjb41X0iXVXeHigGmycPPE="
          ];
        };
      };
    in
    {
      nixos = common;
      home = common;
      darwin = common // {
        nix.settings = common.nix.settings // {
          substituters = common.nix.settings.substituters ++ [
            "https://arm.cachix.org"
          ];

          trusted-substituters = common.nix.settings.trusted-substituters ++ [
            "https://arm.cachix.org"
          ];

          trusted-public-keys = common.nix.settings.trusted-public-keys ++ [
            "arm.cachix.org-1:K3XjAeWPgWkFtSS9ge5LJSLw3xgnNqyOaG7MDecmTQ8="
          ];
        };
        nixpkgs.hostPlatform = "aarch64-darwin";
      };
    };
}
