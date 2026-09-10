{ ... }:
{
  imports = [ ../system/x11.nix ];

  services.xserver.desktopManager.xfce.enable = true;
}
