{
  den,
  inputs,
  lib,
  ...
}:
let
  # Nixvim's standalone API is the right boundary for the flake package.  The
  # module API remains useful for HM, where Nixvim owns the integration.
  nixvimPackage =
    # Full application: `{ system }` is a context arg, so den calls this
    # directly and the returned module is applied in the flake-system scope.
    { system }:
    { config, ... }: {
      options.nixvimModule = lib.mkOption {
        type = lib.types.deferredModule;
        default = { };
        description = "The merged Den Nixvim class module.";
      };

      config.packages.nixvim =
        (inputs.nixvim.lib.evalNixvim {
          inherit system;
          modules = [ config.nixvimModule ];
        }).config.build.package;
    };

  # A custom class is deliberately just Nixvim's module-shaped freeform data.
  # This means feature aspects can say `nixvim = { ... }` without knowing where
  # the eventual editor is installed.
  nixvimToFlake =
    { ... }:
    den.batteries.forward {
      # `nixvim` is a class, not a namespace.  Collect it from every aspect;
      # `den.aspects.nixvim` is only the current organizational grouping.
      each = lib.attrValues den.aspects;
      fromClass = _: "nixvim";
      intoClass = _: "flake-system";
      intoPath = _: [ "nixvimModule" ];
      fromAspect = lib.id;
    };

  nixvimToHome =
    { user, ... }:
    den.batteries.forward {
      each = [ user ];
      fromClass = _: "nixvim";
      intoClass = _: "homeManager";
      intoPath = _: [
        "programs"
        "nixvim"
      ];
    };
in
{
  # Declare the nixvim input here, next to where it is used.
  flake-file.inputs.nixvim = {
    url = "github:nix-community/nixvim/nixos-26.05";
    # override nixpkgs to reduce closure size
    # if things break with nixvim, remove this first!
    inputs.nixpkgs.follows = "nixpkgs";
  };

  den.classes.nixvim = { };

  # Build one shared standalone Nixvim package per system.
  den.schema.flake-system.includes = [
    nixvimToFlake
    nixvimPackage
  ];

  # Make the same class available to every Home Manager user that includes
  # the nixvim aspect.  The Nixvim HM module is imported at the integration
  # boundary, keeping feature aspects independent of Home Manager.
  den.schema.user.includes = [ nixvimToHome ];

  # This child aspect is included (via `._`) at user scope.  Importing
  # Nixvim's HM module + enabling it here keeps feature aspects independent
  # of where the editor ends up being installed.
  den.aspects.nixvim.editor.homeManager = {
    imports = [ inputs.nixvim.homeModules.nixvim ];
    programs.nixvim.enable = lib.mkDefault true;
    programs.nixvim.nixpkgs.source = inputs.nixpkgs;
  };
}
