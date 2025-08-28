{ ... }:
{
  flake.modules.darwin.brew.homebrew.casks = [
    "alt-tab"
    "ghostty"
    "jetbrains-toolbox"
    "claude"
    "visual-studio-code"
    "discord"
    "orbstack"
    "firefox"
    "calibre" # calibre nixpkg is broken
    "skim"
  ];
}
