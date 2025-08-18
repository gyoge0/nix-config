{
  flake.modules.homeManager.host_s540_wsl =
    { ... }:
    {
      # Host-specific home-manager configuration for s540-wsl
      # This is a WSL Ubuntu system

      # Host-specific bash aliases
      programs.bash.shellAliases = {
        upc = "nix run home-manager -- switch --flake ~/nix-config#s540-wsl";
        epc = "$EDITOR ~/nix-config";
      };

      # Add any other host-specific configurations here
      # For example, WSL-specific paths, tools, or settings
    };
}
