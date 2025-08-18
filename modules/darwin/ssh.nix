{ ... }:
{
  flake.modules.darwin.ssh =
    { ... }:
    {
      launchd.user.agents.ssh-keychain = {
        command = "ssh-add --apple-load-keychain";
        serviceConfig = {
          RunAtLoad = true;
          KeepAlive = false;
        };
      };
    };
}
