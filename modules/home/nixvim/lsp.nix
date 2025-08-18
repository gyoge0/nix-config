{ ... }:
{
  flake.modules.homeManager.nixvim.programs.nixvim = {
    plugins.lspconfig.enable = true;
    lsp = {
      servers = {
        nil_ls.enable = true;
      };
    };
  };
}
