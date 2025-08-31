{
  flake.modules = {
    homeManager.ssh.programs.ssh = {
      enable = true;
      enableDefaultConfig = false;

      extraConfig = ''
        UseKeychain yes
      '';

      matchBlocks = {
        "*" = {
          addKeysToAgent = "yes";
        };
        "github.com" = {
          identityFile = "~/.ssh/id_ed25519";
        };
      };
    };
  };
}
