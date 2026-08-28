{
  den.aspects.desktop.cmux = {
    # nixpkgs' cmux package is outdated; use the current Homebrew release.
    darwin.homebrew.casks = [
      "cmux"
    ];

    hmDarwin =
      { config, lib, ... }:
      {
        home.file."Library/Application Support/com.cmuxterm.app/config.ghostty" =
          lib.mkIf (
            config.programs.ghostty.enable
            && config.xdg.configFile ? "ghostty/config"
          ) {
            source = config.xdg.configFile."ghostty/config".source;
          };
      };
  };
}
