{
  den.aspects.shell.starship.homeManager = {
    programs.starship = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
      enableInteractive = true;
      settings = {
        # get editor completions based on the config schema
        "$schema" = "https://starship.rs/config-schema.json";
        # inserts a blank line between shell prompts
        add_newline = false;
        # todo: fix spacing after shell
        format = "$nix_shell$shell$username[@](green)$hostname $directory $character";
        nix_shell = {
          format = "[\\(nix\\) ](purple)";
          heuristic = true;
        };
        shell = {
          zsh_indicator = "zsh";
          # todo: fix spacing after shell
          bash_indicator = "bsh";
          # todo: different colors for different shells
          style = "bold yellow";
          disabled = false;
        };
        username.format = "[$user](yellow)";
        hostname.format = "[@$hostname](yellow)";
        directory = {
          format = "[$path](blue)";
          truncation_length = 0;
          truncate_to_repo = false;
        };
        character = {
          success_symbol = "[\\$](white)";
          error_symbol = "[\\$](white)";
        };
      };
    };
  };
}
