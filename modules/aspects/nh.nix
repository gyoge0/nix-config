# nh for switching generations; nix-output-monitor is used automatically by
# nh during builds when present on PATH.
{
  den.aspects.nh.homeManager =
    { config, pkgs, ... }:
    {
      home.packages = with pkgs; [
        nh
        nix-output-monitor
      ];

      home.sessionVariables.NH_FLAKE = "${config.home.homeDirectory}/nix-config";
    };
}
