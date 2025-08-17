{ inputs, pkgs, ... }:
{
  flake.modules.darwin.system.system.defaults.iCal = {
    CalendarSidebarShown = true;
  };
}
