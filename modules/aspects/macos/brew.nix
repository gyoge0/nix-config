# Homebrew itself is system scope (it manages /opt/homebrew); the shell
# integration is user scope.
{
  den.aspects.macos.brew.darwin.homebrew = {
    enable = true;
    onActivation = {
      cleanup = "zap";
      # Homebrew activation runs non-interactively; force cleanup so it does
      # not fail when removing unmanaged packages.
      extraFlags = [ "--force-cleanup" ];
    };
  };
  den.aspects.macos.brew.homeManager.programs.zsh.initContent =
    "eval \"$(/opt/homebrew/bin/brew shellenv)\"";
}
