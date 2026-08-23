# Ensures flake-part systems are declared even without host-derived ones.
# (packages.mbp is now provided by modules/nh-apps.nix via den.lib.nh.)
{ ... }:
{
  systems = [ "aarch64-darwin" ];
}
