{
  flake.modules.homeManager.host_macbook =
    { pkgs, ... }:
    {
      # Host-specific home-manager configuration for macbook
      # This is a macOS system

      # Host-specific bash aliases
      programs.zsh.shellAliases = {
        upc = "noglob sudo darwin-rebuild switch --flake ~/nix-config/#macbook";
        epc = "$EDITOR ~/nix-config";
      };

      # Add any other host-specific configurations here
      # For example, macOS-specific paths, tools, or settings
    };
}
