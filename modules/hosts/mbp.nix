{ den, __findFile, ... }:
{
  # gyoge's primary aspect; automatically attached to the declared user.
  den.aspects.gyoge.includes = [
    den.aspects.base._
    den.aspects.desktop._
    den.aspects.shell._
    den.aspects.languages._
    den.aspects.nixvim._
    den.aspects.office
    den.aspects.macos._
    den.aspects.pi
    den.aspects.nh
  ];

  den.hosts.aarch64-darwin.mbp.users.gyoge = { };
}
