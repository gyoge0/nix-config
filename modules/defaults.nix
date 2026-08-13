{
  lib,
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
  ];

  # enable hm for all users
  den.schema.user.classes = lib.mkDefault [ "homeManager" ];
}
