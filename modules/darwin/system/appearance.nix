{ inputs, pkgs, ... }:
{
  flake.modules.darwin.system.system.defaults.NSGlobalDomain = {
    AppleInterfaceStyleSwitchesAutomatically = true;
  };
}
