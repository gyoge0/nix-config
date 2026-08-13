{
  den.aspects.base.git = {
    homeManager = {
      programs.git = {
        enable = true;
        lfs.enable = true;
        # todo: don't hardcode this
        signing = {
          key = "~/.ssh/id_ed25519.pub";
          signByDefault = true;
        };
        settings = {
          gpg.format = "ssh";
          commit.gpgsign = true;
          tag.gpgsign = true;
          core.autocrlf = "input";
        };
      };
    };
  };
  den.aspects.gyoge.git.homeManager = {
    programs.git.settings.user = {
      name = "Yogesh Thambidurai";
      email = "yogesh@gyoge.com";
    };
  };
}
