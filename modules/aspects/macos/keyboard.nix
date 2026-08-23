# User-scope macOS keyboard defaults. Caps-lock remap needs hidutil, which
# this HM release has no targets.darwin.keyboard module for -- the darwin
# class (system scope) is used for that part instead.
{
  den.aspects.macos.keyboard = {
    homeManager.targets.darwin.defaults.NSGlobalDomain.InitialKeyRepeat = 30;
    darwin.system.keyboard = {
      enableKeyMapping = true;
      remapCapsLockToEscape = true;
    };
  };
}
