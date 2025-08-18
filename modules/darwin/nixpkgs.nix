{ ... }:
{
  flake.modules.darwin.nixpkgs = {
    nixpkgs.config.allowUnfree = true;
  };
}
