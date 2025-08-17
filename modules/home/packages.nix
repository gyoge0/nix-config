{
  flake.modules = {
    homeManager.packages = { pkgs, ... }: {
      home.packages = with pkgs; [
        vim
        curl
        wget
        htop
        tree
        bat
        unzip
        zip
        tmux
      ];
    };
  };
}
