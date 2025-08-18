{ ... }:
{
  flake.modules.darwin.system.system.defaults.NSGlobalDomain = {
    # need to configure based on app
    _HIHideMenuBar = false;
  };
}
