{
  den.aspects.desktop.ghostty = {
    homeManager =
      { ... }:
      {
        programs.ghostty = {
          enable = true;
          enableBashIntegration = true;
          enableZshIntegration = false;
          settings = {
            theme = "iTerm2 Smoooooth";
            font-size = 18;
          };
        };
        programs.zsh.initContent = ''
          if [[ -n $GHOSTTY_RESOURCES_DIR && -f "$GHOSTTY_RESOURCES_DIR/shell-integration/zsh/ghostty-integration" ]]; then
            source "$GHOSTTY_RESOURCES_DIR/shell-integration/zsh/ghostty-integration"
          fi
        '';
      };

    hmDarwin =
      { ... }:
      {
        # Homebrew owns Ghostty on Darwin; only manage its configuration here.
        programs.ghostty.package = null;
      };

    darwin.homebrew.casks = [
      "ghostty"
    ];
  };
}
