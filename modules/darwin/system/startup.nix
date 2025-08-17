{ inputs, ... }:
{
  flake.modules.darwin.system.system.startup = {
    chime = true;
  };
}
