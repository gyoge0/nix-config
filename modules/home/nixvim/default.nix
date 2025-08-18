{ inputs, ... }:
{
  flake.modules = {
    homeManager.nixvim =
      { ... }:
      {
        imports = [
          inputs.nixvim.homeModules.nixvim
        ];
        programs.nixvim = {
          enable = true;
          defaultEditor = true;
        };
      };
  };
}
