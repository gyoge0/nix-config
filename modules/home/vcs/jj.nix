{ lib, ... }:

{
  flake.modules = {
    homeManager.vcs =
      { pkgs, ... }:
      {
        programs.jujutsu = {
          enable = true;
          # https://github.com/NixOS/nixpkgs/issues/456113
          package = pkgs.jujutsu.override {
            rustPlatform = pkgs.rustPlatform // {
              buildRustPackage = pkgs.rustPlatform.buildRustPackage.override { cargoNextestHook = null; };
            };
          };
          settings = {
            user = {
              name = lib.mkDefault "Yogesh Thambidurai";
              email = lib.mkDefault "yogesh@gyoge.com";
            };
            template-aliases = {
              ol = "builtin_log_oneline";
              full = "builtin_log_compact_full_description";
              detail = "builtin_log_detailed";
            };
            revset-aliases = {
              "private()" = "description(glob:'private:*')";
              private = "private()";
              "public()" = "all() ~ private()";
              public = "public()";
              "public_parents(x)" = "parents(x) ~ private()";
              pp = "public_parents(@)";
              all = "all()";
            };
            git.private-commits = "private()";
            ui.pager = "less -FRX";

            signing = {
              behavior = "own";
              backend = "ssh";
              key = "~/.ssh/id_ed25519.pub";
            };
          };
        };
      };
  };
}
