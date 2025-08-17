{ inputs, ... }:
{
  flake.modules.darwin.brew.homebrew.masApps = {
    "Cot Editor" = 1024640650;
    "XCode" = 497799835;
  };
}
