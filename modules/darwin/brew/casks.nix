{ ... }:
{
  flake.modules.darwin.brew.homebrew = {
    casks = [
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
      "zoom"
      "dotnet-sdk"
      "microsoft-teams"
      "spotify"
      "prismlauncher"
      "multiviewer"
      "zotero"
      "1password"
    ];
    brews = [ "r" ];
  };
}
