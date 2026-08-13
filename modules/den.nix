{ lib, ... }:
{
  # enable hm for all users
  den.schema.user.classes = lib.mkDefault [ "homeManager" ];
}
