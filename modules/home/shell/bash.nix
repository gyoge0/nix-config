{
  flake.modules = {
    homeManager.shell =
      { ... }:
      {
        programs.bash = {
          enable = true;
          enableCompletion = true;
          shellAliases = {
            ls = "ls -CF --color=auto";
            la = "ls -CFA --color=auto";
            ll = "ls -lFa --color=auto";
            upr = "source ~/.bashrc";
            epr = "$EDITOR ~/.bashrc";
          };
          # ignore lines starting with space and duplicates
          historyControl = [ "ignoreboth" ];
          sessionVariables = {
            # the short delay from starship ticks me off
            # this is a modified ubuntu prompt that I set directly
            PS1 = ''''${debian_chroot:+(''$debian_chroot)}\[\033[90m\]bash \[\033[01;32m\]''${USER/gyoge/}@''${HOSTNAME/Yogesh-S540/} \[\033[01;34m\]\w\[\033[00m\] ''$ '';
          };
        };
      };
  };
}
