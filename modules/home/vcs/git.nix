{ lib, ... }:

{
  flake.modules = {
    homeManager.vcs =
      { ... }:
      {
        programs.git = {
          enable = true;
          userName = lib.mkDefault "Yogesh Thambidurai";
          userEmail = lib.mkDefault "yogesh@gyoge.com";

          lfs.enable = true;

          # SSH Commit Signing
          signing = {
            key = "~/.ssh/id_ed25519.pub";
            signByDefault = true;
          };
          extraConfig = {
            gpg.format = "ssh";
            commit.gpgsign = true;
            tag.gpgsign = true;
          };
        };
      };
  };
}
