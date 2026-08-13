{
  den.aspects.me =
    let
      name = "Yogesh Thambidurai";
    in
    { user, ... }:
    {
      nixos.users.users.${user.userName}.description = name;
      homeManager.programs.jujutsu.settings.user.name = name;
      homeManager.programs.git.settings.user.name = name;
    };
}
