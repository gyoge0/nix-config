{ inputs, config, ... }:

{
  # Darwin host configuration for macbook
  # This creates a home-manager configuration for macOS

  flake.darwinConfigurations.macbook = inputs.nix-darwin.lib.darwinSystem {
    modules = [
      inputs.self.modules.darwin.host_macbook
      inputs.self.modules.darwin.system
      inputs.self.modules.darwin.brew
      inputs.self.modules.darwin.homeManager
      inputs.self.modules.darwin.nix
      inputs.self.modules.darwin.nixpkgs
      inputs.self.modules.darwin.security
      inputs.self.modules.darwin.ssh
      inputs.home-manager.darwinModules.home-manager
      inputs.self.modules.darwin.uvaProfile
      inputs.agenix.darwinModules.default
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.users.gyoge = {
          home.stateVersion = "25.05";
          imports = with config.flake.modules.homeManager; [
            core
            nixvim
            vcs
            shell
            utils
            claude
            ssh
            nix
            ideavim
            python
            host_macbook
            # ghostty # is broken right now
          ];
        };
      }
    ];
  };
}
