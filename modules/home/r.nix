{
  flake.modules = {
    homeManager.r =
      { pkgs, ... }:
      {
        home.packages = with pkgs; [
          # not working for now
          # R
          # gui apps done with brew for now
          # rstudio
        ];
      };
  };
}
