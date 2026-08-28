{
  den.aspects.desktop.vscode.homeManager = { pkgs, lib, ... }: {
    # todo: there is a vscodium option instead of overriding the package
    programs.vscode = {
      enable = true;
      package = pkgs.vscodium;
      profiles.default = {
        enableExtensionUpdateCheck = false;
        enableUpdateCheck = false;
        extensions = with pkgs.vscode-extensions; [
          myriad-dreamin.tinymist
          vscodevim.vim
        ];
        userSettings = {
          extensions.autoUpdate = false;
          editor.minimap.enabled = false;
        };
      };
    };
    # alias of code to codium
    home.packages = [
      (pkgs.symlinkJoin {
         name = "vscodium-code-alias";
         paths = [ pkgs.vscodium ];

         postBuild = ''
           ln -s ${lib.getExe' pkgs.vscodium "codium"} "$out/bin/code"
         '';
       })
    ];
  };
}
