{ inputs, ... }:
{
  flake.modules.darwin.brew.homebrew.casks = [
    "alt-tab"
    "ghostty"
    "jetbrains-toolbox"
    "claude"
    "visual-studio-code"
    "discord"
    "docker-desktop"
    "firefox"
  ];
}
