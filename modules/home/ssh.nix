{
  flake.modules = {
    homeManager.ssh.programs.ssh = {
      enable = true;
      addKeysToAgent = "yes";

      extraConfig = ''
        UseKeychain yes
      '';

      matchBlocks = {
        "github.com" = {
          identityFile = "~/.ssh/id_ed25519";
        };
      };
    };
  };
}
