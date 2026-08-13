{
  den.aspects.nixvim.lsp.nixvim = {
    plugins.lspconfig.enable = true;
    lsp = {
      servers = {
        beancount.enable = true;
        clangd.enable = true;
        docker_language_server.enable = true;
        html.enable = true;
        jinja_lsp.enable = true;
        jsonls.enable = true;
        just.enable = true;
        lua_ls.enable = true;
        marksman.enable = true; # markdown
        neocmake.enable = true;
        nil_ls.enable = true; # todo: get nixd working
        oxfmt.enable = true;
        oxlint.enable = true;
        ruff.enable = true;
        rust_analyzer.enable = true;
        svelte.enable = true;
        tailwindcss.enable = true;
        terraform-ls.enable = true;
        tinymist.enable = true; # typst
        tsgo.enable = true; # todo: update for official ts release
        ty.enable = true;
        yamlls.enable = true;
        zls.enable = true;
      };
    };
  };
}
