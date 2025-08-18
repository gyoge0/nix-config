{ inputs, ... }:
{

  imports = [ inputs.treefmt-nix.flakeModule ];
  perSystem = {
    treefmt = {
      projectRootFile = "flake.nix";
      programs = {
        deadnix.enable = true;
        nixfmt.enable = true;
      };
    };
  };
}
