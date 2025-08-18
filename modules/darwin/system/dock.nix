{ ... }:
{
  flake.modules.darwin.system.system.defaults.dock = {
    appswitcher-all-displays = false;
    autohide = false;
    mineffect = "genie";
    minimize-to-application = false;
    mru-spaces = false;
    show-process-indicators = true;
    show-recents = true;
    persistent-apps = [
      { app = "/System/Applications/Launchpad.app"; }
      { app = "/System/Cryptexes/App/System/Applications/Safari.app"; }
      { app = "/System/Applications/Messages.app"; }
      { app = "/System/Applications/Photos.app"; }
      { app = "/System/Applications/Calendar.app"; }
      { app = "/System/Applications/Notes.app"; }
      { app = "/System/Applications/Music.app"; }
      { app = "/System/Applications/System Settings.app"; }
      { app = "/Applications/Firefox.app"; } # brew
      { app = "/Applications/Claude.app"; } # brew
      { app = "/Applications/Ghostty.app"; } # brew
      { app = "/Applications/CotEditor.app/"; } # brew
      { app = "/Applications/Microsoft Outlook.app"; } # brew
      { app = "/System/Applications/iPhone Mirroring.app"; }
    ];
  };
}
