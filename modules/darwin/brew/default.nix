{ ... }:
{
  flake.modules = {
    darwin.brew.homebrew = {
      enable = true;
      onActivation.cleanup = "zap";
    };
    homeManager.brew.programs.zsh = {
      initContent = ''
        eval "$(/opt/homebrew/bin/brew shellenv)"
      '';
    };
  };
}
