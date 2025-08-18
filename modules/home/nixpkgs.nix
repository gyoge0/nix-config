{ ... }:

{
  flake.modules = {
    homeManager.nixpkgs =
      { ... }:
      {
        nixpkgs.config.allowUnfree = true;
      };
  };
}
