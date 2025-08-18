{ ... }:
{
  flake.modules.darwin.system.system.defaults.screencapture = {
    include-date = true;
    location = "~/Pictures/Screenshots/";
  };
}
