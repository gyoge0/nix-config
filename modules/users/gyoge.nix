{ __findFile, ... }:
{
  den.aspects.gyoge = {
    includes = [
      <me>
      <den/primary-user>
      (<den/user-shell> "zsh")
    ];

    homeManager =
      let
        email = "yogesh@gyoge.com";
      in
      { pkgs, ... }:
      {
        programs.jujutsu.settings.user.email = email;
        programs.git.settings.user.email = email;
      };
  };

}
