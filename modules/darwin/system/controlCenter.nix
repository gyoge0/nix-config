{ inputs, pkgs, ... }:
{
  flake.modules.darwin.system.system.defaults.controlcenter = {
    AirDrop = false;
    BatteryShowPercentage = true;
    Bluetooth = false;
    # rest can't be configured or is show when active
    # for reference:
    # Wi-Fi: Show in Menu Bar
    # Focus: Show When Active
    # Stage Manager: Don't Show in Menu Bar
    # Screen Mirroring: Show When Active
    # Display: Show When Active
    # Sound: Show When Active
    # Now Playing: Show When Active

    # control center also isn't configurable
    # for reference:
    # Accessibility: No
    # Battery: Menu Bar
    # Music Recognition: No
    # Hearing: No
    # Fast User Switching: No
    # Keyboard Brightness: No
    # Spotlight: No
    # Siri: No
    # Time Machine: No
    # Weather: No
  };
}
