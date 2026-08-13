{
  den,
  lib,
  ...
}:
let
  hmPlatforms =
    { aspect-chain, ... }:
    den.batteries.forward {
      each = [ "Darwin" ];
      fromClass = platform: "hm${platform}";
      intoClass = _: "homeManager";
      intoPath = _: [ ];
      fromAspect = _: lib.head aspect-chain;
      guard = { pkgs, ... }: platform: lib.mkIf pkgs.stdenv."is${platform}";
      adaptArgs = { config, ... }: { osConfig = config; };
    };
in
{
  _module.args.__findFile = den.lib.__findFile;
  den.schema.user.includes = [ hmPlatforms ];
}
