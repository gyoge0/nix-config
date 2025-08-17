{ lib, ... }:

{
  flake.modules = {
    homeManager.vcs =
      { pkgs, ... }:
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
            };
            revset-aliases = {
              "private()" = "description(glob:'private:*')";
              private = "private()";
              "public()" = "all() ~ private()";
              public = "public()";
              "public_parents(x)" = "parents(x) ~ private()";
              pp = "public_parents(@)";
            };
            git.private-commits = "private()";
          };
        };
      };
  };
}
