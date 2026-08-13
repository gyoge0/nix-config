{
  config,
  __findFile,
  ...
}:
{
  den.default = {
    darwin.system.stateVersion = 6;
    nixos.system.stateVersion = "25.05";
    homeManager.home.stateVersion = "25.05";
  };

  den.default.includes = [
    <den/hostname>
    <den/define-user>
    <nix>
    <nixpkgs>
    # Disable booting when running on CI on all NixOS hosts.
    (if config ? _module.args.CI then <eg/ci-no-boot> else { })
  ];
}
