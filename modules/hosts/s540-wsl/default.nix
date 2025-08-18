{ inputs, config, ... }:

{
  # This is the main host configuration for s540-wsl
  # Since this is WSL on Ubuntu, we configure home-manager only

  flake.homeConfigurations.s540-wsl = inputs.home-manager.lib.homeManagerConfiguration {
    pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;

    modules = with config.flake.modules.homeManager; [
      core
      nixpkgs
      nixvim
      vcs
      shell
      utils
      claude
      nix
      host_s540_wsl
    ];
  };
}
