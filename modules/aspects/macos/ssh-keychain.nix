# System scope by necessity: launchd user agents are managed by nix-darwin,
# not home-manager.
{
  den.aspects.macos.ssh-keychain.darwin.launchd.user.agents.ssh-keychain = {
    command = "ssh-add --apple-load-keychain";
    serviceConfig = {
      RunAtLoad = true;
      KeepAlive = false;
    };
  };
}
