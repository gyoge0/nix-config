{
  flake.modules = {
    homeManager.vcs =
      { ... }:
      {
        programs.gh = {
          enable = true;
          # gh cli will try to write to ~/.config/hosts.yml and ~/.config/settings.yml,
          # which isn't allowed if we configure them from home-manager.
        };
      };
  };
}
