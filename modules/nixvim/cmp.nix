{
  den.aspects.nixvim.cmp.nixvim = {
    plugins = {
      blink-cmp = {
        enable = true;
        settings = {
          keymap = {
            # I like super-tab but I use Enter to insert text
            # Ideally, enter would overwrite and tab would insert (a la intellij)
            preset = "super-tab";
            "<CR>" = [
              "select_and_accept"
              "fallback"
            ];
          };
          completion = {
            documentation = {
              auto_show = true;
            };
            list.selection.auto_insert = false;
          };
          signature = {
            enabled = true;
          };
        };
      };
    };
  };
}
