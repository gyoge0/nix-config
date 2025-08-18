{ ... }:
{
  flake.modules.darwin.system.system.keyboard = {
    enableKeyMapping = true;
    remapCapsLockToEscape = true;
  };
}
