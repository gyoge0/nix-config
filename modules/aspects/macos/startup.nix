# System scope by necessity: boot chime is an NVRAM write
# (`system.nvram.variables."StartupMute"`).
{
  den.aspects.macos.startup.darwin.system.startup.chime = true;
}
