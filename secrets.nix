let
  # User key (for editing secrets)
  gyoge = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINeLKsNk5QwpzxjRFyRFMaxfKfR2FhTugVCpR6xh91sC yogesh@gyoge.com";

  # System host key (for system to decrypt during activation)
  macbook = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAII0uPML4VdFqkRrCRKbMnBTQVZUJFPWTS2yYJ0FXlX90 root@mbp";

  users = [ gyoge ];
  systems = [ macbook ];
in
{
  "secrets/uva-profile.mobileconfig.age".publicKeys = users ++ systems;
}
