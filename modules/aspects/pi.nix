{
  den,
  inputs,
  ...
}:
{
  # NOTE: pi.nix's flake nixConfig requests the pi.cachix.org substituter;
  # we deliberately do not trust it -- the package builds locally from the
  # pinned upstream revision.
  flake-file.inputs.pi = {
    url = "github:lukasl-dev/pi.nix";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  den.aspects.pi.homeManager =
    { pkgs, ... }:
    let
      # Deploy every file in a directory to ~/.pi/agent/<target>/<name>.
      # Used for agent definitions and prompt templates.
      mapToPi =
        target: dir:
        builtins.listToAttrs (
          builtins.map (name: {
            name = ".pi/agent/${target}/${name}";
            value.source = dir + "/${name}";
          }) (builtins.attrNames (builtins.readDir dir))
        );
      # Deploy loose extension files; skips subdirectories like subagent/,
      # which are wired explicitly below.
      looseExtensions =
        dir:
        builtins.listToAttrs (
          builtins.map
            (name: {
              name = ".pi/agent/extensions/${name}";
              value.source = dir + "/${name}";
            })
            (
              builtins.filter (name: (builtins.readDir dir).${"${name}"} == "regular") (
                builtins.attrNames (builtins.readDir dir)
              )
            )
        );
    in
    {
      home.packages = [
        inputs.pi.packages.${pkgs.stdenv.hostPlatform.system}.coding-agent
      ];

      home.file =
        (looseExtensions ../../include/pi/extensions)
        // {
          # Vendored subagent extension (from pi's examples, models adapted
          # for openrouter). Vendored rather than pinned so agent model
          # frontmatter can be edited and upgrades can't break symlinks.
          ".pi/agent/extensions/subagent/index.ts".source = ../../include/pi/extensions/subagent/index.ts;
          ".pi/agent/extensions/subagent/agents.ts".source = ../../include/pi/extensions/subagent/agents.ts;
        }
        # Agent definitions and workflow prompts
        // (mapToPi "agents" ../../include/pi/agents)
        // (mapToPi "prompts" ../../include/pi/prompts);
    };
}
