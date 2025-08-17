{ inputs, ... }:
{
  flake.modules.darwin.system.system = {
    primaryUser = "gyoge";
  };
}
