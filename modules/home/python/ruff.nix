{
  flake.modules = {
    homeManager.python =
      { pkgs, ... }:
      {
        programs.ruff = {
          enable = true;
          settings = {
            format = {
              docstring-code-format = true;
              preview = true;
            };
            lint = {
              preview = true;
              select = [
                # ruff defaults
                "E4"
                "E7"
                "E9"
                "F"
                # imports
                "F401"
                "I"
                # simplify statements
                "SIM"
                # comprehensions
                "C4"
                # builtins
                "A"
                # unused arguments
                "ARG"
                # naming conventions
                "N"
                # python upgrades
                "UP"
              ];
            };
          };
        };
      };
  };
}
