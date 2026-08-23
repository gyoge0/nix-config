# Exposes flake apps under each host/home name for building with nh,
# e.g. `nix run .#mbp -- switch`. Same as den's default template.
{ den, ... }:
{
  perSystem =
    { pkgs, ... }:
    {
      packages = den.lib.nh.denPackages { fromFlake = true; } pkgs;
    };
}
