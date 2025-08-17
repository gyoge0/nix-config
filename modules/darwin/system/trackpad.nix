{ inputs, pkgs, ... }:
{
  flake.modules.darwin.system.system.defaults.NSGlobalDomain = {
    "com.apple.swipescrolldirection" = false;
  };
}
