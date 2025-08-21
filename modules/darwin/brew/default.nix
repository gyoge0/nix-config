{ ... }:
{
  flake.modules.darwin.brew.homebrew = {
    enable = true;
    onActivation.cleanup = "zap";
  };
}
