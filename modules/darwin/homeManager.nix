{ inputs, ... }:
{
  flake.modules.darwin.homeManager = {
    imports = [ inputs.home-manager.darwinModules.home-manager ];
    users.users.gyoge = {
      name = "gyoge";
      home = "/Users/gyoge";
    };
  };
}
