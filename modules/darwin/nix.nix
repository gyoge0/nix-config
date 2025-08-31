{ ... }:
{
  flake.modules.darwin.nix = {
    nix.settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      trusted-users = [
        "admin"
        "gyoge"
      ];
    };
  };
}
