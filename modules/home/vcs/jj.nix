{ lib, ... }:

{
  flake.modules = {
    homeManager.vcs =
      { ... }:
      {
        programs.jujutsu = {
          enable = true;
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
