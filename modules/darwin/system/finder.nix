{ ... }:
{
  flake.modules.darwin.system.system.defaults.finder = {
    AppleShowAllExtensions = false;
    AppleShowAllFiles = false;
    FXRemoveOldTrashItems = true;
  };
}
