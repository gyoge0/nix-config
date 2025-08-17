{ inputs, ... }:
{
  flake.modules.darwin.brew.homebrew = {
    enable = true;
  };
}
