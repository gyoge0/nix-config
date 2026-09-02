{
  den.aspects.desktop.discord = {
    homeManager = { pkgs, ... }: {
#      programs.discord = {
#        enable = true;
#        settings.SKIP_HOST_UPDATE = true;
#        package = pkgs.discord.override {
#          # todo: get rid of this python script
#          #disableUpdates = false;
#        };
#      };
    };
    darwin.homebrew.casks = [
      "discord"
    ];
  };
}
