{ ... }:
{
  flake.modules.darwin.host_macbook =
    { ... }:
    {
      # Host-specific darwin configuration for macbook
      system.stateVersion = 6;
      nixpkgs.system = "aarch64-darwin";
      networking.computerName = "MacBook Pro";
      networking.hostName = "mbp";
    };
}
