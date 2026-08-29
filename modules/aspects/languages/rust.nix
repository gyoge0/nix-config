{ inputs, ... }:
{
  flake-file.inputs.fenix = {
    url = "github:nix-community/fenix";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  den.aspects.languages.rust.homeManager =
    { pkgs, ... }:
    {
      home.packages = [
        (inputs.fenix.packages.${pkgs.stdenv.hostPlatform.system}.stable.withComponents [
          "cargo"
          "clippy"
          "rustc"
          "rustfmt"
        ])
      ];
    };
}
