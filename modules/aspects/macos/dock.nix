# User-scope dock configuration. HM-installed apps land in
# ~/Applications/Home Manager Apps, which the persistent-apps reference.
{
  den.aspects.macos.dock.homeManager =
    { config, ... }:
    {
      targets.darwin.defaults."com.apple.dock" = {
        appswitcher-all-displays = false;
        autohide = false;
        mineffect = "genie";
        minimize-to-application = false;
        mru-spaces = false;
        show-process-indicators = true;
        show-recents = true;
        persistent-apps = [
          { app = "/System/Cryptexes/App/System/Applications/Safari.app"; }
          { app = "/System/Applications/Messages.app"; }
          { app = "/System/Applications/Photos.app"; }
          { app = "/System/Applications/Calendar.app"; }
          { app = "/System/Applications/Notes.app"; }
          { app = "${config.home.homeDirectory}/Applications/Home Manager Apps/Spotify.app"; }
          { app = "/System/Applications/System Settings.app"; }
          { app = "${config.home.homeDirectory}/Applications/Home Manager Apps/Firefox.app"; }
          { app = "/Applications/ChatGPT.app"; } # brew
          { app = "/Applications/Ghostty.app"; } # brew
          { app = "/Applications/CotEditor.app/"; } # brew
          { app = "/Applications/Microsoft Outlook.app"; } # brew
          { app = "/System/Applications/iPhone Mirroring.app"; }
        ];
      };
    };
}
