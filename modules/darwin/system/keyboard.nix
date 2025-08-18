{ ... }:
{
  flake.modules.darwin.system.system = {
    defaults.NSGlobalDomain.InitialKeyRepeat = 30;
    keyboard = {
      enableKeyMapping = true;
      remapCapsLockToEscape = true;
    };
  };
}
