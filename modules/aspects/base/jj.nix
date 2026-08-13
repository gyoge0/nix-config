{
  den.aspects.base.jj.homeManager =
    { pkgs, ... }:
    {
      programs.jujutsu = {
        enable = true;
        package = pkgs.unstable.jujutsu;
        settings = {
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
          aliases = {
            g = [ "git" ];
          };
          git.private-commits = "private()";
          templates.git_push_bookmark = ''"ygt/push-" ++ change_id.short()'';
          ui.pager = "less -FRX";
          signing = {
            behavior = "own";
            backend = "ssh";
            # todo: don't hardcode this
            key = "~/.ssh/id_ed25519.pub";
          };
        };
      };
    };
  den.aspects.gyoge.jj.homeManager = {
    programs.jujutsu.settings.user = {
      name = "Yogesh Thambidurai";
      email = "yogesh@gyoge.com";
    };
  };
}
