# Formatting and dev tooling for this repo (mirrors c2's config.nix).
{
  inputs,
  ...
}:
{
  flake-file.inputs.treefmt-nix.url = "github:numtide/treefmt-nix";

  imports = [ inputs.treefmt-nix.flakeModule ];

  perSystem =
    {
      pkgs,
      ...
    }:
    {
      treefmt = {
        programs.nixfmt.enable = true;
      };

      devShells.default = pkgs.mkShell {
        packages = with pkgs; [
          nil
          nixfmt
          treefmt
        ];
      };
    };
}
