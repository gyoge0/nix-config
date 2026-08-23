{
  den.aspects.macos.hm = {
    darwin.home-manager.backupFileExtension = "backup";
    homeManager.targets.darwin = {
      copyApps.enable = true;
      linkApps.enable = false;
    };
  };
}
