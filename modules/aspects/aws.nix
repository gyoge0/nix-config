{
  den.aspects.aws.homeManager =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        awscli2
        ssm-session-manager-plugin
      ];
    };
}
