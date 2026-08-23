{
  den.aspects.macos.screenshots.homeManager =
    { config, ... }:
    {
      targets.darwin.defaults."com.apple.screencapture" = {
        include-date = true;
        location = "${config.home.homeDirectory}/Pictures/Screenshots/";
      };
    };
}
