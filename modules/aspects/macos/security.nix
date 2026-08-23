# System scope by necessity: PAM for sudo cannot be configured per-user.
{
  den.aspects.macos.security.darwin.security = {
    pam.services.sudo_local.enable = true;
    pam.services.sudo_local.touchIdAuth = true;
  };
}
