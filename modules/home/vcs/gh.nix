{
  flake.modules = {
    homeManager.vcs = { pkgs, ... }: {
      programs.gh = {
        enable = true;
        extensions = with pkgs; [ gh-copilot ];
        # gh cli will try to write to ~/.config/hosts.yml and ~/.config/settings.yml,
        # which isn't allowed if we configure them from home-manager.
      };
    };
  };
}
