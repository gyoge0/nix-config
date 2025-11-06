{ lib, ... }:

{
  flake.modules = {
    homeManager.vcs =
      { ... }:
      {
        programs.git = {
          enable = true;
          lfs.enable = true;

          # SSH Commit Signing
          signing = {
            key = "~/.ssh/id_ed25519.pub";
            signByDefault = true;
          };
          settings = {
            user = {
              name = lib.mkDefault "Yogesh Thambidurai";
              email = lib.mkDefault "yogesh@gyoge.com";
            };
            gpg.format = "ssh";
            commit.gpgsign = true;
            tag.gpgsign = true;
            core.autocrlf = "input";
          };
        };
      };
  };
}
